//
//  NewCategoryViewController.swift
//  finapp
//
//  Created by Admin on 05.03.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {

    
    fileprivate enum ContentViewMode {
        case none
        case imageCollectionView
        case commentView
    }
    
    fileprivate struct Sizes {
        static let switcherContentHeightConstant = CGFloat(300.0)
    }
  
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var contentView: UIView!
    @IBOutlet fileprivate weak var parrentLabel: UILabel!
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    
    @IBOutlet fileprivate weak var imageButtonBack: UIView!
    @IBOutlet fileprivate weak var imageButton: UIButton!
    @IBOutlet fileprivate weak var commentButtonBack: UIView!
    @IBOutlet fileprivate weak var commentButton: UIButton!
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    @IBOutlet fileprivate weak var switcherContentView: UIView!
    @IBOutlet fileprivate weak var switcherContentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var scrollBottomConstraint: NSLayoutConstraint!
    
    fileprivate var validator = Validator()
    fileprivate var contentViewMode = ContentViewMode.none
    fileprivate var imagesCollectionController: CategoryImagesController?
    lazy fileprivate var imagesCollectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4.0
        layout.minimumInteritemSpacing = 4.0
        layout.sectionInset = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.imagesCollectionController = CategoryImagesController(collectionView: view)
        self.imagesCollectionController!.didSelectHandler = {
            self.selectedCategoryImage = ( $0 == nil ? nil : AppSettings.sharedSettings.categoryImage(with: $0!) )
        }
        self.addToSwitcherContentView(view: view)
        return view
    }()
    
    lazy fileprivate var commentTextView: UITextView = {
        let view = UITextView()
        self.addToSwitcherContentView(view: view)
        return view
    }()
    
    fileprivate func addToSwitcherContentView(view: UIView) {
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10.0
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false

        self.switcherContentView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: self.switcherContentView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.switcherContentView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.switcherContentView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.switcherContentView.bottomAnchor).isActive = true
        view.isHidden = true
    }
    
    fileprivate var selectedCategoryImage: UIImage? {
        get { return selectedCategoryImageView.image }
        set { selectedCategoryImageView.image = newValue }
    }
    
    fileprivate var switcherContentHeight: CGFloat {
        get { return switcherContentHeightConstraint.constant }
        set {
            switcherContentHeightConstraint.constant = newValue
            switcherContentView.superview?.layoutIfNeeded()
        }
    }
    
    fileprivate var parrentName: String? {
        get { return parrentLabel.text }
        set { parrentLabel.text = newValue }
    }
    
    fileprivate var scrollBottomOffset: CGFloat {
        get { return scrollBottomConstraint.constant }
        set { scrollBottomConstraint.constant = newValue }
    }
    
    @IBAction func imageTapped(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        if contentViewMode != .imageCollectionView {
            showImageCollectionView()
        } else {
            switcherContentHeight = 0.0
            imagesCollectionView.isHidden = true
            imageButton.setTitle("Image", for: UIControlState.normal)
            contentViewMode = .none
        }
        
    }

    @IBAction func commentTapped(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        if contentViewMode != .commentView {
            showCommentView()
        } else {
            switcherContentHeight = 0.0
            commentTextView.isHidden = true
            commentButton.setTitle("Comment", for: UIControlState.normal)
            contentViewMode = .none
        }
        
    }
    
    fileprivate func showCommentView() {
        if contentViewMode == .imageCollectionView {
            imagesCollectionView.isHidden = true
            imageButton.setTitle("Image", for: UIControlState.normal)
        }
        if contentViewMode == .none {
            switcherContentHeight = Sizes.switcherContentHeightConstant
        }
        contentViewMode = .commentView
        commentTextView.isHidden = false
        commentButton.setTitle("Hide", for: UIControlState.normal)
    }
    
    fileprivate func showImageCollectionView() {
        if contentViewMode == .commentView {
            commentTextView.isHidden = true
            commentButton.setTitle("Comment", for: UIControlState.normal)
        }
        if contentViewMode == .none {
            switcherContentHeight = Sizes.switcherContentHeightConstant
        }
        contentViewMode = .imageCollectionView
        imagesCollectionView.isHidden = false
        imageButton.setTitle("Hide", for: UIControlState.normal)
    }
    
    fileprivate func addBarButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelTapped(sender:)))
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneTapped(sender:)))
        
        navigationItem.setLeftBarButton(cancelButton, animated: false)
        navigationItem.setRightBarButton(doneButton, animated: false)
    }
    
    @objc fileprivate func cancelTapped(sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func doneTapped(sender: UIBarButtonItem) {
    
    }
    
    fileprivate func setupValidator() {
        validator.add(validateItem: ValidatorItem.simpleTextField((canBeEmpty: false, regExpPattern: "[A-Za-z ]{3,}")), withID: nameTextField.restorationIdentifier!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        setupValidator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeKeyboardWillNotifications()
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserveKeyboardWillNotifications()
    }
}

extension NewCategoryViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !validator.validate(simpleTextFieldText: textField.text, withID: textField.restorationIdentifier!) {
            textField.backgroundColor = UIColor.red
        }
    }
}

extension NewCategoryViewController : KeyboardListener {
    func keyboardWillshow(absoluteFrame: CGRect, currentViewFrame: CGRect, duration: TimeInterval) {
        self.scrollBottomOffset = currentViewFrame.size.height
        self.view.layoutIfNeeded()
    }
    
    func keyboardWillHide(duration: TimeInterval) {
        self.scrollBottomOffset = 0.0
        self.view.layoutIfNeeded()
    }
}

