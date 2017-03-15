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
        setUpCell()
        addBarButtons()
        categories = datasorce.getAllSubCategories(forParentCatId: parentCategory?.categoryID)
    }
    
    fileprivate let datasorce = AppSettings.sharedSettings.datasource
    fileprivate var categories: [FinTransactionCategory]?
    
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
        addSubCategoryTapped(for: parentCategory)
    }

    fileprivate func addSubCategoryTapped(for parrentCategory: FinTransactionCategory?) {
        let newCatStoryBoard = UIStoryboard(name: "newCategory", bundle: nil)
        guard let newCatController = newCatStoryBoard.instantiateInitialViewController() as? NewCategoryViewController else {return}
        newCatController.parentCategory = parrentCategory
        let navController = UINavigationController(rootViewController: newCatController)
        navigationController?.present(navController, animated: true, completion: nil)
        
    }
}


extension CategoriesViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories == nil ? 0 : categories!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.Locals.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        if let categories = categories, categories.count > indexPath.row {
            let category = categories[indexPath.row]
            cell.delegate = self
            cell.categoryName = category.name
            cell.subcategoriesCount = datasorce.countSubCategories(forParentCatId: category.categoryID)
            return cell
        }
        return UITableViewCell()
    }

}

extension CategoriesViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let categories = categories, categories.count > indexPath.row {
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
    
}

extension CategoriesViewController : CategoryCellDelegate {
    
    func showSubcategoriesTapped(on sender: UIButton, inCell cell: CategoryTableViewCell) {
        guard let indexPath = categoriesTableView.indexPath(for: cell) else { return }
        let row = indexPath.row
        guard let categories = categories, categories.count > row else { return }
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
            addSubCategoryTapped(for: selectedCategory)
        }
    }
}






