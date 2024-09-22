//
//  CustomModifiers.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 03/01/23.
//

import SwiftUI

//MARK: TextField
struct CustomTextFieldModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var inputText: String
    var placeHolder: String
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.5))
            .cornerRadius(5)
            .placeholder(when: inputText.isEmpty) {
                Text(placeHolder)
                    .font(Font(CTFont(.menuItem, size: 22)))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding()
            }
    }
}

#Preview(body: {
    ZStack {
        Color.background.ignoresSafeArea()
        TextField("", text: .constant(""))
            .modifier(CustomTextFieldModifier(inputText: .constant(""), placeHolder: StringConstant.username))
            .padding(.horizontal)
    }
})

//MARK: NavigationBarModifier

struct NavigationBarModifier: ViewModifier {
    
    @Binding var isLogoutClicked: Bool
    @Binding var isNotificationsClicked: Bool
    @Binding var isProfileClicked: Bool
    @Binding var isAddTransactionClicked: Bool
    
    func body(content: Content ) -> some View {
        content
            .toolbar {
                HStack {
                    Button {
                        isAddTransactionClicked = true
                    } label: {
                        Image(systemName: "arrow.up")
                            .tint(.primary)
                    }
                    
                    Menu {
                        Text("Settings")
                        Button {
                            isProfileClicked = true
                        } label: {
                            Text("Profile")
                            Image(systemName: "person.circle.fill")
                        }
                        
                        Button {
                            isNotificationsClicked = true
                        } label: {
                            Text("Notifications")
                            Image(systemName: "envelope.badge")
                        }
                        
                        Button {
                            isLogoutClicked = true
                        } label: {
                            Text("Logout")
                            Image(systemName: "arrowshape.turn.up.right.circle.fill")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle").rotationEffect(.degrees(90))
                    }
                }
            }
    }
}
