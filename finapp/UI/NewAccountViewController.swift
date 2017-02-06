//
//  NewAccountViewController.swift
//  finapp
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

protocol NotificationObserver {

    func foo(name: (Notification.Name)?)
}

extension NotificationObserver where Self: AnyObject {
    
    func observe<StringEnum: RawRepresentable>(forNotification notification: StringEnum) where StringEnum.RawValue == String {
        let asd = notification
        print("notification = \(notification)")
        print("notification.rawValue = \(notification.rawValue)")
//        foo(name: (notification.rawValue).map {
//            NSNotification.Name(rawValue: $0)
//        })
        
        NotificationCenter.default.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    }
    
}

enum MyEnum {
    case First(String)
    case Second
}


//-(void)keyboardDidShow:(NSNotification*)notification
//{
//    if(self.isDescriptionEditing == NO)
//    return;
//    
//    NSDictionary *dic = notification.userInfo;
//    NSValue *keyboardFrame = dic[UIKeyboardFrameEndUserInfoKey];
//    CGRect frame = [keyboardFrame CGRectValue];
//    CGRect viewFrame = [self.view convertRect:frame fromView:nil];
//    CGFloat keyboardHeight = viewFrame.size.height;
//    
//    
//    
//    UITableViewCell *descCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//    CGFloat cellY = descCell.frame.origin.y;
//    
//    CGFloat descriptionBottom = cellY + self.descriptionTextView.frame.origin.y + self.descriptionTextView.bounds.size.height;
//    CGFloat keyboardTop = self.tableView.bounds.size.height - keyboardHeight;
//    CGFloat scrollOffset = descriptionBottom - keyboardTop;
//    if(scrollOffset >0)
//    {
//        [UIView animateWithDuration:0.4 animations:^{
//            self.tableView.contentOffset = CGPointMake(0, scrollOffset);
//            }];
//    }
//    
//}
//
//
//public func keyboardWillAppear(frame keyboardRect: CGRect, animationDuration: Double) -> Void {
//    guard let activeField = activeTextField else { return }
//    guard let fieldContainerView = activeField.superview else { return }
//    
//    let activeFrame = fieldContainerView.frame
//    let globalPoint: CGPoint = activeField.convert(CGPoint.zero, to: nil)
//    let verticalOverlaping = globalPoint.y + fieldContainerView.bounds.height + kOffsetAboveKeyboard - (UIScreen.main.bounds.height - keyboardRect.height)
//    
//    if verticalOverlaping > 0 {
//        UIView.animate(withDuration: animationDuration, animations: {
//            var frame: CGRect = self.view.frame
//            frame.origin.y -= verticalOverlaping
//            self.view.frame = frame
//        })
//    }


class NewAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NotificationObserver {

    @IBOutlet var nameText: UITextField!
    @IBOutlet var startSumText: UITextField!
    @IBOutlet var commentTextView: UITextView!

    @IBOutlet weak var currencyTable: UITableView!
    @IBOutlet weak var currencyLabel: UILabel!
    private var selectedCurrency: String?
    
    
    func foo(name: (Notification.Name)?) {
        let asd = name
        print("Notification.Name = \(asd)")
        
        let goodAsd: MyEnum = .First("asdasd")
        let badAsd: MyEnum = .Second
        
        let asd3: Optional<Int> = 4
        
        
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
        observe(forNotification: Notification.Name.NSCalendarDayChanged)
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
    
    @objc private func cancelTapped(sender: UIBarButtonSystemItem) {
        dismiss(animated: true) { 
            
        }
    }
    
    @objc private func doneTapped(sender: UIBarButtonSystemItem) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currencyTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
        self.tableView(currencyTable, didSelectRowAt: IndexPath(row: 0, section: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startSumText.becomeFirstResponder()
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
}


