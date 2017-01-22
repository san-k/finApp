//
//  FinAccount.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation



struct FinAccount {
    
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
        self.init(accountID: UUID(uuidString: cdFinAccount.ccountID)!,
                  name: cdFinAccount.name,
                  currency: Currency(rawValue:cdFinAccount.currency)!,
                  comment: cdFinAccount.comment,
                  startSum: cdFinAccount.sum)
    }
    
}
