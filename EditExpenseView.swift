//
//  EditExpenseView.swift
//  ExpenseTracker
//
//  Created by Meet Patel on 07/02/25.
//

import SwiftUI

struct EditExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    var expense: Expense

    @State private var amount: String
    @State private var description: String
    @State private var category: String
    @Binding var isEditing: Bool

    let categories = ["Food", "Travel", "Bills", "Entertainment", "Other"]

    init(viewModel: ExpenseViewModel, expense: Expense, isEditing: Binding<Bool>) {
        self.viewModel = viewModel
        self.expense = expense
        self._amount = State(initialValue: String(expense.amount))
        self._description = State(initialValue: expense.description)
        self._category = State(initialValue: expense.category)
        self._isEditing = isEditing
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                TextField("Description", text: $description)
                
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                HStack {
                    Button("Cancel") {
                        isEditing = false
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)

                    Spacer()

                    Button("Save Changes") {
                        if let newAmount = Double(amount) {
                            viewModel.updateExpense(id: expense.id, amount: newAmount, description: description, category: category)
                            isEditing = false  
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Edit Expense")
        }
    }
}
