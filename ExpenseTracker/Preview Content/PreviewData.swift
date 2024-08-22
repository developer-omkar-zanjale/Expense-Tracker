//
//  PreviewData.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import Foundation

var transactionPreview = Transaction(id: 2, date: "28/12/2022", institution: "Desjardins", account: "Visa Desjardins", merchant: "Apple", amount: 20.00, type: TransactionType.debit.rawValue, categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

let transactionListPreviewData = [Transaction](repeating: transactionPreview, count: 10)
