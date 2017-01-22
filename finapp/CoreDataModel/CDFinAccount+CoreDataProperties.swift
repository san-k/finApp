//
//  CDFinAccount+CoreDataProperties.swift
//  finapp
//
//  Created by Admin on 22.01.17.
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
    @NSManaged public var accountID: String
    @NSManaged public var name: String
    @NSManaged public var sum: Double
    @NSManaged public var transactions: NSOrderedSet

}

// MARK: Generated accessors for transactions
extension CDFinAccount {

    @objc(insertObject:inTransactionsAtIndex:)
    @NSManaged public func insertIntoTransactions(_ value: CDTransaction, at idx: Int)

    @objc(removeObjectFromTransactionsAtIndex:)
    @NSManaged public func removeFromTransactions(at idx: Int)

    @objc(insertTransactions:atIndexes:)
    @NSManaged public func insertIntoTransactions(_ values: [CDTransaction], at indexes: NSIndexSet)

    @objc(removeTransactionsAtIndexes:)
    @NSManaged public func removeFromTransactions(at indexes: NSIndexSet)

    @objc(replaceObjectInTransactionsAtIndex:withObject:)
    @NSManaged public func replaceTransactions(at idx: Int, with value: CDTransaction)

    @objc(replaceTransactionsAtIndexes:withTransactions:)
    @NSManaged public func replaceTransactions(at indexes: NSIndexSet, with values: [CDTransaction])

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: CDTransaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: CDTransaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSOrderedSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSOrderedSet)

}
