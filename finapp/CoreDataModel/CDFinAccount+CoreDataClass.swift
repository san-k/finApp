//
//  CDFinAccount+CoreDataClass.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData

@objc(CDFinAccount)
public class CDFinAccount: NSManagedObject {

    convenience init(finAccount: FinAccount, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.accountID = finAccount.accountID.uuidString
        self.name = finAccount.name
        self.sum = finAccount.totalSum
        self.currency = finAccount.currency.rawValue
        self.comment = finAccount.comment
    }
    
}
