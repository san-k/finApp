//
//  AccountsViewController.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/24/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

let kAccountCellIdentifier = "accountCellIdentifier"

class AccountsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var datasource: AddEntity & UpdateEntity & GetEntityInfo & CalculateEntityInfo!
    
    /*  little cache */
    var accounts: [FinAccount]!
    
    
    
    fileprivate func setup() {
        datasource = AppSettings.sharedSettings.datasource
        setUpCell()
        addBarButtons()
    }
    
    func updateAccountsInfo() {
        accounts = datasource.getAllFinAccounts()
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAccountsInfo()
    }
    
    
    fileprivate func setUpCell() {
        tableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: kAccountCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 71
    }
    
    fileprivate func addBarButtons() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(showAddAccountPage(sender:)))
        self.navigationItem.setRightBarButton(button, animated: false)
    }
    
    @objc fileprivate func showAddAccountPage(sender: UIBarButtonItem) {
        let newAccountController = NewAccountViewController()
        newAccountController.accountsVC = self
        let navController = UINavigationController(rootViewController: newAccountController)
        self.present(navController, animated: true, completion: nil)
    }
}

extension AccountsViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kAccountCellIdentifier, for: indexPath) as! AccountTableViewCell
        cell.delegate = self
        if accounts.count > indexPath.row {
            cell.accountName.text = accounts[indexPath.row].name
            cell.accountSum.text = String(accounts[indexPath.row].totalSum)
        }
        return cell
    }
}

    // MARK: AccountsCellDelegate
extension AccountsViewController : AccountsCellDelegate {

    func accessoryTapped(_ sender: UIButton, inCell cell: UITableViewCell) {
        guard let row = tableView.indexPath(for: cell)?.row else { return }
        guard accounts.count > row else { return }
        let account = accounts[row]
        let transactionsController = TransactionsViewController()
        transactionsController.account = account
        self.navigationController?.pushViewController(transactionsController, animated: true)
    }

}
