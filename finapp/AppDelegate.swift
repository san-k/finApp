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
        
        let dataSourse = AppSettings.sharedSettings.datasource
        let facc0 = FinAccount(name: "FirstFinAccount", currency: Currency.GRN, comment: "first", startSum: 0.0);
        let _ = dataSourse.add(finAccount: facc0)

        let facc1 = FinAccount(name: "SecondFinAccount", currency: Currency.GRN, comment: "second", startSum: 10.0);
        let _ = dataSourse.add(finAccount: facc1)

        
        var firstCategory: FinTransactionCategory!
        
        for counter in 1..<5 {
            let category = FinTransactionCategory(name: "Food - \(counter)", image: nil, comment: "This is category N \(counter)")
            if counter == 1 { firstCategory = category }
            let _ = dataSourse.add(transactionCategory: category, withParentCategory: nil)
//            let tr = FinTransaction(transactionType: FinTransactionType.PutMoney, sum: 10.0 * Double(counter), category: category, date: Date(), comment: "transaction comment N \(counter)")
//            let _ = dataSourse.add(finTransaction: tr, toAccountWithID: facc0.accountID)
        }

        for counter in 6..<9 {
            let tr = FinTransaction(transactionType: FinTransactionType.PutMoney, sum: 10.0 * Double(counter), category: FinTransactionCategory(name: "Food - \(counter)", image: nil, comment: "This is category N \(counter)"), date: Date(), comment: "transaction comment N \(counter)")
            let _ = dataSourse.add(finTransaction: tr, toAccountWithID: facc1.accountID)
        }

        for counter in 1..<10 {
            let cat = FinTransactionCategory(name: "subcategory\(counter)", image: nil, comment: "This is subcategory\(counter)")
            let _ = dataSourse.add(transactionCategory: cat, withParentCategory: firstCategory)
        }
        
        
        
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

