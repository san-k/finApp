//
//  CDDataSource.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData


struct CDDataSourse : AddEntity, UpdateEntity, GetEntityInfo, CalculateEntityInfo {
    
    let context = CDController.persistentContainer.viewContext
    
    // MARK: - AddEntity protocol
    
    func add(finAccount: FinAccount) -> Bool {
        let _ = CDFinAccount(finAccount: finAccount, context: context)
        return true
    }
    
    func add(finTransaction: FinTransaction, toAccountWithID: UUID) -> Bool {
        
        
        
        return true
    }
    
    // MARK: - GetEntityInfo protocol
    
    func getFinAccount(withID id: UUID) -> FinAccount? {
        let request: NSFetchRequest<CDFinAccount>  = CDFinAccount.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id.uuidString)
        if let results = try? context.fetch(request), let result = results.first {
            let finAccount = FinAccount(name: result.name,
                                        currency: Currency(rawValue:result.currency)!,
                                        comment: result.comment,
                                        totalSum: result.sum)
            return finAccount
        }
        
        return nil
    }
    
}
