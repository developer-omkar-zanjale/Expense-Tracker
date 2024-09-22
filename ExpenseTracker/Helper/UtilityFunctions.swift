//
//  UtilityFunctions.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 22/09/24.
//

import Foundation

class UtilityFunctions {
    static func getFontSizeByWidth(pixels : Int)->CGFloat{
                
        switch(pixels){
            
        case 8 :
            return width / 38
            
        case 10 :
            return width / 36
            
        case 12 :
            return width / 30.5
            
        case 14 :
            return width / 29
            
        case 16 :
            return width / 24
            
        case 18 :
            return width / 23
            
        case 20 :
            return width / 20
            
        case 21 :
            return width / 19.5
            
        case 24 :
            return width / 18
            
        case 26 :
            return width / 16
            
        case 28 :
            return width / 14
            
        case 30 :
            return width / 12
            
        case 32 :
            return width / 10
            
        default:
           return width / 25
        }
        
    }
}
