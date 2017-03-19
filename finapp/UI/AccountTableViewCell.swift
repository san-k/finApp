//
//  AccountTableViewCell.swift
//  finapp
//
//  Created by Admin on 24.01.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var accountImage: UIImageView!
    @IBOutlet fileprivate weak var accountName: UILabel!
    @IBOutlet fileprivate weak var accountSumLabel: UILabel!

    public func set(from finAccount: FinAccount?) {
        guard let account = finAccount else {
            accountName.text = ""
            accountImage = nil
            accountSumLabel.text = ""
            return
        }
        
        accountName.text = account.name
        switch account.totalSum  {
        case let s where s > 0.0 : accountSumLabel.textColor = UIColor.green
        case let s where s < 0.0 : accountSumLabel.textColor = UIColor.red
        default: accountSumLabel.textColor = UIColor.black
        }
        accountSumLabel.text = String(account.totalSum)
    }
}
