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
    
    func add(finTransaction: FinTransaction, toAccountWithID accountID: UUID) -> Bool {
        
        // firdst we need to find account with current UUID
        // in case we failed - we will return false
        // in this method we're not going to cresate new one account, if it doesn't exists
        if let cdAccount = getCDFinAccount(withID: accountID) {
            let cdTransaction = CDTransaction(finTransaction: finTransaction, cdFinAccount: cdAccount, context: context)
            // relationship "transaction category -> transaction" is "one -> to many"
            // so category which is used by this finTransaction can exists
            // at first we need to check whether we have category in current finTransaction
            guard let finTransactionCategory = finTransaction.category else {return true}
            // then we try to find it by its ID in core data, if we fail, we gonna create new one
            if let cdTransactionCategory = getCDTransactionCategory(withID: finTransactionCategory.categoryID) {
                cdTransaction.category = cdTransactionCategory
            } else {
                let newCDTrCategory = CDTransactionCategory(finTransactionCategory: finTransactionCategory, context: context)
                cdTransaction.category = newCDTrCategory
            }
            
            return true
        }
        return false
    }
    
    // MARK: - GetEntityInfo protocol
    
    // MARK: Account
    func getAllFinAccounts() -> [FinAccount]? {
        return getFinAccounts(withPredicate: nil)
    }
    
    func getFinAccounts(withName name: String) -> [FinAccount]? {
        return getFinAccounts(withPredicate: NSPredicate(format: "name = %@", name))
    }
    
    func getFinAccount(withID accountID: UUID) -> FinAccount? {

        if let cdAccount = getCDFinAccount(withID: accountID) {
            let finAccount = FinAccount(fromCDFinAccount: cdAccount)
            return finAccount
        }
        return nil
    }
    
    // MARK: Category
    func getAllFinCategories() -> [FinTransactionCategory]? {
        let request: NSFetchRequest<CDTransactionCategory> = CDTransactionCategory.fetchRequest()
        if let results = try? context.fetch(request) {
            var finCategories = [FinTransactionCategory]()
            results.forEach{ finCategories.append(FinTransactionCategory(fromCDTransactionCategory: $0)!)}
            return finCategories
        }
        return nil
    }
    
    // MARK: Transaction
    func getFinTransactionsForAccount(withID accountID: UUID) -> [FinTransaction]? {
        if let cdTransactions = getCDFinTransaction(withPredicate: NSPredicate(format: "account.accountID = %@", accountID.uuidString)) {
            var finTransactions = [FinTransaction]()
            for cdTransaction in cdTransactions {
                let finTransaction = FinTransaction(fromCDTransaction: cdTransaction)
                finTransactions.append(finTransaction)
            }
            return finTransactions
        }
        return nil
    }
    
    // MARK: GetEntityInfo protocol (private methods)
    
    private func getCDTransactionCategory(withID categoryID: UUID) -> CDTransactionCategory? {
        let request: NSFetchRequest<CDTransactionCategory> = CDTransactionCategory.fetchRequest()
        request.predicate = NSPredicate(format: "categoryID = %@", categoryID.uuidString)
        if let results = try? context.fetch(request), let result = results.first {
            return result
        }
        return nil
    }
    
    private func getCDFinAccount(withID accountID: UUID) -> CDFinAccount? {
        let optionalResults = getCDFinAccounts(withPredicate: NSPredicate(format: "accountID = %@", accountID.uuidString))
        if let results = optionalResults, let result = results.first {
            return result
        }
        return nil
    }
    
    private func getFinAccounts(withPredicate predicate:NSPredicate?) -> [FinAccount]? {
        if let cdFinAccounts = getCDFinAccounts(withPredicate: predicate) {
            var finAccounts = [FinAccount]()
            for cdAccount in cdFinAccounts {
                let finAccount = FinAccount(fromCDFinAccount: cdAccount)
                finAccounts.append(finAccount)
            }
            return finAccounts
        }
        return nil
    }

    private func getCDFinAccounts(withPredicate predicate:NSPredicate?) -> [CDFinAccount]? {
        let request: NSFetchRequest<CDFinAccount> = CDFinAccount.fetchRequest()
        request.predicate = predicate
        if let cdFinAccounts = try? context.fetch(request) {
            return cdFinAccounts
        }
        return nil
    }

    private func getCDFinTransaction(withPredicate predicate:NSPredicate?) -> [CDTransaction]? {
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.predicate = predicate
        if let cdTransactions = try? context.fetch(request) {
            return cdTransactions
        }
        return nil
    }
    
    // MARK: UpdateEntity protocol
    
    func updateFinAccount(withID accountID: UUID, newName: String?, newCurency: Currency?, newComment: String?) -> Bool {
        guard let cdAccount = getCDFinAccount(withID: accountID) else {return false}
        if let newName = newName {cdAccount.name = newName}
        if let newCurency = newCurency {cdAccount.currency = newCurency.rawValue}
        if let newComment = newComment {cdAccount.comment = newComment}
        return true
    }
    
    func updatefinTransaction(withID transactionID: UUID, newSum: Double?, newComment: String?) -> Bool {
        if let cdTransaction = getCDFinTransaction(withPredicate: NSPredicate(format: "transaction.id = %@", transactionID.uuidString))?.first {
            if let newSum = newSum {cdTransaction.sum = newSum}
            if let newComment = newComment {cdTransaction.comment = newComment}
            return true
        }
        return false
    }
    
    
}
