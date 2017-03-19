//
//  CategoriesViewController.swift
//  finapp
//
//  Created by Admin on 19.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    public var parentCategory: FinTransactionCategory?
    public var account: FinAccount?
    public var transactionsVC: TransactionsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCell()
        addBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCategoriesInfo()
    }
    
    public func updateCategoriesInfo()
    {
        categories = datasource.getAllSubCategories(forParentCatId: parentCategory?.categoryID)
        categoriesTableView.reloadData()
    }

    fileprivate let datasource = AppSettings.sharedSettings.datasource
    fileprivate var categories: [FinTransactionCategory]! {
        didSet { categories = categories ?? [] }
    }
    
    @IBOutlet fileprivate weak var categoriesTableView: UITableView!
    
    fileprivate func setUpCell() {
        categoriesTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.Locals.reuseIdentifier)
        categoriesTableView.rowHeight = UITableViewAutomaticDimension
        categoriesTableView.estimatedRowHeight = 71
    }
    
    fileprivate func addBarButtons() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTapped(sender:)))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelTapped(sender:)))
        let leftButtons = parentCategory == nil ? [cancelButton] : [backButton, cancelButton]
        
        let addCatButton = UIBarButtonItem(title: "addCat", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addCategoryTapped(sender:)))
        
        navigationItem.setLeftBarButtonItems(leftButtons, animated: false)
        navigationItem.setRightBarButton(addCatButton, animated: false)
    }
    
    @objc fileprivate func backTapped(sender: UIBarButtonItem) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func cancelTapped(sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func addCategoryTapped(sender: UIBarButtonItem) {
        showNewCategoryController(forParrent: parentCategory)
    }

    fileprivate func showNewCategoryController(forParrent parrentCategory: FinTransactionCategory?, update oldCategory: FinTransactionCategory? = nil) {
        let newCatStoryBoard = UIStoryboard(name: "newCategory", bundle: nil)
        guard let newCatController = newCatStoryBoard.instantiateInitialViewController() as? NewCategoryViewController else {return}
        newCatController.parentCategory = parrentCategory
        newCatController.categoryToUpdate = oldCategory
        newCatController.categoriesVC = self
        let navController = UINavigationController(rootViewController: newCatController)
        navigationController?.present(navController, animated: true, completion: nil)
        
    }
}


extension CategoriesViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.Locals.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if categories.count > indexPath.row {
            cell.delegate = self
            cell.set(from: categories[indexPath.row])
        } else  {
            cell.delegate = nil
            cell.set(from: nil)
        }
        return cell
    }

}

extension CategoriesViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if categories.count > indexPath.row {
            let category = categories[indexPath.row]
            let storyboard = UIStoryboard(name: "newTransactionUI", bundle: nil)
            guard let controller = storyboard.instantiateInitialViewController() as? NewTransactionViewController else { return }
            controller.selectedCategory = category
            controller.selectedAccount = account
            controller.transactionsVC = transactionsVC
            navigationController?.pushViewController(controller, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func longPress(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            let point = longPress.location(in: categoriesTableView)
            guard let indexPath = categoriesTableView.indexPathForRow(at: point) else { return }
            guard categories.count > indexPath.row else { return }
            let category = categories[indexPath.row]
            showNewCategoryController(forParrent: parentCategory, update: category)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard categories.count > indexPath.row else { return }
            if datasource.removeCategory(withID: categories[indexPath.row].categoryID) {
                categories.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
}

extension CategoriesViewController : CategoryCellDelegate {
    
    func showSubcategoriesTapped(on sender: UIButton, inCell cell: CategoryTableViewCell) {
        guard let indexPath = categoriesTableView.indexPath(for: cell) else { return }
        let row = indexPath.row
        guard categories.count > row else { return }
        let selectedCategory = categories[row]
        
        if cell.subcategoriesCount > 0 {
            // show categories controller with subcategories
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            if let controller = controller as? CategoriesViewController {
                controller.parentCategory = selectedCategory
                // pass account through categories controller for newTransaction cantroller
                controller.account = account
                controller.transactionsVC = transactionsVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            // show new category controller to add category to selected category
            showNewCategoryController(forParrent: selectedCategory)
        }
    }
}






