//
//  ProfileView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 05/01/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            let user = transactionListVM.currentUser
            //MARK: Topview
            ZStack {
                RoundedCorners(topLeft: 0, topRight: 0, bottomLeft: 100, bottomRight: 100)
                    .frame(height: 200)
                    .foregroundColor(.background)
                    .ignoresSafeArea()
                VStack{
                    if let profilePhotoData = user?.profileImage {
                        if let image = UIImage(data: profilePhotoData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .cornerRadius(70)
                        } else {
                            GIFView(fileName: ImageConstant.GIFHello)
                                .frame(width: 140, height: 140)
                                .cornerRadius(70)
                        }
                    } else {
                        GIFView(fileName: ImageConstant.GIFHello)
                            .frame(width: 140, height: 140)
                            .cornerRadius(70)
                    }
                    
                }
                .padding(.top, 180)
                
            }
            .padding(.top, -50)
            .ignoresSafeArea()
            
            //MARK: Inputs
            VStack {
                HStack {
                    Image(systemName: ImageConstant.SYS_person)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 22, height: 22)
                        .padding()
                        .border(Color.dimGray, width: 2)
                    CustomTextView(text: user?.name ?? StringConstant.noName)
                }
                
                HStack {
                    Image(systemName: ImageConstant.SYS_envelope)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 22, height: 22)
                        .padding()
                        .border(Color.dimGray, width: 2)
                    CustomTextView(text: user?.email ?? StringConstant.noEmail)
                }
                
                HStack {
                    Image(systemName: ImageConstant.SYS_person_badge_key)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 22, height: 22)
                        .padding()
                        .border(Color.dimGray, width: 2)
                    CustomTextView(text: user?.password ?? StringConstant.noPassword)
                }
            }
            .padding([.leading, .trailing])
            Spacer()
            Button {
                self.mode.wrappedValue.dismiss()
            } label: {
                CustomButtonView(title: StringConstant.home, backgroundColor: .background, titleColor: .primary)
                    .padding()
            }
            
        }
        .background(Color.white)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(TransactionListViewModel())
    }
}
