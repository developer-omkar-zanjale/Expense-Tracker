//
//  AddTransactionViewModel.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 10/01/23.
//

import Foundation

class AddTransactionViewModel: ObservableObject {
    
    @Published var merchant = ""
    @Published var transactionType = ""
    @Published var isTransfer = ""
    @Published var isExpense = ""
    @Published var isPending = ""
    @Published var amount = ""
    @Published var category = ""
    @Published var isAlertShown = false
    @Published var isAddTransactionClicked = false
    @Published var alertTitle = AlertConstant.unableToAddFillAppropriateData
    
    let categories: [String] = Category.allCategories.map({$0.name})
    let transactionTypes = [TransactionType.debit.rawValue, TransactionType.credit.rawValue]
    let transactionDecisions:[String] = [Decision.True.rawValue, Decision.False.rawValue]
    
    
    func addTransaction() -> Transaction? {
        if merchant.isEmpty||category.isEmpty||amount.isEmpty||transactionType.isEmpty||isTransfer.isEmpty||isExpense.isEmpty {
            return nil
        }
        var newTransaction = Transaction()
        newTransaction.id = AppConstant.lastTransactionID + 1
        newTransaction.date = Date.getCurrentDate()
        newTransaction.merchant = merchant
        newTransaction.amount = Double(amount) ?? 0.0
        newTransaction.type = transactionType
        if let category = Category.allCategories.filter({$0.name == category}).first {
            newTransaction.categoryId = category.id
            newTransaction.category = category.name
        }
        if isPending.isStringHaveTrue {
            newTransaction.isPending = true
        } else {
            newTransaction.isPending = false
        }
        if isTransfer.isStringHaveTrue {
            newTransaction.isTransfer = true
        } else {
            newTransaction.isTransfer = false
        }
        if isExpense.isStringHaveTrue {
            newTransaction.isExpense = true
        } else {
            newTransaction.isExpense = false
        }
        return newTransaction
    }
    
    func resetInputes() {
        merchant = ""
        transactionType = ""
        isTransfer = ""
        isExpense = ""
        isPending = ""
        amount = ""
        category = ""
    }
}
