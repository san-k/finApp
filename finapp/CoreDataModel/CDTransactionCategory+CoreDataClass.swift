//
//  CDTransactionCategory+CoreDataClass.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData

@objc(CDTransactionCategory)
public class CDTransactionCategory: NSManagedObject {

    convenience init(finTransactionCategory: FinTransactionCategory, context:NSManagedObjectContext) {
        self.init(context:context)
        self.categoryID = finTransactionCategory.categoryID.uuidString
        self.name = finTransactionCategory.name
        self.comment = finTransactionCategory.comment
        self.imageName = finTransactionCategory.imageName
    }
}
