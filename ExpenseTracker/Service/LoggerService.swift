//
//  LoggerService.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 22/09/24.
//

import Foundation

class LoggerService {
    let isShowLog = false
    
    func printLog(_ log: String) {
        if isShowLog {
            print(log)
        }
    }
    
    func printLog(_ log: Any...) {
        if isShowLog {
            print(log)
        }
    }
}
