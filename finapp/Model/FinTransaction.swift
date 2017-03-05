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

extension FinTransaction : Equatable {

    public static func ==(l: FinTransaction, r: FinTransaction) -> Bool{
        return  l.transactionID == r.transactionID &&
                l.transactionType == r.transactionType &&
                l.sum == r.sum &&
                l.category == r.category &&
                l.date == r.date &&
                l.comment == r.comment        
    }
    
    public func isEqualContents(to transaction: FinTransaction) -> Bool {
        
        var isEqualCategories = false
        if let lCategory = category, let rCategory = transaction.category {
            isEqualCategories = (lCategory.categoryID == rCategory.categoryID)
        } else {
            isEqualCategories = (category == transaction.category)
        }
        
        return  transactionType == transaction.transactionType &&
                sum == transaction.sum &&
                isEqualCategories &&
                date == transaction.date &&
                comment == transaction.comment
    }

}
