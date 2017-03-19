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

    // we reuse this controller in different modes
    // behavious differs by didSelectRow... in accounts table
    // showTransactions - shows transactionscontroller with transactions for this account
    // selectDefaultAccount - goes back to summary page and sets selected accouns as sdefault acoount
    public enum AccountsControllerMode {
        case showTransactions
        case selectDefaultAccount
    }
    
    public var controllerMode: AccountsControllerMode?
    
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
    
    
    @IBOutlet fileprivate var tableView: UITableView!
    
    fileprivate var datasource = AppSettings.sharedSettings.datasource
    fileprivate var accounts: [FinAccount]! {
        didSet { accounts = accounts ?? []}
    }

    
    fileprivate func setup() {
        setUpCell()
        addBarButtons()
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
        showNewAccountController(withOldAccount: nil)
    }
    
    fileprivate func showNewAccountController(withOldAccount oldAccount: FinAccount?) {
        let newAccountController = NewAccountViewController()
        newAccountController.accountsVC = self
        newAccountController.oldAccount = oldAccount
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
        cell.selectionStyle = .none
        if accounts.count > indexPath.row {
            cell.set(from: accounts[indexPath.row])
        } else {
            cell.set(from: nil)
        }
        return cell
    }
}

extension AccountsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controllerMode = controllerMode else { return }
        guard accounts.count > indexPath.row else { return }
        let account = accounts[indexPath.row]
        
        switch controllerMode {
        case .selectDefaultAccount: setDefaultAccount(account)
        case .showTransactions: pushTransactionsController(for: account)
        }
    }
    
    fileprivate func pushTransactionsController(for account: FinAccount) {
        let transactionsController = TransactionsViewController()
        transactionsController.account = account
        self.navigationController?.pushViewController(transactionsController, animated: true)
    }
    
    fileprivate func setDefaultAccount(_ account: FinAccount) {
        AppSettings.sharedSettings.defaultAccount = account
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func longTappedOnTableView(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            let point = longPress.location(in: tableView)
            guard let indexPath = tableView.indexPathForRow(at: point) else { return }
            guard accounts.count > indexPath.row else { return }
            let account = accounts[indexPath.row]
            showNewAccountController(withOldAccount: account)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard accounts.count > indexPath.row else { return }
            if datasource.removeFinAccount(withID: accounts[indexPath.row].accountID) {
                accounts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
}
