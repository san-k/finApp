//
//  AccountsViewController.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/24/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

let kAccountCellIdentifier = "accountCellIdentifier"

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var datasource: AddEntity & UpdateEntity & GetEntityInfo & CalculateEntityInfo!
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
    
    
    /*  little cache */
  
    
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
        cell.accountName.text = accounts[indexPath.row].name
        cell.accountSum.text = String(accounts[indexPath.row].totalSum)
        
        return cell
    }

}
