//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Meet Patel on 04/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var category: String = "Food"
    @State private var selectedCategory: String = "All"
    @State private var isEditing: Bool = false
    @State private var editingExpense: Expense?


    @ObservedObject var viewModel = ExpenseViewModel()
    
    let categories = ["Food", "Travel", "Bills", "Entertainment", "Other"]

    var body: some View {
        NavigationView {
            VStack {
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

                    Button("Add Expense") {
                        if let amountValue = Double(amount) {
                            viewModel.addExpense(amount: amountValue, description: description, category: category)
                            amount = ""
                            description = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: { selectedCategory = "All" }) {
                            Text("All")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(selectedCategory == "All" ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                        }
                        .buttonStyle(BorderlessButtonStyle())

                        ForEach(categories, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                Text(category)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(selectedCategory == category ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                .padding(.horizontal)

                List {
                    ForEach(viewModel.expenses.filter { selectedCategory == "All" || $0.category == selectedCategory }) { expense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.description)
                                    .font(.headline)
                                Text("$\(expense.amount, specifier: "%.2f") - \(expense.category)")
                                    .font(.subheadline)
                                Text(expense.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                editingExpense = expense
                                isEditing = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteExpense)
                }

                .frame(maxHeight: .infinity)

                Spacer()

                Text("Total Expenses: $\(String(format: "%.2f", viewModel.getTotal()))")
                    .font(.headline)
                    .padding()
            }
            .navigationTitle("Expense Tracker")
            
            .sheet(isPresented: $isEditing) {
                if let expense = editingExpense {
                    EditExpenseView(viewModel: viewModel, expense: expense, isEditing: $isEditing)
                }
            }

        }
    }
}
