//
//  ViewController.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/4/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func show(_ sender: Any) {
     
        let controller = AccountsViewController()
        let navcontroller = self.navigationController
        navcontroller?.pushViewController(controller, animated: true)
    }

   
    @IBAction func showCAtegories(_ sender: UIButton) {

        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? CategoriesViewController else {return}
        // hardcoded part, should be changed to take info from NSUserDefaults
        controller.account = AppSettings.sharedSettings.datasource.getAllFinAccounts()?.first
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isTranslucent = false
        navigationController?.present(nav, animated: true, completion: nil)
    }
}

