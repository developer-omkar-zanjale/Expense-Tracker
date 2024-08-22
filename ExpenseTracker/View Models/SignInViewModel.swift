//
//  SignInViewModel.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 06/01/23.
//

import Foundation
import LocalAuthentication

class SignInViewModel {
    
    private let viewContext = PersistenceController.shared.container.viewContext
    var isShowStartView = false
    
    init() {
        isShowStartView = checkForStartScreen()
    }
    //
    //MARK: Finger and face Auth
    //
    func fingerPrintOrFaceAuth(complition: @escaping (Bool) -> ()) {
        let contex = LAContext()
        var error: NSError?
        
        if contex.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reson = "Login to Expense Tracker"
            contex.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reson) { result, authError in
                if result {
                    print("Local authentication success.")
                } else {
                    print("Local authentication failed!")
                }
                complition(result)
                return
            }
        } else {
            complition(false)
            print("No authentication sources.")
        }
    }
    //
    //MARK: Database Search
    //
    func searchUserInDatabase(userName: String, password: String) -> (user: UserData?, alertMessage: String) {
        let validationResult = validateInputes(userName: userName, password: password)
        do {
            if validationResult.result {
                let users = try viewContext.fetch(UserData.fetchRequest())
                for user in users {
                    if user.email == userName && password == user.password {
                        if Constant.signUpFromFinger {
                            UserDefaults.standard.set(true, forKey: UserDefaultKeys.isFingerActivated.rawValue)
                        }
                        UserDefaults.standard.set(user.email, forKey: UserDefaultKeys.currentUserName.rawValue)
                        UserDefaults.standard.set(user.password, forKey: UserDefaultKeys.currentUserPassword.rawValue)
                        print("User Found.")
                        return (user, "Valid user")
                    }
                }
            } else {
                return (nil, validationResult.alertMessage)
            }
            return (nil, "Wrong Email or Password!")
        } catch {
            print("Error while fetching data: ",error.localizedDescription)
            return (nil, error.localizedDescription)
        }
    }
    
    private func validateInputes(userName: String, password: String) -> (result: Bool, alertMessage: String) {
        if !userName.isEmpty && !password.isEmpty {
            if Constant.isEmailValid(email: userName) {
                return (true, "")
            } else {
                return (false, "Invalid Email format")
            }
        } else {
            print("Enter all fields!")
            return (false, "Enter Email & Password!")
        }
    }
    
    func checkForStartScreen() -> Bool {
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.isNotFirstLaunch.rawValue) {
            return false
        } else {
            return true
        }
    }
}
