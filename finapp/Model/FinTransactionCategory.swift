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
    var comment : String
    
    init(name: String, image: UIImage?, comment: String?) {
        self.init(categoryID: UUID(), name: name, image: image, comment: comment)
    }
    
    init(categoryID: UUID, name: String, image: UIImage?, comment: String?) {
        self.categoryID = categoryID
        self.name = name
        self.image = image
        self.comment = comment ?? ""
    }
    
    init(fromCDTransactionCategory cdTransactionCategory: CDTransactionCategory) {
        self.init(categoryID: UUID(uuidString: cdTransactionCategory.categoryID)!,
                  name: cdTransactionCategory.name,
                  image: FinTransactionCategory.makeImage(fromData: cdTransactionCategory.image),
                  comment: cdTransactionCategory.comment)
    }
    
    static func makeImage(fromData data: NSData?) -> UIImage? {
        if let data = data, let image = UIImage(data: data as Data) {
            return image
        }
        return nil
    }
    
    static func makeData(fromImage image: UIImage?) -> NSData? {
        if let image = image, let data = UIImageJPEGRepresentation(image, 1.0) {
            return data as NSData
        }
        return nil
    }
    
}


extension FinTransactionCategory : Equatable {
    
    public static func ==(l: FinTransactionCategory, r: FinTransactionCategory) -> Bool {
        var isEqualIMages = false
        if let lImage = l.image, let rImage = r.image {
            isEqualIMages = lImage.isEqual(rImage)
        } else {
            isEqualIMages = (l.image == r.image)
        }
        
        return  l.categoryID == r.categoryID &&
                l.name == r.name &&
                isEqualIMages &&
                l.comment == r.comment
    }
    
    public func isEqualContents(to category: FinTransactionCategory) -> Bool {
        var isEqualIMages = false
        if let lImage = image, let rImage = category.image {
            isEqualIMages = lImage.isEqual(rImage)
        } else {
            isEqualIMages = (image == category.image)
        }
        
        return  name == category.name &&
                isEqualIMages &&
                comment == category.comment
    }

}
