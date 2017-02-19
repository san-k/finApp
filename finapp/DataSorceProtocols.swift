//
//  DataSorceProtocols.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation


protocol AddEntity {
    func add(finAccount: FinAccount) -> Bool
    func add(finTransaction: FinTransaction, toAccountWithID accountID: UUID) -> Bool
}

protocol UpdateEntity {
    func updateFinAccount(withID accountID: UUID, newName: String?, newCurency: Currency?, newComment: String?) -> Bool
    func updatefinTransaction(withID transactionID: UUID, newSum: Double?, newComment: String?) -> Bool
}

protocol GetEntityInfo {
    func getAllFinAccounts() -> [FinAccount]?
    func getAllFinCategories() -> [FinTransactionCategory]?
    func getAllSubCategories(forParentCatId parentCatId: UUID?) -> [FinTransactionCategory]?
    func getFinAccounts(withName name: String) -> [FinAccount]?
    func getFinAccount(withID accountID: UUID) -> FinAccount?
//
    func getFinTransactionsForAccount(withID accountID: UUID) -> [FinTransaction]?
}


protocol CalculateEntityInfo {
    
    // calculate amount of money which was spent during some perion of time...

    func countSubCategories(forParentCatId parentCatId: UUID?) -> Int
}
