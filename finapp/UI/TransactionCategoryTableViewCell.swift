//
//  TransactionCategoryTableViewCell.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 2/1/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class TransactionCategoryTableViewCell: UITableViewCell {

    static let staticIdentifier = "TransactionCategoryTableViewCellIdentifier"
  
    @IBOutlet weak var name: UILabel!
    
    @IBAction func showCategoriesPage(_ sender: UIButton) {
    }
    
}
