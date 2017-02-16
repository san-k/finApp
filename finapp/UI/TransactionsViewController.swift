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
    var account: FinAccount?
    var transactions: [FinTransaction]?
    
    
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
    
    convenience init(withAccount account: FinAccount) {
        self.init()
        self.account = account
        transactions = datasource.getFinTransactionsForAccount(withID: account.accountID)
    }
    
    fileprivate func setup() {
        datasource = AppSettings.sharedSettings.datasource
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: kTransactionCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99
        
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
            transactionCell.sum.text = String(finTransaction.sum)
            
            let formatter = DateFormatter()
//            formatter.dateFormat = "dd.mm.yyyy"
            formatter.locale = Locale(identifier: "en_US")
            formatter.setLocalizedDateFormatFromTemplate("dd.mm.yyyy")
            transactionCell.date.text = formatter.string(from: finTransaction.date)
        }
        
        return transactionCell
    }
}
