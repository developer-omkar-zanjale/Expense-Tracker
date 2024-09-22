//
//  RecentTransactionView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import SwiftUI

struct RecentTransactionView: View {

    @EnvironmentObject var transactionListVM: TransactionListViewModel
    var body: some View {
        VStack {
            HStack {
                //MARK: Title
                Text(StringConstant.recentTransactions)
                    .bold()
                Spacer()
                //MARK: See all
                NavigationLink {
                    TransactionListView()
                } label: {
                    HStack(spacing: 4) {
                        Text(StringConstant.seeAll)
                        Image(systemName: ImageConstant.SYS_chevron_right)
                    }
                    .foregroundColor(Color.text)
                }
                
            }
            .padding(.top)
            let recentTransactions = transactionListVM.transactionList.sorted {$0.parsedDate.compare($1.parsedDate) == .orderedDescending}.prefix(5)
            
            ForEach(Array(recentTransactions.enumerated()), id: \.element) { index, transaction in
                TransactionRowView(transaction: transaction)
                Divider()
                    .opacity(index == (recentTransactions.count - 1) ? 0 : 1)
            }
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct RecentTransactionView_Previews: PreviewProvider {
   
    static var previews: some View {
        NavigationView {
            RecentTransactionView()
                .environmentObject(TransactionListViewModel())
        }
    }
}
