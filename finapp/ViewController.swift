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

//        let controller = CategoriesViewController(nibName: "Categories", bundle: nil)
        
        
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        if let controller = controller {
            self.navigationController?.pushViewController(controller, animated: true)
        }
        

//
//        if let controller = controller {
//            let segue = UIStoryboardSegue(identifier: "fromRootToCategories", source: self, destination: controller)
//            segue.perform()
//        }
        
    }
}

