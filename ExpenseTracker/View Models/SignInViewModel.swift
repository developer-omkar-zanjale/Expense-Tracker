//
//  SignInViewModel.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 06/01/23.
//

import Foundation
import LocalAuthentication

class SignInViewModel: ObservableObject {
    
    private let coreDataService = CoreDataService.shared
    @Published var isShowStartView = false
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var isSignInClicked: Bool = false
    @Published var isAlertShown = false
    @Published var alertTitle = AlertConstant.somethingWentWrong
    @Published var isNavigateToHome: Bool = false
    
    let logService = LoggerService()
    
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
                    self.logService.printLog("SignInViewModel: Local authentication success.")
                } else {
                    self.logService.printLog("SignInViewModel: Local authentication failed!")
                }
                complition(result)
                return
            }
        } else {
            complition(false)
            self.logService.printLog("SignInViewModel: No authentication sources.")
        }
    }
    //
    //MARK: Database Search
    //
    func searchUserInDatabase(userName: String, password: String) -> (user: UserData?, alertMessage: String) {
        let validationResult = validateInputes(userName: userName, password: password)
        if validationResult.result {
            if let matchedUser = coreDataService.readUsers(email: userName, fetchLimit: 1).first {
                guard let matchedUserPass = matchedUser.password else {
                    logService.printLog("SignInViewModel: Unable to get matched user passowrd!")
                    return(nil, AlertConstant.unableToSignInAtThisMomentPleaseTryAgain)
                }
                if matchedUserPass == password {
                    if AppConstant.signUpFromFinger {
                        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isFingerActivated.rawValue)
                    }
                    UserDefaults.standard.set(userName, forKey: UserDefaultKeys.currentUserName.rawValue)
                    UserDefaults.standard.set(matchedUserPass, forKey: UserDefaultKeys.currentUserPassword.rawValue)
                    self.logService.printLog("SignInViewModel: User Found.")
                    return (matchedUser, AlertConstant.validUser)
                }
            }
        } else {
            return (nil, validationResult.alertMessage)
        }
        return (nil, AlertConstant.wrongEmailOrPassword)
    }
    
    private func validateInputes(userName: String, password: String) -> (result: Bool, alertMessage: String) {
        if !userName.isEmpty && !password.isEmpty {
            if AppConstant.isEmailValid(email: userName) {
                return (true, "")
            } else {
                return (false, AlertConstant.invalidEmailFormat)
            }
        } else {
            self.logService.printLog("Enter all fields!")
            return (false, AlertConstant.enterEmailNPassword)
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
