//
//  AlertView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 22/09/24.
//

import SwiftUI

struct AlertView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let utils = UtilityFunctions()
    var title: String = "Warning"
    var message: String
    
    var firstBtnTitle: String
    var secondBtnTitle: String?
    
    var isShowFirstButtonStroke = false
    var isShowSecondButtonStroke = false
    
    var didTapFirstBtn: (()-> Void)
    var didTapSecondBtn: (()-> Void)?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
            VStack {
                Text("\(title)")
                    .font(.custom(Fonts.figtreeSemiBold, size: UtilityFunctions.getFontSizeByWidth(pixels: 20)))
                    .padding(.bottom, height * 0.01)
                Text("\(message)")
                    .font(.custom(Fonts.figtreeMedium, size: UtilityFunctions.getFontSizeByWidth(pixels: 16)))
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing])
                HStack(spacing: 16) {
                    Button(action: {
                        
                        didTapFirstBtn()
                    }, label: {
                        AlertButtonLabel(title: firstBtnTitle, isShowStroke: isShowFirstButtonStroke)
                    })
                    if secondBtnTitle != nil {
                        Button(action: {
                            didTapSecondBtn?()
                        }, label: {
                            AlertButtonLabel(title: secondBtnTitle ?? "-", isShowStroke: isShowSecondButtonStroke)
                        })
                    }
                    
                }
                .padding(.top, height * 0.03)
            }
            .padding(width * 0.03)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: width * 0.8)
                    .foregroundStyle(Color.background)
                    .roundedCorner(10, corners: .allCorners)
                    .shadow(color: Color.primary, radius: 2)
            }
            .frame(width: width * 0.8)
        }
        .frame(width: width)
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func AlertButtonLabel(title: String, isShowStroke: Bool = false) -> some View {
        ZStack{
            if isShowStroke {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primary, lineWidth: 1)
                    .frame(width: width * 0.3, height: height / 18)
                    .foregroundStyle(Color.white)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: width * 0.3, height: height / 18)
                    .foregroundStyle(Color.primary)
            }
            
            Text(title)
                .foregroundStyle(getButtonTitleColor(isShowStroke: isShowStroke))
                .font(.custom(Fonts.figtreeRegular, size: UtilityFunctions.getFontSizeByWidth(pixels: 18)))
        }
    }
    
    func getButtonTitleColor(isShowStroke: Bool) -> Color {
        var color: Color
        let isDarkMode = colorScheme == .dark
        
        if isShowStroke {
            color = isDarkMode ? Color.white : Color.black
        } else {
            color = isDarkMode ? Color.black : Color.white
        }
//        isShowStroke ? colors  Color.white : Color.black
        return color
    }
}

#Preview {
    AlertView(title: "Title", message: "Message", firstBtnTitle: "Cancel", secondBtnTitle: "Ok", isShowSecondButtonStroke: true, didTapFirstBtn: {})
        .preferredColorScheme(.dark)
}
