//
//  CDTransactionCategory+CoreDataProperties.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData


extension CDTransactionCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransactionCategory> {
        return NSFetchRequest<CDTransactionCategory>(entityName: "CDTransactionCategory");
    }

    @NSManaged public var categoryID: String?
    @NSManaged public var comment: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?

}
