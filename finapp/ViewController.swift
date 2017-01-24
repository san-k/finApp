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
        self.present(controller, animated: true, completion: nil)
        
    }

}

