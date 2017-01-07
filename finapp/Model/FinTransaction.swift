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
    
    let transactionID = UUID()
    var transactionType : FinTransactionType
    var sum = 0.0
    var category : FinTransactionCategory?
    let date : Date
    
    
}
