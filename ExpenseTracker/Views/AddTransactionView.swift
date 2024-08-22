//
//  AddTransactionView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 09/01/23.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var trasactionListVM: TransactionListViewModel
    
    @State var merchant = ""
    @State var transactionType = ""
    @State var isTransfer = ""
    @State var isExpense = ""
    @State var isPending = ""
    @State var amount = ""
    @State var category = ""
    @State var isAlertShown = false
    @State var isAddTransactionClicked = false
    
    let addTransactionVM = AddTransactionViewModel()
    
    var body: some View {
        if isAddTransactionClicked {
            ZStack {
                Color.background
                GIFView(fileName: "TransactionDone")
                    .frame(width: 140, height: 140)
                    .cornerRadius(70)
                    .padding()
            }
            .ignoresSafeArea()
        } else {
            ScrollView {
                VStack {
                    Text("Add New Transaction")
                        .font(.title2)
                        .bold()
                        .padding()
                    //MARK: Inputes
                    VStack(spacing: 8) {
                        TextField("Merchant", text: $merchant)
                            .modifier(CustomTextFieldModifier(inputText: $merchant, placeHolder: ""))
                        CustomDropDownView(elements: addTransactionVM.categories, selectedElement: $category, title: "Category")
                        TextField("Amount", text: $amount)
                            .modifier(CustomTextFieldModifier(inputText: $amount, placeHolder: ""))
                            .keyboardType(.numberPad)
                        CustomDropDownView(elements: addTransactionVM.transactionTypes, selectedElement: $transactionType, title: "Transaction Type")
                        CustomDropDownView(elements: addTransactionVM.transactionDecisions, selectedElement: $isTransfer, title: "Transaction Transfer Status")
                        if isTransfer == "False" {
                            CustomDropDownView(elements: addTransactionVM.transactionDecisions, selectedElement: $isPending, title: "Transaction Pending Status")
                        }
                        CustomDropDownView(elements: addTransactionVM.transactionDecisions, selectedElement: $isExpense, title: "Transaction Expense Status")
                    }
                    .padding([.bottom, .top])
                    .padding(.bottom)
                    
                    //MARK: Add Transaction Btn
                    Button {
                        if let newTransaction = addTransactionVM.addTransaction(merchant: merchant, category: category, amount: amount, transactionType: transactionType, isTransfer: isTransfer, isPending: isPending, isExpense: isExpense) {
                            self.isAddTransactionClicked = true
                            if trasactionListVM.saveTransaction(transaction: newTransaction) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.resetInputes()
                                    self.isAddTransactionClicked = false
                                    self.trasactionListVM.getUserTransactions()
                                    self.addTransactionVM.alertTitle = "Transaction Added."
                                    isAlertShown = true
                                }
                            } else {
                                self.addTransactionVM.alertTitle = "Unable to add. Fill appropriate data!"
                                isAlertShown = true
                            }
                        } else {
                            self.isAddTransactionClicked = false
                            self.addTransactionVM.alertTitle = "Unable to add. Fill appropriate data!"
                            isAlertShown = true
                        }
                    } label: {
                        CustomButtonView(title: "Add Transaction")
                    }
                    
                }.padding()
                .alert(addTransactionVM.alertTitle, isPresented: $isAlertShown) {}
            }
            .background(Color.background)
            .onAppear {
                Constant.lastTransactionID =  trasactionListVM.transactionList.map({$0.id}).max() ?? 0
            }
        }
    }
    
    private func resetInputes() {
        merchant = ""
        transactionType = ""
        isTransfer = ""
        isExpense = ""
        isPending = ""
        amount = ""
        category = ""
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
            .environmentObject(TransactionListViewModel())
    }
}
