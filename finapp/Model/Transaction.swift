//
//  File.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation

struct Transaction {
    
    typealias MoneySum = Double
    
    let transactionID = UUID()
    var transactionType : TransactionType
    var sum = 0.0
    var category : TransactionCategory?
    let date : Date
    
    
}
