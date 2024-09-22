//
//  TransactionListView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 29/12/22.
//

import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                List {
                    ForEach(Array(transactionListVM.getGroupTransactionsByMonth()), id: \.key) {key, transactions in
                        //MARK: Transaction Months
                        Section {
                            //MARK: Transactions
                            ForEach(transactions) { transaction in
                                TransactionRowView(transaction: transaction)
                            }
                        } header: {
                            Text(key)
                        }
                        .listSectionSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(StringConstant.transactions)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionListView_Previews: PreviewProvider {

    static var previews: some View {
        
        NavigationView {
            TransactionListView()
                .environmentObject(TransactionListViewModel())
        }
    }
}
