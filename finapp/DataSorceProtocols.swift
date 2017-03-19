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
    func add(transactionCategory: FinTransactionCategory, withParentCategory parentCategory: FinTransactionCategory?) -> Bool
}

protocol UpdateEntity {
    func updateFinAccount(withID accountID: UUID, newAccount: FinAccount) -> Bool
    func updatefinTransaction(withID transactionID: UUID, newTransaction: FinTransaction) -> Bool
    func updateCategory(withID categoryID: UUID, newCategory: FinTransactionCategory) -> Bool

}

protocol GetEntityInfo {
    func getAllFinAccounts() -> [FinAccount]?
    func getAllFinCategories() -> [FinTransactionCategory]?
    
    func getAllSubCategories(forParentCatId parentCatId: UUID?) -> [FinTransactionCategory]?
    func getCategory(withName name: String, parentID: UUID?) -> FinTransactionCategory?
    
    func getFinAccounts(withName name: String) -> [FinAccount]?
    func getFinAccount(withID accountID: UUID) -> FinAccount?
//
    func getFinTransactionsForAccount(withID accountID: UUID) -> [FinTransaction]?
}

protocol RemoveEntity {
    func removeFinAccount(withID accountID: UUID) -> Bool
    func removefinTransaction(withID transactionID: UUID) -> Bool
    func removeCategory(withID categoryID: UUID) -> Bool

}


protocol CalculateEntityInfo {
    
    // calculate amount of money which was spent during some perion of time...

    func sumOf(plusTransactionsAfAccountID accountID: UUID, fromDate: Date, toDate: Date) -> Double?
    func sumOf(minusTransactionsAfAccountID accountID: UUID, fromDate: Date, toDate: Date) -> Double?
    
    func countSubCategories(forParentCatId parentCatId: UUID?) -> Int
}
