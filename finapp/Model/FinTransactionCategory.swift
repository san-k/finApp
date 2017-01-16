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
    
    let categoryID: UUID
    var name : String
    var image : UIImage?
    var comment : String?
    
    init(name: String, image: UIImage?, comment: String?) {
        self.init(categoryID: UUID(), name: name, image: image, comment: comment)
    }
    
    init(categoryID: UUID, name: String, image: UIImage?, comment: String?) {
        self.categoryID = categoryID
        self.name = name
        self.image = image
        self.comment = comment
    }
    
    static func setImage(fromData data: NSData?) -> UIImage? {
        if let data = data, let image = UIImage(data: data as Data) {
            return image
        }
        return nil
    }
    
}
