//
//  NewAccountViewController.swift
//  finapp
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit


class NewAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, KeyboardListener {

    @IBOutlet var nameText: UITextField!
    @IBOutlet var startSumText: UITextField!
    @IBOutlet var commentTextView: UITextView!

    @IBOutlet weak var currencyTable: UITableView!
    @IBOutlet weak var currencyLabel: UILabel!
    private var selectedCurrency: String?
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    var scrollBottomOffset: CGFloat {
        get {return scrollViewBottomConstraint.constant}
        set {scrollViewBottomConstraint.constant = newValue}
    }

    // PRIVATE PROPERTIES
    private var createdAccount: FinAccount?
    private let currencyArr: [String] = {
        var resArray = [String]()
        iterateEnum(Currency.self).forEach{resArray.append($0.rawValue)}
        return resArray
    }()
    
    override func viewDidLoad() {
        setupTable()
        addBarButtons()
    }
    
    private func setupTable() {
        currencyTable.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: CurrencyTableViewCell.staticIdentifier)
        currencyTable.rowHeight = UITableViewAutomaticDimension
        currencyTable.estimatedRowHeight = 71
    }
    
    private func addBarButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelTapped(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneTapped(sender:)))
        self.navigationItem.setLeftBarButton(cancelButton, animated: false)
        self.navigationItem.setRightBarButton(doneButton, animated: false)
    }
    
    
    // MARK: Bar buttons actions 
    
    @objc private func cancelTapped(sender: UIBarButtonSystemItem) {
        dismiss(animated: true) { 
            
        }
    }
    
    @objc private func doneTapped(sender: UIBarButtonSystemItem) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currencyTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
        self.tableView(currencyTable, didSelectRowAt: IndexPath(row: 0, section: 0))
        observeKeyboardWillNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopObserveKeyboardWillNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // startSumText.becomeFirstResponder()
    }
    
    //MARK: - textView delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    //MARK: - table view data source
    
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
            currencyLabel.text = "Currency \(selectedCurrency!)"
        } else {
            selectedCurrency = nil
            currencyLabel.text = "Currency"
        }
    }
    
    //MARK - KeyboardListener
    
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


