//
//  SignUpView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 03/01/23.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var signUpVM = SignUpViewModel()
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(StringConstant.signUp)
                            .font(.system(size: 24))
                            .bold()
                        Spacer()
                        Rectangle()
                            .frame(width: 2, height: 50)
                            .foregroundColor(.dimGray)
                            .padding()
                        Image(ImageConstant.india)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    
                    //MARK: Input TextFields
                    VStack(spacing: 8) {
                        TextField("", text: $signUpVM.name)
                            .modifier(CustomTextFieldModifier(inputText: $signUpVM.name, placeHolder: StringConstant.name))
                        TextField("", text: $signUpVM.email)
                            .modifier(CustomTextFieldModifier(inputText: $signUpVM.email, placeHolder: StringConstant.email))
                            .border(Color.red, width: signUpVM.isEmailVerified ? 0 : signUpVM.email.isEmpty ? 0 : 2)
                            .cornerRadius(5)
                            .onChange(of: signUpVM.email) { newValue in
                                if newValue.count > 6 {
                                    let availabilityResult = signUpVM.checkUserAvailability(email: newValue)
                                    signUpVM.isEmailVerified = availabilityResult.result
                                    signUpVM.alertTitle = availabilityResult.alertMessage
                                    signUpVM.isShowToastMesssage = !availabilityResult.result
                                }
                            }
                        
                        TextField("", text: $signUpVM.password)
                            .modifier(CustomTextFieldModifier(inputText: $signUpVM.password, placeHolder: StringConstant.password))
                            .border(Color.red, width: AppConstant.isPasswordValid(password: signUpVM.password) ? 0 : signUpVM.password.isEmpty ? 0 : 2)
                            .cornerRadius(5)
                            .onChange(of: signUpVM.password) { newValue in
                                let isPasswordValid = AppConstant.isPasswordValid(password: newValue)
                                signUpVM.isPasswordVerified = isPasswordValid
                                signUpVM.isShowToastMesssage = !isPasswordValid
                                if isPasswordValid {
                                    signUpVM.alertTitle = ""
                                } else {
                                    signUpVM.alertTitle = AlertConstant.passwordValidation
                                }
                            }
                        SecureField("", text: $signUpVM.confirmPassword)
                            .modifier(CustomTextFieldModifier(inputText: $signUpVM.confirmPassword, placeHolder: StringConstant.confirmPassword))
                            .border(Color.red, width: signUpVM.confirmPassword == signUpVM.password ? 0 : 2)
                            .cornerRadius(5)
                            .onChange(of: signUpVM.confirmPassword) { newValue in
                                if newValue.count >= 4 {
                                    if newValue != signUpVM.password {
                                        signUpVM.alertTitle = AlertConstant.bothPasswordMustBeSame
                                        signUpVM.isShowToastMesssage = true
                                    } else {
                                        signUpVM.alertTitle = ""
                                        signUpVM.isShowToastMesssage = false
                                    }
                                }
                            }
                        
                        //MARK: ImagerPicker Btn
                        HStack {
                            Button {
                                signUpVM.isOpenImagePicker = true
                            } label: {
                                CustomButtonView(title: StringConstant.chooseProfile, backgroundColor: .gray.opacity(0.5), textAlignment: .leading)
                            }
                            Image(uiImage: signUpVM.selectedImage)
                                .resizable()
                                .frame(width: 45, height: 45)
                                .scaledToFill()
                        }
                    }
                    .padding(.bottom)
                    
                    //MARK: Toast Label
                    if signUpVM.isShowToastMesssage {
                        Text(signUpVM.alertTitle)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .bold()
                    }
                    //MARK: Sign Up Btn
                    Button {
                        let userResult = signUpVM.createUser(name: signUpVM.name, email: signUpVM.email, password: signUpVM.password, confirmPassword: signUpVM.confirmPassword, selectedImage: signUpVM.selectedImage)
                        if userResult.result {
                            self.mode.wrappedValue.dismiss()
                        } else {
                            signUpVM.alertTitle = userResult.alertMessage
                            signUpVM.isAlertShown = true
                        }
                    } label: {
                        CustomButtonView(title: StringConstant.signUp.uppercased(), backgroundColor: signUpVM.isEmailVerified && signUpVM.isPasswordVerified ? Color.green : Color.dimGray)
                    }.disabled(!signUpVM.isEmailVerified || !signUpVM.isPasswordVerified)
                }
                .padding()
                
                .sheet(isPresented: $signUpVM.isOpenImagePicker) {
                    ImagePicker(selectedImage: $signUpVM.selectedImage, sourceType: .photoLibrary)
                }
            }
            //MARK: Alert
            if signUpVM.isAlertShown {
                AlertView(message: signUpVM.alertTitle, firstBtnTitle: AlertConstant.OK) {
                    signUpVM.isAlertShown = false
                }
            }
        }
        .background(Color.background)
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
