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
    @IBOutlet var commentButton: UIButton!

    @IBOutlet var scrollBottomConstraint: NSLayoutConstraint!
    var scrollBottomOffset: CGFloat {
        get {return scrollBottomConstraint.constant}
        set {scrollBottomConstraint.constant = newValue}
    }

    // money can be takken and it is default state
    // otherwise - money are put
    // after set new value - update UI
    fileprivate var transactionType: FinTransactionType = .TakeMoney
    fileprivate let validator = Validator()
    fileprivate var realSum = 0.0
    fileprivate var keyboardFrame: CGRect?
    
    // public properties
    public var selectedCategory: FinTransactionCategory?
    // it's kind of dangerous, but it should be optional, and be set from presenter
    public var selectedAccount: FinAccount?
    public var oldTransaction: FinTransaction? {
        didSet {
            selectedCategory = oldTransaction?.category
        }
    }
    public var transactionsVC: TransactionsViewController?

    
    // actions and private funcs
    @IBAction fileprivate func takeMoney(_ sender: UIButton) {
        transactionType = .TakeMoney
        updateUIWithTrType(animated: true)
    }
    
    
    @IBAction fileprivate func putMoney(_ sender: UIButton) {
        transactionType = .PutMoney
        updateUIWithTrType(animated: true)
    }
    
    @IBAction fileprivate func dateChanged(_ sender: UIDatePicker) {
        // it really has no sence. it's limited in storyboard
        // validator.validate(datePickerDate: datePicker.date, withID: datePicker.restorationIdentifier!)
    }
    
    @IBAction fileprivate func showCommentView(_ sender: UIButton) {
        commentView.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.commentButton.alpha = 0.0
            self.commentView.alpha = 1.0
        }, completion: { done in
            self.commentButton.isHidden = true
            self.commentView.becomeFirstResponder()
            
            var verticalOverlaping = CGFloat(0.0)
            if let keyboardFrame = self.keyboardFrame {
                let keyboardOriginInScroll = self.scrollView.convert(keyboardFrame.origin, from: self.view)
                verticalOverlaping = self.commentView.frame.origin.y + self.commentView.frame.size.height - keyboardOriginInScroll.y + 10
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: verticalOverlaping)
            })
        })
    }
    
    
    fileprivate func updateUIWithTrType(animated: Bool) {
        
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
        validator.add(validateItem: .textView(canBeEmpty: false), withID: commentView.restorationIdentifier!)
    }
    
    
    fileprivate func addBarButtons() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTapped(sender:)))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelTapped(sender:)))
        var doneOrUpdateButton: UIBarButtonItem! = nil
        var backButtons: [UIBarButtonItem]! = nil
        
        if oldTransaction == nil {
            doneOrUpdateButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneOrUpdateTapped(sender:)))
            backButtons = [backButton, cancelButton]
            
            // this is make no sence to add transaction, if we have fogotten to set account
            if selectedAccount == nil {
                doneOrUpdateButton.isEnabled = false
            }

        } else {
            doneOrUpdateButton = UIBarButtonItem(title: "UPDATE", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneOrUpdateTapped(sender:)))
            backButtons = [cancelButton]
        }
        
        navigationItem.setLeftBarButtonItems(backButtons, animated: false)
        navigationItem.setRightBarButton(doneOrUpdateButton, animated: false)
    }
    
    fileprivate func setupOldValues() {
        guard let oldTransaction = oldTransaction else { return }
        datePicker.date = oldTransaction.date
        sumField.text = String(oldTransaction.sum)
        // transaction category is alredy takken in oldTransaction didSet
        transactionType = oldTransaction.transactionType
        commentView.text = oldTransaction.comment
    }


    @objc fileprivate func backTapped(sender: UIBarButtonItem) {
        let _ = navigationController?.popViewController(animated: true)
    }

    @objc fileprivate func cancelTapped(sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func doneOrUpdateTapped(sender: UIBarButtonItem) {
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

            // selected account must be. otherwise doneOrUpdateButton wiil be disabled
            
            
            let newTransaction = FinTransaction(transactionType: transactionType, sum: realSum, category: selectedCategory, date: datePicker.date, comment: commentView.text ?? "")
            let datasource = AppSettings.sharedSettings.datasource
            
            if let oldTransaction = oldTransaction, !(oldTransaction.isEqualContents(to: newTransaction)) {
                // we should update old transaction if it is changed
                let _ = datasource.updatefinTransaction(withID: oldTransaction.transactionID, newTransaction: newTransaction)
            } else {
                // we should add new transaction
                let _ = datasource.add(finTransaction: newTransaction, toAccountWithID: selectedAccount!.accountID)
            }
            transactionsVC?.updateTransactionsInfo()

            navigationController?.dismiss(animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: nil, message: "Text validation error", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButtons()
        setupOldValues()
        setupValidator()

        // update UI which depends on set moneyMovement
        updateUIWithTrType(animated: false)
        
        // set name of selected category
        let title = selectedCategory?.name ?? "no selected category"
        categoriesButton.setTitle(title, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeKeyboardWillNotifications()
        sumField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopObserveKeyboardWillNotifications()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewTransactionViewController : KeyboardListener {
    func keyboardWillshow(absoluteFrame: CGRect, currentViewFrame: CGRect, duration: TimeInterval) {
        self.scrollBottomOffset = currentViewFrame.size.height
        self.view.layoutIfNeeded()
        
        keyboardFrame = currentViewFrame
    }
    
    func keyboardWillHide(duration: TimeInterval) {
        self.scrollBottomOffset = 0.0
        self.view.layoutIfNeeded()
        
        keyboardFrame = nil
    }
}

//MARK: - UIScrollViewDelegate

extension NewTransactionViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sumField.resignFirstResponder()
    }
}





