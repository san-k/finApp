//
//  CDTransaction+CoreDataProperties.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData


extension CDTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransaction> {
        return NSFetchRequest<CDTransaction>(entityName: "CDTransaction");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var sum: Double
    @NSManaged public var transactionID: String?
    @NSManaged public var transactionType: Int32

}
