//
//  SignUpViewModel.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 06/01/23.
//

import UIKit
import CoreData

class SignUpViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isOpenImagePicker = false
    @Published var selectedImage: UIImage = UIImage()
    @Published var isAlertShown = false
    @Published var alertTitle = AlertConstant.somethingWentWrong
    @Published var isEmailVerified = false
    @Published var isPasswordVerified = false
    @Published var isShowToastMesssage: Bool = false
    
    
    private let coreDataService = CoreDataService.shared
    let logService = LoggerService()

    func checkUserAvailability(email: String) -> (result: Bool, alertMessage: String) {
        if AppConstant.isEmailValid(email: email) {
            if let _ = coreDataService.readUsers(email: email, fetchLimit: 1).first {
                return (false, AlertConstant.emailAlreadyUsed)
            } else {
                return (true, "")
            }
        }
        return (false, AlertConstant.invalidEmail)
    }
    
    func createUser(name: String, email: String, password: String, confirmPassword: String, selectedImage: UIImage) -> (result: Bool, alertMessage: String) {
        let validationResult = validateInputes(name: name, email: email, password: password, confirmPassword: confirmPassword)
        if validationResult.result {
            let result = coreDataService.createUser(name: name, email: email, password: password, selectedImage: selectedImage)
            return (result, result ? "" : AlertConstant.unableToCreateAccount)
        }
        return (false, validationResult.alertMessage)
    }
    
    private func validateInputes(name: String, email: String, password: String, confirmPassword: String) -> (result: Bool, alertMessage: String) {
        if !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
            if AppConstant.isEmailValid(email: email) {
                if password == confirmPassword {
                    return (true, "")
                } else {
                    return (false, AlertConstant.bothPasswordMustBeSame)
                }
            } else {
                return (false, AlertConstant.enterValidEmail)
            }
        } else {
            return (false, AlertConstant.pleaseEnterAllDetails)
        }
    }
}
