//
//  SignInView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 30/12/22.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    @StateObject var signInVM = SignInViewModel()
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(StringConstant.signIn)
                        .font(.title)
                        .bold()
                    Spacer()
                    Rectangle()
                        .foregroundColor(.dimGray)
                        .frame(width: 2, height: 50)
                        .padding()
                    Image(ImageConstant.india)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                
                //MARK: Input Textfields
                VStack(spacing: 1) {
                    TextField("", text: $signInVM.userName)
                        .modifier(CustomTextFieldModifier(inputText: $signInVM.userName, placeHolder: StringConstant.username))
                    SecureField("", text: $signInVM.password)
                        .modifier(CustomTextFieldModifier(inputText: $signInVM.password, placeHolder: StringConstant.password))
                }
                
                HStack {
                    //MARK: SIGN IN Button
                    Button {
                        let encodedPass = SecureService.encode(str: signInVM.password)
                        let searchResult = signInVM.searchUserInDatabase(userName: signInVM.userName, password: encodedPass ?? "")
                        if searchResult.user != nil {
                            transactionListVM.currentUser = searchResult.user
                            signInVM.isNavigateToHome = true
                        } else {
                            signInVM.alertTitle = searchResult.alertMessage
                            signInVM.isAlertShown = true
                            AppConstant.signUpFromFinger = false
                            UserDefaults.standard.set(false, forKey: UserDefaultKeys.isFingerActivated.rawValue)
                        }
                    } label: {
                        CustomButtonView(title: StringConstant.signIn.uppercased())
                    }
                    
                    //MARK: Fingerprint Button
                    Button {
                        if UserDefaults.standard.bool(forKey: UserDefaultKeys.isFingerActivated.rawValue) {
                            self.signInVM.fingerPrintOrFaceAuth { authResult in
                                if authResult {
                                    let userEmail = UserDefaults.standard.string(forKey: UserDefaultKeys.currentUserName.rawValue) ?? ""
                                    let userPassword = UserDefaults.standard.string(forKey: UserDefaultKeys.currentUserPassword.rawValue) ?? ""
                                                                        
                                    let searchResult = signInVM.searchUserInDatabase(userName: userEmail, password: userPassword)
                                    if searchResult.user != nil {
                                        transactionListVM.currentUser = searchResult.user
                                        signInVM.isNavigateToHome = true
                                    } else {
                                        signInVM.alertTitle = AlertConstant.pleaseTryAgain
                                        signInVM.isAlertShown = true
                                    }
                                } else {
                                    signInVM.alertTitle = AlertConstant.somethingWentWrong
                                    signInVM.isAlertShown = true
                                }
                            }
                        } else {
                            signInVM.alertTitle = AlertConstant.pleaseSignInToActivateFingerprint
                            signInVM.isAlertShown = true
                            AppConstant.signUpFromFinger = true
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(.green, lineWidth: 3)
                                .frame(width: 50, height: 50)
                            
                            Image(ImageConstant.fingerprint)
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                    }
                }
                
                //MARK: SignUp button
                VStack(alignment: .leading, spacing: 2) {
                    Text(StringConstant.newHere)
                        .padding(.top)
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text(StringConstant.register)
                            .foregroundColor(.green)
                        
                    }
                }
                .font(.custom("Open Sans", size: 16))
            }
            .padding()
            .navigationBarHidden(true)
            NavigationLink(destination:
                            HomeView(),
                           isActive: $signInVM.isNavigateToHome){}
                .fullScreenCover(isPresented: $signInVM.isShowStartView) {
                self.signInVM.isShowStartView = false
            } content: {
                GetStartedView()
            }
            //MARK: Alert
            if signInVM.isAlertShown {
                AlertView(message: signInVM.alertTitle, firstBtnTitle: AlertConstant.OK) {
                    signInVM.isAlertShown = false
                }
            }
        }
        .onAppear {
            signInVM.password = ""
            signInVM.userName = ""
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignInView()
            .preferredColorScheme(.dark)
    }
    
}


