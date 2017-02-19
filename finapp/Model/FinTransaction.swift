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
    
    init(fromCDTransaction cdTransaction: CDTransaction) {
        self.init(transactionID: UUID(uuidString: cdTransaction.transactionID)!,
                  transactionType: FinTransactionType(rawValue: Int(cdTransaction.transactionType))!,
                  sum: cdTransaction.sum,
                  category: cdTransaction.category == nil ? nil : FinTransactionCategory(fromCDTransactionCategory: cdTransaction.category!),
                  date: cdTransaction.date as Date,
                  comment: cdTransaction.comment)
    }
    
}
