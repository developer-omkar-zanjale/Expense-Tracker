//
//  NoDataView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 12/01/23.
//

import SwiftUI

struct NoDataView: View {
    var title: String
    var showButton: Bool
    var buttonTitle: String = ""
    var buttonImageName = ImageConstant.SYS_arrow_down_doc
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .circular)
                .fill(Color.systemBackground)
                .background(Color.systemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            VStack(alignment: .center) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.red)
                    .padding()
                if showButton {
                    Button {
                        transactionListVM.getDemoTransactionList()
                    } label: {
                        Text(buttonTitle)
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.primary)
                        Image(systemName: buttonImageName)
                            .tint(.primary)
                    }
                    .padding(8)
                    .border(Color.red)
                    .padding()
                }
            }
        }
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataView(title: "text", showButton: true, buttonTitle: "Button")
    }
}
