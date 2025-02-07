//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Meet Patel on 04/02/25.
//

import Foundation

struct Expense: Identifiable, Codable {
    var id = UUID()
    var amount: Double
    var description: String
    var category: String
    var date: Date
}

