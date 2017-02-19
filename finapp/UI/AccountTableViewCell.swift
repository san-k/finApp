//
//  AccountTableViewCell.swift
//  finapp
//
//  Created by Admin on 24.01.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

protocol AccountsCellDelegate : class {
    func accessoryTapped(_ sender: UIButton, inCell cell:UITableViewCell)
}

class AccountTableViewCell: UITableViewCell {

    weak var delegate: AccountsCellDelegate?
    
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountSum: UILabel!

    @IBAction func accessoryTapped(_ sender: UIButton) {
        delegate?.accessoryTapped(sender, inCell: self)
        
    }
    
}
