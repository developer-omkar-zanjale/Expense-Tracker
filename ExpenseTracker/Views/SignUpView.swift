//
//  SignUpView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 03/01/23.
//

import SwiftUI

struct SignUpView: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isOpenImagePicker = false
    @State var selectedImage: UIImage = UIImage()
    @State var isAlertShown = false
    @State var alertTitle = "Something went wrong!"
    @State private var isEmailVerified = false
    @State private var isPasswordVerified = false
    @State var isShowToastMesssage: Bool = false
    
    let signUpVM = SignUpViewModel()
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Sign Up")
                        .font(.system(size: 24))
                        .bold()
                    Spacer()
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(.dimGray)
                        .padding()
                    Image("india")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                
                //MARK: Input TextFields
                VStack(spacing: 8) {
                    TextField("", text: $name)
                        .modifier(CustomTextFieldModifier(inputText: $name, placeHolder: "Name"))
                    TextField("", text: $email)
                        .modifier(CustomTextFieldModifier(inputText: $email, placeHolder: "Email"))
                        .border(Color.red, width: isEmailVerified ? 0 : email.isEmpty ? 0 : 2)
                        .cornerRadius(5)
                        .onChange(of: email) { newValue in
                            if newValue.count > 6 {
                                let availabilityResult = signUpVM.checkUserAvailability(email: newValue)
                                self.isEmailVerified = availabilityResult.result
                                alertTitle = availabilityResult.alertMessage
                                isShowToastMesssage = !availabilityResult.result
                            }
                        }
                    
                    TextField("", text: $password)
                        .modifier(CustomTextFieldModifier(inputText: $password, placeHolder: "Password"))
                        .border(Color.red, width: Constant.isPasswordValid(password: password) ? 0 : password.isEmpty ? 0 : 2)
                        .cornerRadius(5)
                        .onChange(of: password) { newValue in
                            let isPasswordValid = Constant.isPasswordValid(password: newValue)
                            isPasswordVerified = isPasswordValid
                            isShowToastMesssage = !isPasswordValid
                            if isPasswordValid {
                                alertTitle = ""
                            } else {
                                alertTitle = "Password must be 8-16 Characters & must contain Uppercase, Number, Special Character & no White Spaces"
                            }
                        }
                    SecureField("", text: $confirmPassword)
                        .modifier(CustomTextFieldModifier(inputText: $confirmPassword, placeHolder: "Confirm Password"))
                        .border(Color.red, width: confirmPassword == password ? 0 : 2)
                        .cornerRadius(5)
                        .onChange(of: confirmPassword) { newValue in
                            if newValue.count >= 4 {
                                if newValue != password {
                                    alertTitle = "Both password must be same!"
                                    isShowToastMesssage = true
                                } else {
                                    alertTitle = ""
                                    isShowToastMesssage = false
                                }
                            }
                        }
                    
                    //MARK: ImagerPicker Btn
                    HStack {
                        Button {
                            isOpenImagePicker = true
                        } label: {
                            CustomButtonView(title: "Choose profile", backgroundColor: .gray.opacity(0.5), textAlignment: .leading)
                        }
                        Image(uiImage: self.selectedImage)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .scaledToFill()
                    }
                }
                .padding(.bottom)
                
                //MARK: Toast Label
                if isShowToastMesssage {
                    Text(alertTitle)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .bold()
                }
                //MARK: Sign Up Btn
                Button {
                    let userResult = signUpVM.createUser(name: name, email: email, password: password, confirmPassword: confirmPassword, selectedImage: selectedImage)
                    if userResult.result {
                        self.mode.wrappedValue.dismiss()
                    } else {
                        alertTitle = userResult.alertMessage
                        isAlertShown = true
                    }
                } label: {
                    CustomButtonView(title: "Sign Up",backgroundColor: isEmailVerified && isPasswordVerified ? Color.green : Color.dimGray)
                }.disabled(!isEmailVerified || !isPasswordVerified)
                
                
                    .alert(Text(alertTitle), isPresented: $isAlertShown) {
                        Button("OK", role: .cancel) { }
                    }
                
                
            }
            .padding()
            
            .sheet(isPresented: $isOpenImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
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
