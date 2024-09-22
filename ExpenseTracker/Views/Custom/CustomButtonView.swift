//
//  CustomButtonView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 03/01/23.
//

import SwiftUI

struct CustomButtonView: View {
    var title: String
    var backgroundColor: Color = .green
    var titleColor: Color = .white
    var width: CGFloat = .infinity
    var height: CGFloat = 50
    var textAlignment: Alignment = .center
    
    var body: some View {
        ZStack(alignment: textAlignment) {
            RoundedRectangle(cornerRadius: 5)
                .frame(height: height)
                .foregroundColor(backgroundColor)
            Text(title)
                .font(.custom("Open Sans", size: 20))
                .foregroundColor(titleColor)
                .padding()
        }
    }
}

struct CustomButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonView(title: "")
    }
}
