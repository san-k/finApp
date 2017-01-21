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
    var comment: String
    
    init(transactionID: UUID, transactionType: FinTransactionType, sum: MoneySum, category: FinTransactionCategory?, date: Date, comment:String?) {
        self.transactionID = transactionID
        self.transactionType = transactionType
        self.sum = sum
        self.category = category
        self.date = date
        self.comment = comment ?? ""
    }
    
    init(transactionType: FinTransactionType, sum: MoneySum, category: FinTransactionCategory?, date: Date, comment:String) {
        self.init(transactionID: UUID(), transactionType: transactionType, sum: sum, category: category, date: date, comment:comment)
    }
    
}
