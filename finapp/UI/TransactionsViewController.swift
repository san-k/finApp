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

    public var account: FinAccount?

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

    @IBOutlet fileprivate var tableView: UITableView!
    fileprivate var datasource: AddEntity & UpdateEntity & GetEntityInfo & RemoveEntity & CalculateEntityInfo!
    fileprivate var transactions: [FinTransaction]! {
        didSet { transactions = transactions ?? [] }
    }
    
    fileprivate func setup() {
        datasource = AppSettings.sharedSettings.datasource
        updateTransactionsInfo()
    }

    
    fileprivate func addBarButtons() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(showCategoriesController(sender:)))
        self.navigationItem.setRightBarButton(button, animated: false)
    }

    @objc fileprivate func showCategoriesController(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? CategoriesViewController else {return}
        controller.account = account
        controller.transactionsVC = self
        let nav = UINavigationController(rootViewController: controller)
        navigationController?.present(nav, animated: true, completion: nil)

    }
}

extension TransactionsViewController : UITableViewDelegate {
    //MARK: Long tap gesture
    @IBAction func longTapped(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            let point = gesture.location(in: tableView)
            guard let indexPath = tableView.indexPathForRow(at: point) else { return }
            guard transactions.count > indexPath.row else { return }
            let transaction = transactions[indexPath.row]
            
            let storyboard = UIStoryboard(name: "newTransactionUI", bundle: nil)
            guard let controller = storyboard.instantiateInitialViewController() as? NewTransactionViewController else { return }
            controller.oldTransaction = transaction
            controller.selectedAccount = account
            controller.transactionsVC = self
            let nav = UINavigationController(rootViewController: controller)
            navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard transactions.count > indexPath.row else { return }
            if datasource.removefinTransaction(withID: transactions[indexPath.row].transactionID) {
                transactions.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
}

    // MARK: UITableViewDataSource
extension TransactionsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
