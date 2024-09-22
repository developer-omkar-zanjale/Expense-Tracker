//
//  Constants.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 30/12/22.
//

import SwiftUI

let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height

struct AppConstant {
    static var signUpFromFinger = false
    
    static func isEmailValid(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isPasswordValid(password: String) -> Bool {
        if password.count >= 8 && password.count <= 16 {
            let regexForSpecialChar = ".*[^A-Za-z0-9].*"
            let alphaNumStr = NSPredicate(format:"SELF MATCHES %@", regexForSpecialChar)
            let isSpecialCharPresent = alphaNumStr.evaluate(with: password)
            let isNumberPresent = password.contains(where: {$0.isNumber})
            let isUppercasePresent = password.contains(where: {$0.isUppercase})
            let isWhitespacePresent = password.contains(where: {$0.isWhitespace})
            
            if isSpecialCharPresent && isNumberPresent && isUppercasePresent && !isWhitespacePresent {
                return true
            }
        }
        return false
    }
    
    static var lastTransactionID = 0
    
    static let FalseStr = "False"
    
}

enum UserDefaultKeys: String {
    case isFingerActivated = "FingerprintActivated"
    case isNotFirstLaunch = "FirstLaunch"
    case currentUserName = "CurrentUserName"
    case currentUserPassword = "CurrentUserPassword"
    case previousTransactionId = "PreviousTransactionId"
}

enum Decision: String {
    case False = "False"
    case True = "True"
}

enum TransactionInterval: String {
    case thisMonth = "This Month"
    case last10Transactions = "Last 10"
    case last5Transactions = "Last 5"
    case thisYear = "This Year"
    case all = "All"
}

struct ImageConstant {
    //MARK: GIF
    static let GIFMoney = "money"
    static let GIFTransactionDone = "TransactionDone"
    static let GIFHello = "hello"
    
    //MARK: Local Images
    static let fingerprint = "fingerprint"
    static let india = "india"
    
    //MARK: System Image
    static let SYS_chevron_right = "chevron.right"
    static let SYS_person = "person"
    static let SYS_envelope = "envelope"
    static let SYS_person_badge_key = "person.badge.key"
    static let SYS_arrow_down_doc = "arrow.down.doc"
}

struct StringConstant {
    static let getStarted = "Get Started"
    static let welcome = "Welcome"
    static let signIn = "Sign In"
    static let india = "India"
    static let newHere = "New Here?"
    static let register = "Register"
    static let signUp = "Sign Up"
    static let chooseProfile = "Choose Profile"
    static let overview = "Overview"
    static let intervals = "Intervals"
    static let selectInterval = "Select Interval"
    static let noExpensesFoundFor = "No Expenses Found For"
    static let interval = "Interval"
    static let getDemoTransactions = "Get Demo Transactions"
    static let noRecentTransactionsAddTransactionFromTopbar = "No Recent Transactions! \nAdd transaction from top bar"
    static let recentTransactions = "Recent Transactions"
    static let seeAll = "See all"
    static let transactions = "Transactions"
    static let noName = "No Name"
    static let noEmail = "No Email"
    static let noPassword = "No Password"
    static let home = "Home"
    static let addNewTransaction = "Add New Transaction"
    static let merchantName = "Merchant Name"
    static let category = "Category"
    static let amount = "Amount"
    static let transactionType = "Transaction Type"
    static let transactionTransferStatus = "Transaction Transfer Status"
    static let transactionPendingStatus = "Transaction Pending Status"
    static let isExpense = "Is Expense"
    static let addTransaction = "Add Transaction"
    static let select = "Select"
    
    //MARK: PLaceholders
    static let username = "Username"
    static let password = "Password"
    static let name = "Name"
    static let email = "Email"
    static let confirmPassword = "Confirm Password"
}

struct AlertConstant {
    //MARK: Message
    static let pleaseTryAgain = "Please try again!"
    static let somethingWentWrong = "Something Went Wrong!"
    static let pleaseSignInToActivateFingerprint = "Please Sign In to activate Fingerprint."
    static let passwordValidation = "Password must be 8-16 Characters & must contain Uppercase, Number, Special Character & no White Spaces"
    static let bothPasswordMustBeSame = "Both passwords must be same!"
    static let transactionAdded = "Transaction Added."
    static let unableToAddFillAppropriateData = "Unable to add. Fill appropriate data!"
    static let unableToSignInAtThisMomentPleaseTryAgain = "Unable to sign in at this moment!\nPlease try again."
    static let validUser = "Valid user"
    static let wrongEmailOrPassword = "Wrong Email or Password!"
    static let invalidEmailFormat = "Invalid Email Format"
    static let enterEmailNPassword = "Enter Email & Password!"
    static let emailAlreadyUsed = "Email already used!"
    static let invalidEmail = "Invalid Email!"
    static let unableToCreateAccount = "Unable to create account"
    static let enterValidEmail = "Enter Valid Email!"
    static let pleaseEnterAllDetails = "Please enter all details."
    
    //MARK: Title
    static let OK = "OK"
}

enum Fonts {
    static let figtreeBlack = "Figtree-Black"
    static let figtreeBold = "Figtree-Bold"
    static let figtreeExtraBold = "Figtree-ExtraBold"
    static let figtreeLight = "Figtree-Light"
    static let figtreeMedium = "Figtree-Medium"
    static let figtreeRegular = "Figtree-Regular"
    static let figtreeSemiBold = "Figtree-SemiBold"
    static let figtreeVariableFont_wght = "Figtree-VariableFont_wght"
    static let figtreeItalic = "Figtree-Italic"
    static let figtreeLightItalic = "Figtree-LightItalic"
}
