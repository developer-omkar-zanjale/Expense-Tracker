//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    
    let persistanceController = CoreDataService.shared
    @ObservedObject var trasactionListVM: TransactionListViewModel = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SignInView()
            }
            .accentColor(.primary)
            .environment(\.managedObjectContext,
                          persistanceController.container.viewContext)
            .environmentObject(trasactionListVM)
            .navigationViewStyle(.stack)
        }
    }
}
