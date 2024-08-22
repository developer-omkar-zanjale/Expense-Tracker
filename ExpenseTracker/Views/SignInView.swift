//
//  SignInView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 30/12/22.
//

import SwiftUI

struct SignInView: View {
    
    @State var isShowStartView = false
    @State var userName: String = ""
    @State var password: String = ""
    @State var isSignInClicked: Bool = false
    @State var isAlertShown = false
    @State var alertTitle = "Something went wrong!"
    @State var isNavigateToHome: Bool = false
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    let signInVM = SignInViewModel()
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Sign In")
                        .font(.title)
                        .bold()
                    Spacer()
                    Rectangle()
                        .foregroundColor(.dimGray)
                        .frame(width: 2, height: 50)
                        .padding()
                    Image("india")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                
                //MARK: Input Textfields
                VStack(spacing: 1) {
                    TextField("", text: $userName)
                        .modifier(CustomTextFieldModifier(inputText: $userName, placeHolder: "Username"))
                    SecureField("", text: $password)
                        .modifier(CustomTextFieldModifier(inputText: $password, placeHolder: "Password"))
                }
                
                HStack {
                    //MARK: SIGN IN Button
                    Button {
                        let searchResult = signInVM.searchUserInDatabase(userName: userName, password: password)
                        if searchResult.user != nil {
                            transactionListVM.currentUser = searchResult.user
                            isNavigateToHome = true
                        } else {
                            alertTitle = searchResult.alertMessage
                            isAlertShown = true
                            Constant.signUpFromFinger = false
                            UserDefaults.standard.set(false, forKey: UserDefaultKeys.isFingerActivated.rawValue)
                        }
                    } label: {
                        CustomButtonView(title: "SIGN IN")
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
                                        isNavigateToHome = true
                                    } else {
                                        self.alertTitle = "Please try again!"
                                        self.isAlertShown = true
                                    }
                                } else {
                                    self.alertTitle = "Something Went Wrong!"
                                    self.isAlertShown = true
                                }
                            }
                        } else {
                            alertTitle = "Please Sign In to activate Fingerprint."
                            isAlertShown = true
                            Constant.signUpFromFinger = true
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(.green, lineWidth: 3)
                                .frame(width: 50, height: 50)
                            
                            Image("fingerprint")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                    }
                    
                    //MARK: Alert
                    .alert(Text(alertTitle), isPresented: $isAlertShown) {
                        Button("OK", role: .cancel) { }
                    }
                    
                }
                
                //MARK: SignUp button
                VStack(alignment: .leading, spacing: 2) {
                    Text("New Here?")
                        .padding(.top)
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Register")
                            .foregroundColor(.green)
                        
                    }
                }
                .font(.custom("Open Sans", size: 16))
            }
            .padding()
            .navigationBarHidden(true)
            NavigationLink(destination:
                            ContentView(),
                           isActive: $isNavigateToHome){}
            .fullScreenCover(isPresented: $isShowStartView) {
                self.signInVM.isShowStartView = false
            } content: {
                GetStartedView()
            }
        }
        .onAppear {
            password = ""
            userName = ""
            if signInVM.isShowStartView {
                self.isShowStartView = true
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignInView()
    }
    
}


