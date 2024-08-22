//
//  GetStartedView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 30/12/22.
//

import SwiftUI

struct GetStartedView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack {
                Text("Welcome")
                    .font(.system(size: 50))
                    .bold()
                    .shadow(color: .yellow, radius: 1)
                    .foregroundColor(.green)
                
                GIFView(fileName: "money")
                    .frame(height: 400)
                    .background(Color.background)
                    .padding()
                
                Button {
                    UserDefaults.standard.set(true, forKey: UserDefaultKeys.isNotFirstLaunch.rawValue)
                    self.mode.wrappedValue.dismiss()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(.green, lineWidth: 4)
                            .frame(height: 60)
                            .padding()
                        Text("Get Started")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
    }
}
