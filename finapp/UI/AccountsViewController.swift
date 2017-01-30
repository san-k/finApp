//
//  AccountsViewController.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/24/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

let kAccountCellIdentifier = "accountCellIdentifier"

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AccountsCellDelegate {

    @IBOutlet var tableView: UITableView!
    var datasource: AddEntity & UpdateEntity & GetEntityInfo & CalculateEntityInfo!
    
    /*  little cache */
    var accounts: [FinAccount]!
    
    
    override func awakeFromNib() {
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    private func setup() {
        datasource = AppSettings.sharedSettings.datasource
        accounts = datasource.getAllFinAccounts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: kAccountCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 71
    }
    
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
    
    // MARK: AccountsCellDelegate
    func accessoryTapped(_ sender: UIButton, inCell cell: UITableViewCell) {
        guard let row = tableView.indexPath(for: cell)?.row else { return }
        guard accounts.count > row else { return }
        let account = accounts[row]
        //let transactionsController = TransactionsViewController(withAccount: account)
        let transactionsController = TransactionsViewController()
        self.navigationController?.pushViewController(transactionsController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let c = segue.destination as! TransactionsViewController
        c.account = accounts[1]
        c.transactions = datasource.getFinTransactionsForAccount(withID: c.account!.accountID)
    }
    

}
