//
//  CDDataSource.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import CoreData


struct CDDataSourse{
    
    let context = CDController.persistentContainer.viewContext
}

// MARK: - AddEntity protocol
extension CDDataSourse : AddEntity {
    
    func add(finAccount: FinAccount) -> Bool {
        let _ = CDFinAccount(finAccount: finAccount, context: context)
        return true
    }
    
    func add(finTransaction: FinTransaction, toAccountWithID accountID: UUID) -> Bool {
        
        // first we need to find account with current UUID
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
    
    func add(transactionCategory: FinTransactionCategory, withParentCategory parentCategory: FinTransactionCategory?) -> Bool {
        
        // first we need to check if there is category with such name with parent with such (second parameter) name
        // if it is found then ignore adding new one
        // but here we allow to add category with existing name, but in different parent name
        // it's useful to check in UI, and ask user if he makes it deliberately
        
        if let _ = getCategory(withName: transactionCategory.name, parentID: parentCategory?.categoryID) {
            // category already exists
            return false
        }
        
        // ok. we need to add. but at first we nedd to find parrent category
        // first of all parrent can be nil in case of root category
        var parentCDCategory: CDTransactionCategory? = nil
        
        if let parentCategory = parentCategory {
            parentCDCategory = getCDCategories(withPredicate: NSPredicate(format: "categoryID = %@", parentCategory.categoryID.uuidString))?.first
        }
        
        let category = CDTransactionCategory(finTransactionCategory: transactionCategory, context: context)
        category.parentCategory = parentCDCategory
        category.parentCategory?.subcategoriesCount += 1

        return true
    }
}

// MARK: - GetEntityInfo protocol
extension CDDataSourse : GetEntityInfo {
    
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
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? context.fetch(request) {
            var finCategories = [FinTransactionCategory]()
            results.forEach{ finCategories.append(FinTransactionCategory(fromCDTransactionCategory: $0))}
            return finCategories
        }
        return nil
    }
    
    func getAllSubCategories(forParentCatId parentCatId: UUID?) -> [FinTransactionCategory]? {
        let request: NSFetchRequest<CDTransactionCategory> = CDTransactionCategory.fetchRequest()
        if let parentCatId = parentCatId {
            request.predicate = NSPredicate(format: "parentCategory.categoryID = %@", parentCatId.uuidString)
        } else {
            request.predicate = NSPredicate(format: "parentCategory = nil")
        }
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? context.fetch(request) {
            var finCategories = [FinTransactionCategory]()
            results.forEach{ finCategories.append(FinTransactionCategory(fromCDTransactionCategory: $0))}
            return finCategories
        }
        return nil
    }
    
    func getCategory(withName name: String, parentID: UUID?) -> FinTransactionCategory? {
        var predicate: NSPredicate?
        if let parentID = parentID {
            predicate = NSPredicate(format: "name = %@ and parentCategory.categoryID = %@", name, parentID.uuidString)
        } else {
            predicate = NSPredicate(format: "name = %@ and parentCategory.name = nil", name)
        }
        return  getFinCategories(withPredicate: predicate)?.first
    }

    
    fileprivate func getFinCategories(withPredicate predicate: NSPredicate?) -> [FinTransactionCategory]? {
        return getCDCategories(withPredicate: predicate).map{ $0.map{ FinTransactionCategory(fromCDTransactionCategory: $0) } }
    }

    
    fileprivate func getCDCategories(withPredicate predicate: NSPredicate?) -> [CDTransactionCategory]? {
        let request: NSFetchRequest<CDTransactionCategory> = CDTransactionCategory.fetchRequest()
        request.predicate = predicate
        return try? context.fetch(request)
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
    
    // MARK: GetEntityInfo protocol (fileprivate methods)
    
    fileprivate func getCDTransactionCategory(withID categoryID: UUID) -> CDTransactionCategory? {
        let request: NSFetchRequest<CDTransactionCategory> = CDTransactionCategory.fetchRequest()
        request.predicate = NSPredicate(format: "categoryID = %@", categoryID.uuidString)
        if let results = try? context.fetch(request), let result = results.first {
            return result
        }
        return nil
    }
    
    fileprivate func getCDFinAccount(withID accountID: UUID) -> CDFinAccount? {
        let optionalResults = getCDFinAccounts(withPredicate: NSPredicate(format: "accountID = %@", accountID.uuidString))
        if let results = optionalResults, let result = results.first {
            return result
        }
        return nil
    }
    
    fileprivate func getFinAccounts(withPredicate predicate:NSPredicate?) -> [FinAccount]? {
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

    fileprivate func getCDFinAccounts(withPredicate predicate:NSPredicate?) -> [CDFinAccount]? {
        let request: NSFetchRequest<CDFinAccount> = CDFinAccount.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true) ]
        if let cdFinAccounts = try? context.fetch(request) {
            return cdFinAccounts
        }
        return nil
    }

    fileprivate func getCDFinTransaction(withPredicate predicate:NSPredicate?) -> [CDTransaction]? {
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        if let cdTransactions = try? context.fetch(request) {
            return cdTransactions
        }
        return nil
    }
}

    // MARK: UpdateEntity protocol
extension CDDataSourse : UpdateEntity {
    
    func updateFinAccount(withID accountID: UUID, newAccount: FinAccount) -> Bool {
        guard let cdAccount = getCDFinAccount(withID: accountID) else {return false}
        cdAccount.name = newAccount.name
        cdAccount.comment = newAccount.comment
        cdAccount.currency = newAccount.currency.rawValue
        return true
    }
    
    func updatefinTransaction(withID transactionID: UUID, newTransaction: FinTransaction) -> Bool {
        if let cdTransaction = getCDFinTransaction(withPredicate: NSPredicate(format: "transactionID = %@", transactionID.uuidString))?.first {
            cdTransaction.comment = newTransaction.comment
            cdTransaction.date = newTransaction.date as NSDate
            
            guard let oldTransactionType = FinTransactionType(rawValue: Int(cdTransaction.transactionType)) else { return false }
            let realOldTransactionSum = oldTransactionType == .TakeMoney ? cdTransaction.sum * -1 : cdTransaction.sum
            let realNewTransactionSum = newTransaction.transactionType == .TakeMoney ? newTransaction.sum * -1 : newTransaction.sum
            cdTransaction.account.sum += realNewTransactionSum
            cdTransaction.account.sum -= realOldTransactionSum

            cdTransaction.sum = newTransaction.sum
            cdTransaction.transactionType = Int32(newTransaction.transactionType.rawValue)
            return true
        }
        return false
    }
    
    func updateCategory(withID categoryID: UUID, newCategory: FinTransactionCategory) -> Bool {
        guard let cdCategory = getCDCategories(withPredicate: NSPredicate(format: "categoryID = %@", categoryID.uuidString))?.first else { return false }
        cdCategory.name = newCategory.name
        cdCategory.imageName = newCategory.imageName
        cdCategory.comment = newCategory.comment
        return true
    }
    
}


extension CDDataSourse : RemoveEntity {
    func removeFinAccount(withID accountID: UUID) -> Bool {
        let cdAccount = getCDFinAccount(withID: accountID)
        return remove(managedObject: cdAccount)
    }
    
    func removefinTransaction(withID transactionID: UUID) -> Bool {
        let cdTransaction = getCDFinTransaction(withPredicate: NSPredicate(format: "transactionID = %@", transactionID.uuidString))?.first
        return remove(managedObject: cdTransaction)
    }
    func removeCategory(withID categoryID: UUID) -> Bool {
        let cdCategory = getCDTransactionCategory(withID: categoryID)
        return remove(managedObject: cdCategory)
    }
    
    fileprivate func remove(managedObject: NSManagedObject?) -> Bool {
        if let managedObject = managedObject {
            context.delete(managedObject)
            return true
        } else {
            return false
        }
    }
}


extension CDDataSourse : CalculateEntityInfo {

    func countSubCategories(forParentCatId parentCatId: UUID?) -> Int {
        let request: NSFetchRequest<CDTransactionCategory> = CDTransactionCategory.fetchRequest()
        if let parentCatId = parentCatId {
            request.predicate = NSPredicate(format: "parentCategory.categoryID = %@",parentCatId.uuidString)
        } else {
            request.predicate = NSPredicate(format: "parentCategory = nil")
        }
        if let countCategories = try? context.count(for: request) {
            return countCategories
        }
        return 0

    }
    
    func sumOf(plusTransactionsAfAccountID accountID: UUID, fromDate: Date, toDate: Date) -> Double? {
        let predicate = NSPredicate(format: "(date >= %@) and (date <= %@) and (transactionType = %d)", fromDate as NSDate, toDate as NSDate, FinTransactionType.PutMoney.rawValue)
        if let transactions = getCDFinTransaction(withPredicate: predicate) {
            let sum = transactions.reduce(0.0, { $0 + $1.sum})
            print("plus sum = \(sum)")
            return sum
        }
        return 0.0
    }
    
//        var amountTotal : Double = 0
//        
//        // Step 1:
//        // - Create the summing expression on the amount attribute.
//        // - Name the expression result as 'amountTotal'.
//        // - Assign the expression result data type as a Double.
//        
//        let expression = NSExpressionDescription()
//        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "sum")])
//        expression.name = "amountTotal";
//        expression.expressionResultType = NSAttributeType.doubleAttributeType
//        
//        // Step 2:
//        // - Create the fetch request for the Movement entity.
//        // - Indicate that the fetched properties are those that were
//        //   described in `expression`.
//        // - Indicate that the result type is a dictionary.
//        
//        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "CDTransaction")
//        fetchRequest.propertiesToFetch = [expression]
//        fetchRequest.resultType = .dictionaryResultType
//        
//        // Step 3:
//        // - Execute the fetch request which returns an array.
//        // - There will only be one result. Get the first array
//        //   element and assign to 'resultMap'.
//        // - The summed amount value is in the dictionary as
//        //   'amountTotal'. This will be summed value.
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            let resultMap = results[0] as! [String:Double]
//            amountTotal = resultMap["amountTotal"]!
//            print(amountTotal)
//        } catch let error as NSError {
//            NSLog("Error when summing amounts: \(error.localizedDescription)")
//        }
//        
//        return amountTotal
        
//        
//        let request = NSFetchRequest<NSDictionary>(entityName: "CDTransaction")
//        // request.predicate = NSPredicate(format: "(date >= %@) and (date <= %@)", fromDate as NSDate, toDate as NSDate)
////        request.predicate = NSPredicate(format: "(date >= %@) and (date <= %@) and (transactionType = %d)", fromDate as NSDate, toDate as NSDate, FinTransactionType.PutMoney.rawValue)
//        request.resultType = .dictionaryResultType
//        
//        let description = NSExpressionDescription()
//        description.name = "moneySum"
//        // NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "amount")])
//        description.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath:"sum")])
//        description.expressionResultType = NSAttributeType.doubleAttributeType
//        
//        request.propertiesToFetch = [description]
//
//        if let results = try? context.fetch(request){
//            print(results)
//            // print(results[0]["moneySum"] ?? "noValue")
//        } else {
//            print("fail")
//        }
//        return nil
    
    func sumOf(minusTransactionsAfAccountID accountID: UUID, fromDate: Date, toDate: Date) -> Double?
    {
        let predicate = NSPredicate(format: "(date >= %@) and (date <= %@) and (transactionType = %d)", fromDate as NSDate, toDate as NSDate, FinTransactionType.TakeMoney.rawValue)
        if let transactions = getCDFinTransaction(withPredicate: predicate) {
            let sum = transactions.reduce(0.0, { $0 + $1.sum})
            print("minus sum = \(sum)")
            return sum
        }
        return 0.0
    }
}








