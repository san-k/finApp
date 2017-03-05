//
//  FinAccount.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation



public struct FinAccount {
    
    typealias MoneySum = Double
    
    let accountID: UUID
    var name: String
    let currency: Currency
    var comment: String
    var totalSum: MoneySum
    // NSMutableArray of transactions - ?

    init(accountID: UUID, name: String, currency: Currency, comment: String, startSum: MoneySum) {
        self.accountID = accountID
        self.name = name
        self.currency = currency
        self.comment = comment
        self.totalSum = startSum
    }
    
    init(name: String, currency: Currency, comment: String, startSum: MoneySum) {
        self.init(accountID: UUID(), name: name, currency: currency, comment: comment, startSum: startSum)
    }
    
    init(fromCDFinAccount cdFinAccount: CDFinAccount) {
        self.init(accountID: UUID(uuidString: cdFinAccount.accountID)!,
                  name: cdFinAccount.name,
                  currency: Currency(rawValue:cdFinAccount.currency)!,
                  comment: cdFinAccount.comment,
                  startSum: cdFinAccount.sum)
    }
    
}


extension FinAccount : Equatable {
    public static func ==(left: FinAccount, right: FinAccount) -> Bool {
        return  left.accountID == right.accountID &&
                left.name == right.name &&
                left.currency == right.currency &&
                left.totalSum == right.totalSum &&
                left.comment == right.comment
    }
    
    public func isEqualContents(to finAccount: FinAccount) -> Bool {
        return  name == finAccount.name &&
                currency == finAccount.currency &&
                totalSum == finAccount.totalSum &&
                comment == finAccount.comment
    }
}

