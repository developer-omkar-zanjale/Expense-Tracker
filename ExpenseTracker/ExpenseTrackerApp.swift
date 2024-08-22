//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    
    let persistanceController = PersistenceController.shared
    @ObservedObject var trasactionListVM: TransactionListViewModel = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
//                if UserDefaults.standard.bool(forKey: UserDefaultKeys.isNotFirstLaunch.rawValue) {
                    SignInView()
//                } else {
//                    GetStartedView()
//                }
            }
            .accentColor(.primary)
            .environment(\.managedObjectContext,
                          persistanceController.container.viewContext)
            .environmentObject(trasactionListVM)
            .navigationViewStyle(.stack)
        }
    }
}
