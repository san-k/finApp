//
//  NewAccountViewController.swift
//  finapp
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit


class NewAccountViewController: UIViewController {

    @IBOutlet fileprivate weak var nameText: TunableTextField!
    @IBOutlet fileprivate weak var startSumText: TunableTextField!
    @IBOutlet fileprivate weak var commentTextView: UITextView!
    @IBOutlet fileprivate weak var currencyTable: UITableView!
    @IBOutlet fileprivate weak var currencyLabel: UILabel!
    @IBOutlet var validatingTextFields: [TunableTextField]!
    
    @IBOutlet fileprivate /*strong!*/ var currencyTableHeightConstraint: NSLayoutConstraint!
    var currencyTableHeight: CGFloat {
        get { return currencyTableHeightConstraint.constant}
        set { currencyTableHeightConstraint.constant = newValue}
    }
    
    @IBOutlet fileprivate /*strong!*/ var scrollViewBottomConstraint: NSLayoutConstraint!
    var scrollBottomOffset: CGFloat {
        get {return scrollViewBottomConstraint.constant}
        set {scrollViewBottomConstraint.constant = newValue}
    }
    
    public var accountsVC: AccountsViewController?
    public var oldAccount: FinAccount?
    

    // fileprivate PROPERTIES
    fileprivate var activeTextField: TunableTextField?
    fileprivate var selectedCurrency: String?
    fileprivate let currencyArr: [String] = {
        var resArray = [String]()
        iterateEnum(Currency.self).forEach{resArray.append($0.rawValue)}
        return resArray
    }()
    fileprivate var validator = Validator()
    
    struct MagicNumbers {
        static let currencyTableHeight: CGFloat = 100.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupValidator()
        setupButtonsAndValues()
    }
    
    fileprivate func setupButtonsAndValues() {
        addBarButtons()
        guard let account = oldAccount else { return }
        nameText.text = account.name
        startSumText.text = String(account.totalSum)
        startSumText.isEnabled = false
        commentTextView.text = account.comment
        currencyLabel.text = account.currency.rawValue
        
    }
    
    fileprivate func setupValidator() {
        for tf in validatingTextFields {
            if let id = tf.restorationIdentifier {
                validator.add(validateItem: ValidatorItem.tunableTextField, withID: id)
            }
        }
        
    }
    
    fileprivate func setupTable() {
        currencyTable.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: CurrencyTableViewCell.staticIdentifier)
        currencyTable.rowHeight = UITableViewAutomaticDimension
        currencyTable.estimatedRowHeight = 71
    }
    
    fileprivate func addBarButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelTapped(sender:)))
        
        var doneOrUpdateButton: UIBarButtonItem! = nil
        if oldAccount == nil {
            doneOrUpdateButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneOrUpdateTapped(sender:)))
        
        } else {
            doneOrUpdateButton = UIBarButtonItem(title: "Update", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneOrUpdateTapped(sender:)))
        }
        
        self.navigationItem.setRightBarButton(doneOrUpdateButton, animated: false)
        self.navigationItem.setLeftBarButton(cancelButton, animated: false)
    }
    
    
    // MARK: Bar buttons actions 
    
    @objc fileprivate func cancelTapped(sender: UIBarButtonItem) {
        activeTextField?.resignFirstResponder()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func doneOrUpdateTapped(sender: UIBarButtonItem) {
        // there can be a case when validation of TF was passsed, then user tried to modify
        // TF again, and without resigning first responder tapped on "done"
        validatingTextFields.forEach{ self.validateTextField($0)}
        
        if validator.isAllValidated {
            /* 1. add info to DB
               2. tell to acccount view condtroller, that DB was updated
               3. dismiss
             */
            
            let newAccount = FinAccount(name: nameText.text!,
                                        currency: Currency(rawValue: selectedCurrency!)!,
                                        comment: commentTextView.text,
                                        startSum: FinAccount.MoneySum(startSumText.text!)!)
            
            let datasource = AppSettings.sharedSettings.datasource
            if oldAccount == nil {
                let _ = datasource.add(finAccount: newAccount)
                accountsVC?.updateAccountsInfo()
            } else if !( newAccount.isEqualContents(to: oldAccount!) ) {
                let _ = datasource.updateFinAccount(withID: oldAccount!.accountID, newAccount: newAccount)
                accountsVC?.updateAccountsInfo()
            }
            
            navigationController?.dismiss(animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: nil, message: "Text validation error", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencyTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
        self.tableView(currencyTable, didSelectRowAt: IndexPath(row: 0, section: 0))
        startSumText.text = String(0.0)
        observeKeyboardWillNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserveKeyboardWillNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameText.becomeFirstResponder()
    }
    
    @IBAction func toggleCurrencyAppearace(_ sender: UIButton) {
        currencyTableHeight =  currencyTableHeight == 0.0 ? MagicNumbers.currencyTableHeight : 0.0
    }
}

    //MARK: - textView delegate
    
extension NewAccountViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.clear
        activeTextField = textField as? TunableTextField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextField(activeTextField)
        activeTextField = nil
    }
    
    fileprivate func validateTextField(_ textField: TunableTextField?) {
        guard let textField = textField else { return }
        if !validator.validate(tunableField: textField) {
            textField.backgroundColor = UIColor.red
        }
    }
}


    //MARK: - table view data source

extension NewAccountViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.staticIdentifier, for: indexPath) as! CurrencyTableViewCell
        if currencyArr.count > indexPath.row {
            cell.name.text = currencyArr[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currencyArr.count > indexPath.row {
            selectedCurrency = currencyArr[indexPath.row]
            currencyLabel.text = "Currency: \(selectedCurrency!)"
        } else {
            selectedCurrency = nil
            currencyLabel.text = "Currency"
        }
        currencyTable.deselectRow(at: indexPath, animated: true)
        
    }
}

    //MARK: - UIScrollViewDelegate

extension NewAccountViewController : UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activeTextField?.resignFirstResponder()
    }
}


    //MARK: - KeyboardListener

extension NewAccountViewController : KeyboardListener {
    func keyboardWillshow(absoluteFrame: CGRect, currentViewFrame: CGRect, duration: TimeInterval) {
       print(duration)
        UIView.animate(withDuration: duration) {
            self.scrollBottomOffset = currentViewFrame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { 
            self.scrollBottomOffset = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
}


