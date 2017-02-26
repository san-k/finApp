//
//  NewTransactionViewController.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 2/16/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class NewTransactionViewController: UIViewController {
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var datePicker: UIDatePicker! {
        didSet { datePicker.datePickerMode = .date }
    }
    @IBOutlet fileprivate weak var takeMoneyButton: UIButton!
    @IBOutlet weak var takeMoneyBackView: UIView!
    @IBOutlet fileprivate weak var putMoneyButton: UIButton!
    @IBOutlet weak var putMoneyBackView: UIView!
    @IBOutlet fileprivate weak var sumField: TunableTextField!
    @IBOutlet fileprivate weak var categoriesView: UIView!
    @IBOutlet fileprivate weak var categoriesButton: UIButton!
    @IBOutlet fileprivate weak var commentView: UITextView!
    @IBOutlet weak var rootView: UIView!
    
    // money can be takken and it is default state
    // otherwise - money are put
    // after set new value - update UI
    fileprivate var transactionType: FinTransactionType = .TakeMoney {
        didSet { updateUI(animated: true) }
    }
    fileprivate var transaction: FinTransaction?
    fileprivate let validator = Validator()
    fileprivate var realSum = 0.0
    
    // public properties
    public var selectedCategory: FinTransactionCategory?
    // it's kind of gangerous, but it should be optional, and be set from presenter
    // this one just as default (temporary)
    public var selectedAccount: FinAccount = (AppSettings.sharedSettings.datasource.getAllFinAccounts()?.first)!
    
    
    // actions and private funcs
    @IBAction fileprivate func takeMoney(_ sender: UIButton) {
        transactionType = .TakeMoney
    }
    
    
    @IBAction fileprivate func putMoney(_ sender: UIButton) {
        transactionType = .PutMoney
    }
    
    @IBAction fileprivate func dateChanged(_ sender: UIDatePicker) {
        // it really has no sence. it's limited in storyboard
        // validator.validate(datePickerDate: datePicker.date, withID: datePicker.restorationIdentifier!)
    }
    
    fileprivate func updateUI(animated: Bool) {
        
        var opacityChange = { }
        var completion: ((Bool) -> Void)!
        
        switch transactionType {
        case .TakeMoney:
            takeMoneyBackView.isHidden = false
            opacityChange = {
                self.takeMoneyBackView.alpha = 1.0
                self.putMoneyBackView.alpha = 0.0
            }
            completion =  { (_) in
                self.putMoneyBackView.isHidden = true
                self.rootView.backgroundColor = UIColor.brown }
            
        case .PutMoney:
            putMoneyBackView.isHidden = false
            opacityChange = {
                self.takeMoneyBackView.alpha = 0.0
                self.putMoneyBackView.alpha = 1.0
            }
            completion = { (_) in
                self.takeMoneyBackView.isHidden = true
                self.rootView.backgroundColor = UIColor.green
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: opacityChange, completion: completion)
        } else {
            opacityChange()
            completion(true)
        }
    }
    
    fileprivate func setupValidator() {
        validator.add(validateItem: .datePicker((minDate: datePicker.minimumDate!, maxDate: datePicker.maximumDate!)), withID: datePicker.restorationIdentifier!)
        validator.add(validateItem: .tunableTextField, withID: sumField.restorationIdentifier!)
        validator.add(validateItem: .textView(couldBeEmpty: false), withID: commentView.restorationIdentifier!)
    }
    
    
    fileprivate func addBarButtons() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTapped(sender:)))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelTapped(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneTapped(sender:)))
        navigationItem.setLeftBarButtonItems([backButton, cancelButton], animated: false)
        navigationItem.setRightBarButton(doneButton, animated: false)
    }

    @objc fileprivate func backTapped(sender: UIBarButtonItem) {
        let _ = navigationController?.popViewController(animated: true)
    }

    @objc fileprivate func cancelTapped(sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func doneTapped(sender: UIBarButtonItem) {
        // we really only need to validate tunable text field
        if !validator.validate(tunableField: sumField) {
            sumField.backgroundColor = UIColor.red
        }
        sumField.resignFirstResponder()
        
        if validator.isAllValidated {
            /* 1. add info to DB
             2. tell to acccount view condtroller, that DB was updated
             3. dismiss
             */
            
            let transaction = FinTransaction(transactionType: transactionType, sum: realSum, category: selectedCategory, date: datePicker.date, comment: commentView.text ?? "")
            
            let datasource = AppSettings.sharedSettings.datasource
            let _ = datasource.add(finTransaction: transaction, toAccountWithID: selectedAccount.accountID)
            
            navigationController?.dismiss(animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: nil, message: "Text validation error", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }

        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    // viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update UI which depends on set moneyMovement
        updateUI(animated: false)
        
        
        // set name of selected category
        let title = selectedCategory?.name ?? "no selected category"
        categoriesButton.setTitle(title, for: .normal)
     
        addBarButtons()
        
        
    }
}

extension NewTransactionViewController : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // for now we have onlyone text field on this page
        guard let tunableTextField = textField as? TunableTextField else { return }
        if !validator.validate(tunableField: tunableTextField) {
            tunableTextField.backgroundColor = UIColor.red
            realSum = 0.0
            return
        }
        realSum = Double(tunableTextField.text!) ?? 0.0
    }
}







