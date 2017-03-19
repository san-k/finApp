//
//  TransactionsTableViewCell.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/27/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    @IBOutlet fileprivate var comment: UILabel!
    @IBOutlet fileprivate var sumLabel: UILabel!
    @IBOutlet fileprivate var category: UILabel!
    @IBOutlet fileprivate var categoryImage: UIImageView!
    @IBOutlet fileprivate var date: UILabel!
    
    public func set(from finTransaction: FinTransaction?) {
        if let finTransaction = finTransaction {
            category.text = finTransaction.category?.name
            comment.text = finTransaction.comment
            set(sum: finTransaction.sum, transactionType: finTransaction.transactionType)
        
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "dd.MM.YYYY"
            date.text = formatter.string(from: finTransaction.date)
        } else {
            category.text = ""
            comment.text = ""
            sumLabel.text = ""
            date.text = ""
        }
    }
    
    fileprivate func set(sum: Double, transactionType: FinTransactionType) {
        
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

