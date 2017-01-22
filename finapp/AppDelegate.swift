//
//  AppDelegate.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/4/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let _ = CDController.persistentContainer
        
        print("------------ add acoount test, get coount by ID tests start ------------")
        let dataSourse = AppSettings.sharedSettings.datasource
        let facc00 = FinAccount(name: "FirstFinAccount", currency: Currency.GRN, comment: "first", startSum: 0.0);
        let _ = dataSourse.add(finAccount: facc00)
        guard let facc01 = dataSourse.getFinAccount(withID: facc00.accountID) else { return true}
        
        print("result fin account = \(facc01)")
        print("------------ test end ------------\n\n")
        
        // ------------------------------------------------------------------------------------
        
        print("------------ get all accounts test - should be a list of two items test start ------------")
        // add one more account
        let facc10 = FinAccount(name: "SecondFinAccount", currency: Currency.GRN, comment: "second", startSum: 10.0);
        let _ = dataSourse.add(finAccount: facc10)
        guard let faccList = dataSourse.getAllFinAccounts() else {return true}
        
        print("result list of all accounts = \n")
        faccList.forEach{print("---> \($0)\n")}
        print("------------ test end ------------\n\n")
        
        // ------------------------------------------------------------------------------------
        
        print("------------ add cd transaction test start ------------")
        let tr01 = FinTransaction(transactionType: FinTransactionType.PutMoney, sum: 10.0, category: FinTransactionCategory(name: "Food", image: nil, comment: "This is food"), date: Date(), comment: "I bought eggs")
        let tr02 = FinTransaction(transactionType: FinTransactionType.PutMoney, sum: 20.0, category: FinTransactionCategory(name: "Food2", image: nil, comment: "This is food2"), date: Date(), comment: "I bought bread")
        let _ = dataSourse.add(finTransaction: tr01, toAccountWithID: facc10.accountID)
        let _ = dataSourse.add(finTransaction: tr02, toAccountWithID: facc10.accountID)
        
        guard let transactions = dataSourse.getFinTransactionsForAccount(withID: facc10.accountID) else {return true}
        print("transaction list = \n")
        transactions.forEach{print("---> \($0)\n")}
        print("------------ test end ------------\n\n")
        // ------------------------------------------------------------------------------------
        
//        print("------------  test start ------------")
//        print("------------ test end ------------")
//        // ------------------------------------------------------------------------------------
//        
//        print("------------  test start ------------")
//        print("------------ test end ------------")

        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CDController.saveContext()
    }
}

