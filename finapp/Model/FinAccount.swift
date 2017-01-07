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
    
    let accountID = UUID()
    var name : String
    let currency : Currency
    var comment = ""
    var totalSum = 0.0
    // NSMutableArray of transactions - ?

}
