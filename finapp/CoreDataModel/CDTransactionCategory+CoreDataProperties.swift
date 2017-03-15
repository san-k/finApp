//
//  CDTransactionCategory+CoreDataProperties.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 3/15/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData


extension CDTransactionCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransactionCategory> {
        return NSFetchRequest<CDTransactionCategory>(entityName: "CDTransactionCategory");
    }

    @NSManaged public var categoryID: String
    @NSManaged public var comment: String
    @NSManaged public var imageName: String?
    @NSManaged public var name: String
    @NSManaged public var parentCategory: CDTransactionCategory?
    @NSManaged public var subcategories: NSSet?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for subcategories
extension CDTransactionCategory {

    @objc(addSubcategoriesObject:)
    @NSManaged public func addToSubcategories(_ value: CDTransactionCategory)

    @objc(removeSubcategoriesObject:)
    @NSManaged public func removeFromSubcategories(_ value: CDTransactionCategory)

    @objc(addSubcategories:)
    @NSManaged public func addToSubcategories(_ values: NSSet)

    @objc(removeSubcategories:)
    @NSManaged public func removeFromSubcategories(_ values: NSSet)

}

// MARK: Generated accessors for transactions
extension CDTransactionCategory {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: CDTransaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: CDTransaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
