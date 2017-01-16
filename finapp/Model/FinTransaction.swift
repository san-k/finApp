//
//  File.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation

struct FinTransaction {
    
    typealias MoneySum = Double
    
    let transactionID: UUID
    var transactionType: FinTransactionType
    var sum: MoneySum = 0.0
    var category: FinTransactionCategory?
    let date: Date
    
    init(transactionID: UUID, transactionType: FinTransactionType, sum: MoneySum, category: FinTransactionCategory?, date: Date) {
        self.transactionID = transactionID
        self.transactionType = transactionType
        self.sum = sum
        self.category = category
        self.date = date
    }
    
    init(transactionType: FinTransactionType, sum: MoneySum, category: FinTransactionCategory?, date: Date) {
        self.init(transactionID: UUID(), transactionType: transactionType, sum: sum, category: category, date: date)
    }
    
}
