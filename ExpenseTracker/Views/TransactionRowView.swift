//
//  TransactionRowView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import SwiftUI
import SwiftUIFontIcon

struct TransactionRowView: View {
    
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 20) {
            
            RoundedRectangle(cornerRadius: 20, style: .circular)
                .fill(Color.icon.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: transaction.icon), fontsize: 24, color: Color.icon)
                }
            VStack(alignment: .leading, spacing: 6) {
                //MARK: Transaction Merchant
                Text(transaction.merchant)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                //MARK: Transaction Category
                Text(transaction.category)
                    .font(.footnote)
                    .opacity(0.6)
                    .lineLimit(1)
                
                //MARK: Transaction Date
                Text(transaction.parsedDate, format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            //MARK: Transaction Amount
            Text(transaction.signedAmount, format: .currency(code: "USD"))
                .bold()
                .foregroundColor(transaction.type == TransactionType.debit.rawValue ? Color.red : .green)
        }
        .padding([.top,.bottom], 8)
    }
}

struct TransactionRowView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRowView(transaction: transactionPreview)
    }
}
