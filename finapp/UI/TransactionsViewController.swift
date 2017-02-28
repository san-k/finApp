//
//  TransactionsViewController.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/27/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

let kTransactionCellIdentifier = "transactionCellIdentifier"

class TransactionsViewController: UIViewController {


    @IBOutlet var tableView: UITableView!
    var datasource: AddEntity & UpdateEntity & GetEntityInfo & CalculateEntityInfo!

    /*  little cache */
    public var account: FinAccount?
    public var transactions: [FinTransaction]?
    
    fileprivate func setup() {
        datasource = AppSettings.sharedSettings.datasource
        updateTransactionsInfo()
    }

    public func updateTransactionsInfo()
    {
        if let account = account {
            transactions = datasource.getFinTransactionsForAccount(withID: account.accountID)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: kTransactionCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99
        addBarButtons()
    }
    
    fileprivate func addBarButtons() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(showAddTransactionStory(sender:)))
        self.navigationItem.setRightBarButton(button, animated: false)
    }

    @objc fileprivate func showAddTransactionStory(sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {return}
        let nav = UINavigationController(rootViewController: controller)
        navigationController?.present(nav, animated: true, completion: nil)
    }
}

    // MARK: UITableViewDataSource
extension TransactionsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let transactions = transactions else { return 0 }
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let transactions = transactions else { return UITableViewCell() }
        let transactionCell =  self.tableView.dequeueReusableCell(withIdentifier: kTransactionCellIdentifier, for: indexPath) as! TransactionsTableViewCell
        if transactions.count > indexPath.row {
            let finTransaction = transactions[indexPath.row]
            transactionCell.category.text = finTransaction.category?.name
            transactionCell.comment.text = finTransaction.comment
            transactionCell.set(sum: finTransaction.sum, transactionType: finTransaction.transactionType)
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "dd.MM.YYYY"
            transactionCell.date.text = formatter.string(from: finTransaction.date)
        }
        
        return transactionCell
    }
}
