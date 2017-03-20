//
//  ViewController.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/4/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit



class SummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let defaultAcoount = AppSettings.sharedSettings.defaultAccount {
            defaultAcoountButton.setTitle("Default account is \(defaultAcoount.name)", for: UIControlState.normal)
        } else {
            defaultAcoountButton.setTitle("Select default account", for: UIControlState.normal)
        }
    }

    @IBOutlet weak var previousMounthPut: UILabel!
    @IBOutlet weak var previousMountsTake: UILabel!
    @IBOutlet weak var currentMounthPut: UILabel!
    @IBOutlet weak var currentMountsTake: UILabel!
    @IBOutlet weak var currentWeekPut: UILabel!
    @IBOutlet weak var currentWeekTake: UILabel!
    
    fileprivate let dataSource = AppSettings.sharedSettings.datasource
    
    @IBOutlet weak var defaultAcoountButton: UIButton!

    @IBAction func selectDefaultAccount(_ sender: Any) {
        showAccountsController(with: AccountsViewController.AccountsControllerMode.selectDefaultAccount)
    }
    
    @IBAction func show(_ sender: Any) {
        showAccountsController(with: AccountsViewController.AccountsControllerMode.showTransactions)
    }
    
    fileprivate func showAccountsController(with mode: AccountsViewController.AccountsControllerMode) {
        let controller = AccountsViewController()
        controller.controllerMode = mode
        let navcontroller = self.navigationController
        navcontroller?.pushViewController(controller, animated: true)
    }

   
    @IBAction func showCAtegories(_ sender: UIButton) {

        if AppSettings.sharedSettings.defaultAccount == nil {
            return
        }

        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? CategoriesViewController else {return}
        controller.account = AppSettings.sharedSettings.defaultAccount
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isTranslucent = false
        navigationController?.present(nav, animated: true, completion: nil)
    }
}

