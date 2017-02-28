//
//  TransactionsTableViewCell.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/27/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    @IBOutlet var comment: UILabel!
    @IBOutlet fileprivate var sumLabel: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var date: UILabel!
    
    public func set(sum: Double, transactionType: FinTransactionType) {
        
        // we can't change parameter
        var localSum = sum
        if transactionType == .TakeMoney {
            // user is not alloved to put minus into field
            localSum *= -1
        }
        
        switch localSum {
        case let s where s > 0.0: sumLabel.textColor = UIColor.green
        case let s where s < 0.0: sumLabel.textColor = UIColor.red
        default: sumLabel.textColor = UIColor.black
        }
        sumLabel.text = String(localSum)
    }
}

