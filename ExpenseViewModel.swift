//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Meet Patel on 04/02/25.
//

import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = [] {
        didSet {
            saveExpenses()
        }
    }

    init() {
        loadExpenses()
    }
    
    func addExpense(amount: Double, description: String, category: String) {
        let newExpense = Expense(amount: amount, description: description, category: category, date: Date())
        expenses.append(newExpense)
    }

    func getTotal() -> Double {
        return expenses.reduce(0) { $0 + $1.amount }
    }

    func updateExpense(id: UUID, amount: Double, description: String, category: String) {
        if let index = expenses.firstIndex(where: { $0.id == id }) {
            expenses[index].amount = amount
            expenses[index].description = description
            expenses[index].category = category
        }
    }

    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }

    private func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: "expenses")
        }
    }

    private func loadExpenses() {
        if let savedExpenses = UserDefaults.standard.data(forKey: "expenses"),
           let decodedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpenses) {
            expenses = decodedExpenses
        }
    }
}
