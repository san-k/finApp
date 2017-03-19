//
//  CDTransaction+CoreDataClass.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData

@objc(CDTransaction)
public class CDTransaction: NSManagedObject {

    convenience init(finTransaction: FinTransaction, cdFinAccount: CDFinAccount, context: NSManagedObjectContext) {
        self.init(context: context)
        self.date = finTransaction.date as NSDate
        self.sum = finTransaction.sum
        self.transactionID = finTransaction.transactionID.uuidString
        /// Convert from Swift's widest signed integer type, trapping on
        /// overflow.
        self.transactionType = Int32(finTransaction.transactionType.rawValue)
        self.comment = finTransaction.comment
        self.account = cdFinAccount
        
        switch finTransaction.transactionType {
        case .PutMoney: cdFinAccount.sum += finTransaction.sum
        case .TakeMoney: cdFinAccount.sum -= finTransaction.sum
        }
    }
    
    public override func prepareForDeletion() {
        super.prepareForDeletion()
        let trType = FinTransactionType(rawValue: Int(transactionType))!
        switch trType {
        case .PutMoney: account.sum -= sum
        case .TakeMoney: account.sum += sum
        }
    }
}
