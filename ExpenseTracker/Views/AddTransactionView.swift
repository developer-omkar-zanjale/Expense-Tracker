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
    
    @StateObject var addTransactionVM = AddTransactionViewModel()
    
    var body: some View {
        if addTransactionVM.isAddTransactionClicked {
            ZStack {
                Color.background
                GIFView(fileName: ImageConstant.GIFTransactionDone)
                    .frame(width: 140, height: 140)
                    .cornerRadius(70)
                    .padding()
            }
            .ignoresSafeArea()
        } else {
            ScrollView {
                VStack {
                    Text(StringConstant.addNewTransaction)
                        .font(.title2)
                        .bold()
                        .padding()
                    //MARK: Inputes
                    VStack(spacing: 8) {
                        TextField(StringConstant.merchantName, text: $addTransactionVM.merchant)
                            .modifier(CustomTextFieldModifier(inputText: $addTransactionVM.merchant, placeHolder: ""))
                        CustomDropDownView(elements: addTransactionVM.categories, selectedElement: $addTransactionVM.category, title: StringConstant.category)
                        TextField(StringConstant.amount, text: $addTransactionVM.amount)
                            .modifier(CustomTextFieldModifier(inputText: $addTransactionVM.amount, placeHolder: ""))
                            .keyboardType(.numberPad)
                        CustomDropDownView(elements: addTransactionVM.transactionTypes, selectedElement: $addTransactionVM.transactionType, title: StringConstant.transactionType)
                        CustomDropDownView(elements: addTransactionVM.transactionDecisions, selectedElement: $addTransactionVM.isTransfer, title: StringConstant.transactionTransferStatus)
                        if addTransactionVM.isTransfer == AppConstant.FalseStr {
                            CustomDropDownView(elements: addTransactionVM.transactionDecisions, selectedElement: $addTransactionVM.isPending, title: StringConstant.transactionPendingStatus)
                        }
                        CustomDropDownView(elements: addTransactionVM.transactionDecisions, selectedElement: $addTransactionVM.isExpense, title: StringConstant.isExpense)
                    }
                    .padding([.bottom, .top])
                    .padding(.bottom)
                    
                    //MARK: Add Transaction Btn
                    Button {
                        if let newTransaction = addTransactionVM.addTransaction() {
                            addTransactionVM.isAddTransactionClicked = true
                            if trasactionListVM.saveTransaction(transaction: newTransaction) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    addTransactionVM.resetInputes()
                                    addTransactionVM.isAddTransactionClicked = false
                                    self.trasactionListVM.getUserTransactions()
                                    self.addTransactionVM.alertTitle = AlertConstant.transactionAdded
                                    addTransactionVM.isAlertShown = true
                                }
                            } else {
                                self.addTransactionVM.alertTitle = AlertConstant.unableToAddFillAppropriateData
                                addTransactionVM.isAlertShown = true
                            }
                        } else {
                            addTransactionVM.isAddTransactionClicked = false
                            self.addTransactionVM.alertTitle = AlertConstant.unableToAddFillAppropriateData
                            addTransactionVM.isAlertShown = true
                        }
                    } label: {
                        CustomButtonView(title: StringConstant.addTransaction)
                    }
                    
                }.padding()
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(addTransactionVM.isAlertShown)
            .overlay {
                //MARK: Alert
                if addTransactionVM.isAlertShown {
                    AlertView(message: addTransactionVM.alertTitle, firstBtnTitle: AlertConstant.OK) {
                        addTransactionVM.isAlertShown = false
                    }
                    .ignoresSafeArea()
                }
            }
            .onAppear {
                AppConstant.lastTransactionID =  trasactionListVM.transactionList.map({$0.id}).max() ?? 0
            }
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
            .environmentObject(TransactionListViewModel())
    }
}
