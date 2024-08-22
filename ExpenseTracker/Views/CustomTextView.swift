//
//  CustomTextView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 05/01/23.
//

import SwiftUI

struct CustomTextView: View {
    var text: String
    var alignment: Alignment = .leading
    
    var body: some View {
        ZStack(alignment: alignment) {
            Rectangle()
                .frame(height: 50)
                .foregroundColor(Color.background)
                .cornerRadius(5)
            Text(text)
                .bold()
                .font(.system(size: 20))
                .padding()
        }
    }
}

struct CustomTextView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextView(text: "Name")
    }
}
