//
//  AccountsViewController.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/24/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var datasource: AddEntity & UpdateEntity & GetEntityInfo & CalculateEntityInfo!
    var accounts: [FinAccount]!
    static let cellIdentifier = "cellIdentifier"
    
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
        // tableView.register(nil, forCellReuseIdentifier: AccountsViewController.cellIdentifier)
    }
    
    
    /*  little cache */
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell() // tableView.dequeueReusableCell(withIdentifier: AccountsViewController.cellIdentifier, for: indexPath)
        cell.textLabel?.text = accounts[indexPath.row].name
        return cell
    }

}
