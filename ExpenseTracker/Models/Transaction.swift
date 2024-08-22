//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import Foundation
import SwiftUIFontIcon

struct Transaction: Identifiable, Codable, Hashable {
    var id: Int = 0
    var date: String = ""
    var institution: String = ""
    var account: String = ""
    var merchant: String = ""
    var amount: Double = 0.0
    var type: TransactionType.RawValue = ""
    var categoryId: Int = 0
    var category: String = ""
    var isPending: Bool = false
    var isTransfer: Bool = false
    var isExpense: Bool = false
    var isEdited: Bool = false
    
    var icon: FontAwesomeCode {
        if let category = Category.allCategories.first(where: {$0.id == categoryId}) {
            return category.icon
        }
        return .question
    }
    
    var parsedDate: Date {
        date.parsedDate()
    }
    
    var signedAmount: Double {
        return type == TransactionType.debit.rawValue ? -amount : amount
    }
    
    var month: String {
        let groupTransaction = parsedDate.formatted(.dateTime.year().month(.wide))
        return groupTransaction
    }
    
}

enum TransactionType: String {
    case credit = "credit"
    case debit = "debit"
}

struct Category: Identifiable, Hashable {
    let id: Int
    let name: String
    let icon: FontAwesomeCode
    var mainCategoryId: Int?
}
