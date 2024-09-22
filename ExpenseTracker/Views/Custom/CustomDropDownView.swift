//
//  CustomDropDownView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 10/01/23.
//

import SwiftUI

struct CustomDropDownView: View {
    var elements: [String]
    @Binding var selectedElement: String
    var showBorder = false
    var showBacground = true
    var title: String
    var showTitleLabel = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            if showBacground {
                Rectangle()
                    .frame(height: 50)
                    .cornerRadius(5)
                    .foregroundColor(.gray.opacity(0.5))
            }
            HStack(spacing: 10) {
                if showTitleLabel {
                    Text(title)
                }
                Picker(title.isEmpty ? StringConstant.select : title, selection: $selectedElement) {
                    selectedElement.isEmpty ? Text(StringConstant.select) : Text(title)
                    ForEach(elements, id: \.self) {
                        Text($0)
                    }
                } .pickerStyle(MenuPickerStyle())
                    .tint(.primary)
                
            }.padding([.leading, .trailing])
                .border(Color.primary, width: showBorder ? 2 : 0)
        }
        
    }
}

struct CustomDropDownView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDropDownView(elements: ["Test1", "Test2"], selectedElement: .constant(""), title: "")
    }
}
