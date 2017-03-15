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
    var imageName : String?
    var comment : String
    
    init(name: String, imageName: String?, comment: String?) {
        self.init(categoryID: UUID(), name: name, imageName: imageName, comment: comment)
    }
    
    init(categoryID: UUID, name: String, imageName: String?, comment: String?) {
        self.categoryID = categoryID
        self.name = name
        self.imageName = imageName
        self.comment = comment ?? ""
    }
    
    init(fromCDTransactionCategory cdTransactionCategory: CDTransactionCategory) {
        self.init(categoryID: UUID(uuidString: cdTransactionCategory.categoryID)!,
                  name: cdTransactionCategory.name,
                  imageName: cdTransactionCategory.imageName,
                  comment: cdTransactionCategory.comment)
    }
}


extension FinTransactionCategory : Equatable {
    
    public static func ==(l: FinTransactionCategory, r: FinTransactionCategory) -> Bool {
        
        return  l.categoryID == r.categoryID &&
                l.name == r.name &&
                l.imageName == r.imageName &&
                l.comment == r.comment
    }
    
    public func isEqualContents(to category: FinTransactionCategory) -> Bool {

        return  name == category.name &&
                imageName == category.imageName &&
                comment == category.comment
    }

}
