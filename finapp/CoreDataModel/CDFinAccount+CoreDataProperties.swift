//
//  CDFinAccount+CoreDataProperties.swift
//  finapp
//
//  Created by Admin on 15.01.17.
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
    @NSManaged public var transactions: NSSet

}

// MARK: Generated accessors for transactions
extension CDFinAccount {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: CDTransaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: CDTransaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
