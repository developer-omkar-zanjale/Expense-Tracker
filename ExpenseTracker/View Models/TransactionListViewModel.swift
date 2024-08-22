//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import Foundation
import Combine
import OrderedCollections
import CoreData

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

class TransactionListViewModel: ObservableObject {
    
    @Published var transactionList = [Transaction]()
    @Published var currentUser: UserData? {
        didSet {
            getUserTransactions()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func saveTransaction(transaction: Transaction) -> Bool {
        let transactionData = TransactionData(context: viewContext)
        transactionData.id = Int64(transaction.id)
        transactionData.date = transaction.date
        transactionData.institution = transaction.institution
        transactionData.account = transaction.account
        transactionData.merchant = transaction.merchant
        transactionData.amount = transaction.amount
        transactionData.type = transaction.type
        transactionData.categoryId = Int64(transaction.categoryId)
        transactionData.category = transaction.category
        transactionData.isPending = transaction.isPending
        transactionData.isTransfer = transaction.isTransfer
        transactionData.isExpense = transaction.isExpense
        transactionData.isEdited = transaction.isEdited
        transactionData.userdata = currentUser
        do {
            try viewContext.save()
            return true
        } catch {
            print("Error saving Transaction: ",error.localizedDescription)
            return false
        }
  
    }
    
    func getUserTransactions() {
        
        if let transactions = currentUser?.transactiondata {
            let transactionArray = Array(transactions) as? [TransactionData]
            let usersTransactions: [Transaction] = transactionArray?.map({ transaction in
                var newTransaction = Transaction()
                newTransaction.id = Int(transaction.id)
                newTransaction.date = transaction.date ?? Date.getCurrentDate()
                newTransaction.institution = transaction.institution ?? ""
                newTransaction.account = transaction.account ?? ""
                newTransaction.merchant = transaction.merchant ?? ""
                newTransaction.amount = transaction.amount
                newTransaction.type = transaction.type ?? ""
                newTransaction.categoryId = Int(transaction.categoryId)
                newTransaction.category = transaction.category ?? ""
                newTransaction.isPending = transaction.isPending
                newTransaction.isTransfer = transaction.isTransfer
                newTransaction.isExpense = transaction.isExpense
                newTransaction.isEdited = transaction.isEdited
                return newTransaction
            }) ?? []
            print("Founded user transactions: \(usersTransactions.count)")
            self.transactionList = usersTransactions
        }
    }
    
    func getDemoTransactionList() {
        
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .failure(let error):
                    print("Error while decoding Transactions: ",error.localizedDescription)
                case .finished:
                    print("Decoding transaction finished.")
                }
            } receiveValue: { [weak self]result in
                self?.transactionList = result
                dump(self?.transactionList)
            }
            .store(in: &cancellables)
    }
    
    func getGroupTransactionsByMonth() -> TransactionGroup {
        guard !transactionList.isEmpty else {return [:]}
        let groupedTransactions = TransactionGroup(grouping: transactionList) { $0.month }
        return groupedTransactions
    }
    
    private func accumulateTransactions(forCurrentDate: Bool, intervalOf: Calendar.Component) -> TransactionPrefixSum {
        guard !transactionList.isEmpty else { return [] }
        let sortedTransactions = transactionList.sorted(by: {$0.parsedDate.compare($1.parsedDate) == .orderedDescending})
        var startDate: Date
        var endDate: Date
        
        if forCurrentDate {
            startDate = Calendar.current.dateInterval(of: intervalOf, for: Date.getCurrentDate().parsedDate())!.start
            endDate = Date.getCurrentDate().parsedDate()
        } else {
            if intervalOf == .month {
                startDate = sortedTransactions.count > 10 ? sortedTransactions[10].parsedDate : sortedTransactions.last?.parsedDate ?? Date()
                endDate = sortedTransactions.first?.parsedDate ?? Date.getCurrentDate().parsedDate()
            } else if intervalOf == Calendar.Component.fiveDays {
                startDate = sortedTransactions.count > 5 ? sortedTransactions[5].parsedDate : sortedTransactions.last?.parsedDate ?? Date()
                endDate = sortedTransactions.first?.parsedDate ?? Date.getCurrentDate().parsedDate()
            } else {
                startDate = sortedTransactions.last?.parsedDate ?? Date.getCurrentDate().parsedDate()
                endDate = sortedTransactions.first?.parsedDate ?? Date.getCurrentDate().parsedDate()
            }
        }
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate) ?? Date.getCurrentDate().parsedDate()
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        let arrayOfDates = stride(from: startDate, to: nextDate, by: 60 * 60 * 24)
        
        for date in arrayOfDates {
            let dailyExpenses = transactionList.filter({ $0.parsedDate == date && $0.isExpense })
            let dailyTotal = dailyExpenses.reduce(0) {$0 - $1.signedAmount}
            
            sum += dailyTotal
            sum = sum.rounded()
//            let calendarDate = Calendar.current.dateComponents([.day], from: date)
//            let day = Double(calendarDate.day!)
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "Daily total: ", dailyTotal, "sum", sum)
            
        }
        return cumulativeSum
    }
    
    func getChartDataFor(interval: String) -> TransactionPrefixSum {
        switch interval {
        case TransactionInterval.thisMonth.rawValue:
            return accumulateTransactions(forCurrentDate: true, intervalOf: .month)
        case TransactionInterval.last10Transactions.rawValue:
            return accumulateTransactions(forCurrentDate: false, intervalOf: .month)
        case TransactionInterval.thisYear.rawValue:
            return accumulateTransactions(forCurrentDate: true, intervalOf: .year)
        case TransactionInterval.last5Transactions.rawValue:
            return accumulateTransactions(forCurrentDate: false, intervalOf: Calendar.Component.fiveDays)
        case TransactionInterval.all.rawValue:
            return accumulateTransactions(forCurrentDate: false, intervalOf: .year)
        default:
            print("Interval case missmatch!")
            return []
        }
    }
    
    func isChartDataHaveValues(chartData: TransactionPrefixSum) -> Bool {
        if !chartData.isEmpty {
            let emptyChartData = chartData.filter({$0.1 == 0.0})
            if emptyChartData.count == chartData.count {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
