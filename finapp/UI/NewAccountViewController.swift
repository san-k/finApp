//
//  NewAccountViewController.swift
//  finapp
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController {

    @IBOutlet var nameText: UITextField!
    @IBOutlet var startSumText: UITextField!
    @IBOutlet var categoryTable: UITableView!
    @IBOutlet var commentTextView: UITextView!

    
    
    // PRIVATE PROPERTIES
    private var account: FinAccount?
    
    
    
    
    @IBAction func categoryTapped(_ sender: UIButton) {
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
}
