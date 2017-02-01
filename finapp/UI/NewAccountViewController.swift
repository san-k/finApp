//
//  NewAccountViewController.swift
//  finapp
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var nameText: UITextField!
    @IBOutlet var startSumText: UITextField!
    @IBOutlet var categoryTable: UITableView!
    @IBOutlet var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet var commentTextView: UITextView!

    var categories: [FinTransactionCategory]?
    
    
    // PRIVATE PROPERTIES
    private var account: FinAccount?
    
    
    
    
    @IBAction func categoryTapped(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        categoryTable.register(UINib(nibName: "TransactionCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: TransactionCategoryTableViewCell.staticIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: - table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCategoryTableViewCell.staticIdentifier, for: indexPath) as! TransactionCategoryTableViewCell
        return cell
    }
}
