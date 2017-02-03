//
//  NewAccountViewController.swift
//  finapp
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var nameText: UITextField!
    @IBOutlet var startSumText: UITextField!
    @IBOutlet var categoryTable: UITableView!
    @IBOutlet var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet var commentTextView: UITextView!

    // 'in' property - should be set during segueing
    var categories: [FinTransactionCategory]?
    
    
    // PRIVATE PROPERTIES
    private var account: FinAccount?
    
    
    @IBAction func categoryTapped(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        setupCell()
        addBarButtons()
    }

    private func setupCell() {
        categoryTable.register(UINib(nibName: "TransactionCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: TransactionCategoryTableViewCell.staticIdentifier)
        categoryTable.rowHeight = UITableViewAutomaticDimension
        categoryTable.estimatedRowHeight = 71

    }
    
    private func addBarButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelTapped(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneTapped(sender:)))
        self.navigationItem.setLeftBarButton(cancelButton, animated: false)
        self.navigationItem.setRightBarButton(doneButton, animated: false)
    }
    
    @objc private func cancelTapped(sender: UIBarButtonSystemItem) {
        dismiss(animated: true) { 
            
        }
    }
    
    @objc private func doneTapped(sender: UIBarButtonSystemItem) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startSumText.resignFirstResponder()
    }
    
    //MARK: - textView delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
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
        if let categories = categories, categories.count > indexPath.row {
            cell.name.text = categories[indexPath.row].name
        }
        return cell
    }
}


