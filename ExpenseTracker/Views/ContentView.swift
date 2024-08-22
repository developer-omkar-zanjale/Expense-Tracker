//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 28/12/22.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
  
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @State var isLogoutClicked: Bool = false
    @State var isNotificationsClicked: Bool = false
    @State var isProfileClicked: Bool = false
    @State var isAddTransactionClicked: Bool = false
    @State var intervalForChartData: String = ""
    
    let intervalData = TransactionInterval.allIntervals
    
    var body: some View {
        self.updateNavigationBarColor()
        return ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    //MARK: Title
                    Text("Overview")
                        .font(.title)
                        .bold()
                    Spacer()
                    CustomDropDownView(elements: intervalData, selectedElement: $intervalForChartData, showBorder: true, showBacground: false, title: "Intervals", showTitleLabel: false)
                }.padding(.leading)
                //MARK: Chart
                let chartData = transactionListVM.getChartDataFor(interval: intervalForChartData)
                if transactionListVM.isChartDataHaveValues(chartData: chartData) {
                    let totalExpense = chartData.last?.1 ?? 0
                    
                    CardView {
                        VStack(alignment: .leading) {
                            ChartLabel(totalExpense.formatted(.currency(code: "USD")),type: .title, format: "$%.02f")
                            LineChart()
                        }
                        .padding()
                        .background(Color.systemBackground)
                    }
                    .data(chartData)
                    .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.2), Color.icon)))
                    .frame(height: 300)
                } else {
                    let title = intervalForChartData.isEmpty ? "Select Interval" : "No Expenses Found For '\(intervalForChartData)' Interval"
                    NoDataView(title: title, showButton: transactionListVM.transactionList.isEmpty, buttonTitle: "Get Demo Transactions")
                    
                }
                if !transactionListVM.transactionList.isEmpty {
                    //MARK: Transactions
                    RecentTransactionView()
                } else {
                    NoDataView(title: "No Recent Transactions! \nAdd transaction from top bar", showButton: false)
                }
            }
            .padding()
            NavigationLink(destination: ProfileView(), isActive: $isProfileClicked){}
            NavigationLink(destination: AddTransactionView(), isActive: $isAddTransactionClicked){}
        }
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
        .modifier(NavigationBarModifier(isLogoutClicked: $isLogoutClicked, isNotificationsClicked: $isNotificationsClicked, isProfileClicked: $isProfileClicked, isAddTransactionClicked: $isAddTransactionClicked))
    }
    
    func updateNavigationBarColor() {
        if isLogoutClicked {
            UserDefaults.standard.set(false, forKey: UserDefaultKeys.isFingerActivated.rawValue)
            UserDefaults.standard.set(false, forKey: UserDefaultKeys.isNotFirstLaunch.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultKeys.currentUserName.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultKeys.currentUserPassword.rawValue)
            Constant.signUpFromFinger = false
            self.mode.wrappedValue.dismiss()
        }
        UINavigationBar.appearance().barTintColor = UIColor(Color.background)
        UINavigationBar.appearance().backgroundColor = UIColor(Color.background)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TransactionListViewModel())
    }
}
