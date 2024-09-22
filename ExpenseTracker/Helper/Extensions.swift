//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import Foundation
import SwiftUI

//MARK: Color
extension Color {
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
    static let dimGray = Color("DimGray")
}

//MARK: DateFormatter
extension DateFormatter {
    static let dateFormatterUSA: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}

//MARK: String
extension String {
    func parsedDate() -> Date {
        guard let parsedDate = DateFormatter.dateFormatterUSA.date(from: self) else {return Date()}
        return parsedDate
    }
    
    var isStringHaveTrue: Bool {
        switch self {
        case Decision.True.rawValue :
            return true
        case Decision.False.rawValue:
            return false
        default:
            return false
        }
    }
}

//MARK: Category
extension Category {
    static let autoAndTransport = Category(id: 1, name: "Auto & Transport", icon: .car_alt)
    static let billsAndUtilities = Category(id: 2, name: "Bills & Utilities", icon: .file_invoice_dollar)
    static let entertainment = Category(id: 3, name: "Entertainment", icon: .film)
    static let feesAndCharges = Category(id: 4, name: "Fees & Charges", icon: .hand_holding_usd)
    static let foodAndDining = Category(id: 5, name: "Food & Dining", icon: .hamburger)
    static let home = Category(id: 6, name: "Home", icon: .home)
    static let income = Category(id: 7, name: "Income", icon: .dollar_sign)
    static let shopping = Category(id: 8, name: "Shopping", icon: .shopping_cart)
    static let transfer = Category(id: 9, name: "Transfer", icon: .exchange_alt)
    
    static let publicTransportation = Category(id: 101, name: "Public Transportation", icon: .bus, mainCategoryId: 1)
    static let taxi = Category(id: 102, name: "Taxi", icon: .taxi, mainCategoryId: 1)
    static let mobilePhone = Category(id: 201, name: "Mobile Phone", icon: .mobile_alt, mainCategoryId: 2)
    static let moviesAndDVDs = Category(id: 301, name: "Movies & DVD's", icon: .film, mainCategoryId: 3)
    static let bankFee = Category(id: 401, name: "Bank Fee", icon: .hand_holding_usd, mainCategoryId: 4)
    static let financeCharge = Category(id: 402, name: "Finance Charge", icon: .hand_holding_usd, mainCategoryId: 4)
    static let gloceries = Category(id: 501, name: "gloceries", icon: .shopping_basket, mainCategoryId: 5)
    static let restaurants = Category(id: 502, name: "Restaurants", icon: .utensils, mainCategoryId: 5)
    static let rent = Category(id: 601, name: "Rent", icon: .house_user, mainCategoryId: 6)
    static let homeSupplies = Category(id: 602, name: "Home Supplies", icon: .lightbulb, mainCategoryId: 6)
    static let paycheque = Category(id: 701, name: "Paycheque", icon: .dollar_sign, mainCategoryId: 7)
    static let software = Category(id: 801, name: "Software", icon: .icons, mainCategoryId: 8)
    static let creditCardPayment = Category(id: 901, name: "Creadit Card Payment", icon: .exchange_alt, mainCategoryId: 9)
    
    static let categories: [Category] = [
        .autoAndTransport,
        .billsAndUtilities,
        .entertainment,
        .feesAndCharges,
        .foodAndDining,
        .home,
        .income,
        .shopping,
        .transfer
    ]
    
    static let subCategories: [Category] = [
        .publicTransportation,
        .taxi,
        .mobilePhone,
        .moviesAndDVDs,
        .bankFee,
        .financeCharge,
        .gloceries,
        .restaurants,
        .rent,
        .homeSupplies,
        .paycheque,
        .software,
        .creditCardPayment
    ]
    
    static let allCategories: [Category] = categories + subCategories
}

//MARK: TransactionInterval
extension TransactionInterval {
    static let allIntervals: [String] = [
        TransactionInterval.thisMonth.rawValue,
        TransactionInterval.last10Transactions.rawValue,
        TransactionInterval.last5Transactions.rawValue,
        TransactionInterval.thisYear.rawValue,
        TransactionInterval.all.rawValue
    ]
}

//MARK:

extension Calendar.Component {
    static var fiveDays: Calendar.Component {
        return .weekday
    }
}

//MARK: Date
extension Date: Strideable {
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
    
    static func getCurrentDate() -> String {
        return DateFormatter.dateFormatterUSA.string(from: Date())
    }
}

//MARK: Double
extension Double {
    func rounded2Digits() -> Double {
        return (self * 100).rounded() / 100
    }
}


//MARK: View
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    //
    //Make Rounded corner for any view
    //
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CustomRoundedCorner(radius: radius, corners: corners))
    }
}

