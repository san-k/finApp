//
//  TransactionCategory.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import UIKit

struct FinTransactionCategory {
    
    let categoryID = UUID()
    var name : String
    var image : UIImage?
    var comment : String?
    
}
