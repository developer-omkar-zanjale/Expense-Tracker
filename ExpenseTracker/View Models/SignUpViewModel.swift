//
//  SignUpViewModel.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 06/01/23.
//

import UIKit
import CoreData

class SignUpViewModel {
    
    private let viewContext = PersistenceController.shared.container.viewContext

    func checkUserAvailability(email: String) -> (result: Bool, alertMessage: String) {
        if Constant.isEmailValid(email: email) {
            do {
                let allUsers = try viewContext.fetch(UserData.fetchRequest())
                if allUsers.filter({$0.email == email}).count == 0 {
                    return (true, "")
                } else {
                    return (false, "Email already used!")
                }
            } catch {
                print("Error while fetching data: ",error.localizedDescription)
                return (false, "Database Error")
            }
        }
        return (false, "Invalid Email!")
    }
    
    func createUser(name: String, email: String, password: String, confirmPassword: String, selectedImage: UIImage) -> (result: Bool, alertMessage: String) {
        let validationResult = validateInputes(name: name, email: email, password: password, confirmPassword: confirmPassword)
        if validationResult.result {
            let user = UserData(context: viewContext)
            user.name = name
            user.email = email
            user.password = password
            user.profileImage = selectedImage.jpegData(compressionQuality: 0.8)
            if saveContext() {
                return (true, "")
            } else {
                return (false,"Unable to create account")
            }
        }
        return (false, validationResult.alertMessage)
    }
    
    private func saveContext() -> Bool {
        do {
            try viewContext.save()
            return true
        } catch {
            let error = error as NSError
            print("An error occured: \(error)")
            return false
        }
    }
    
    private func validateInputes(name: String, email: String, password: String, confirmPassword: String) -> (result: Bool, alertMessage: String) {
        if !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
            if Constant.isEmailValid(email: email) {
                if password == confirmPassword {
                    return (true, "")
                } else {
                    return (false, "Both Password must be same!")
                }
            } else {
                return (false, "Enter Valid Email!")
            }
        } else {
            return (false, "Please enter all details.")
        }
    }
}
