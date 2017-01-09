//
//  CDFinAccount+CoreDataProperties.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData


extension CDFinAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFinAccount> {
        return NSFetchRequest<CDFinAccount>(entityName: "CDFinAccount");
    }

    @NSManaged public var comment: String
    @NSManaged public var currency: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var sum: Double

}
