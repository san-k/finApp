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
            let _ = CDTransaction(finTransaction: finTransaction, cdFinAccount: cdAccount, context: context)
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
            let finAccount = FinAccount(name: cdAccount.name,
                                        currency: Currency(rawValue:cdAccount.currency)!,
                                        comment: cdAccount.comment,
                                        totalSum: cdAccount.sum)
            return finAccount
        }
        return nil
    }
    
    // MARK: Transaction
    func getFinTransactionsForAccount(withID accountID: UUID) -> [FinTransaction]? {
        if let cdTransactions = getCDFinTransaction(withPredicate: NSPredicate(format: "account.id = %@", accountID.uuidString)) {
            var finTransactions = [FinTransaction]()
            for cdTransaction in cdTransactions {
                let transactionID = UUID(uuidString: cdTransaction.transactionID)!
                let finTransaction = FinTransaction(transactionID: transactionID,
                                                    transactionType: FinTransactionType(rawValue: Int(cdTransaction.transactionType))!,
                                                    sum: cdTransaction.sum,
                                                    category: getFinTransactionCategory(fromCDTransactionCategory: cdTransaction.category),
                                                    date: cdTransaction.date as Date)
                finTransactions.append(finTransaction)
            }
            return finTransactions
        }
        return nil
    }
    
    // MARK: GetEntityInfo protocol (private methods)
    
    private func getCDFinAccount(withID accountID: UUID) -> CDFinAccount? {
        let optionalResults = getCDFinAccounts(withPredicate: NSPredicate(format: "id = %@", accountID.uuidString))
        if let results = optionalResults, let result = results.first {
            return result
        }
        return nil
    }

    private func getFinTransactionCategory(fromCDTransactionCategory cdTransactionCategory: CDTransactionCategory?) -> FinTransactionCategory? {
        guard let category = cdTransactionCategory else {return nil}
        let finCategory = FinTransactionCategory(categoryID: UUID(uuidString: category.categoryID)!,
                                                 name:category.name,
                                                 image: FinTransactionCategory.setImage(fromData: category.image),
                                                 comment: category.comment)
        return finCategory
    }
    
    private func getFinAccounts(withPredicate predicate:NSPredicate?) -> [FinAccount]? {
        if let cdFinAccounts = getCDFinAccounts(withPredicate: predicate) {
            var finAccounts = [FinAccount]()
            for cdAccount in cdFinAccounts {
                let finAccount = FinAccount(name: cdAccount.name,
                                            currency: Currency(rawValue:cdAccount.currency)!,
                                            comment: cdAccount.comment,
                                            totalSum: cdAccount.sum)
                finAccounts.append(finAccount)
            }
            return finAccounts
        }
        return nil
    }

    private func getCDFinAccounts(withPredicate predicate:NSPredicate?) -> [CDFinAccount]? {
        let request: NSFetchRequest<CDFinAccount> = CDFinAccount.fetchRequest()
        request.predicate = predicate != nil ? predicate : NSPredicate()
        if let cdFinAccounts = try? context.fetch(request) {
            return cdFinAccounts
        }
        return nil
    }

    private func getCDFinTransaction(withPredicate predicate:NSPredicate?) -> [CDTransaction]? {
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.predicate = predicate != nil ? predicate : NSPredicate()
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
