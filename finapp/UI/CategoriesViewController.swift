//
//  CategoriesViewController.swift
//  finapp
//
//  Created by Admin on 19.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    open var parentCategoryID: UUID?
    
    override func viewDidLoad() {
        setUpCell()
        addBarButtons()
        categories = datasorce.getAllSubCategories(forParentCatId: parentCategoryID)
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
        let leftButtons = parentCategoryID == nil ? [cancelButton] : [backButton, cancelButton]
        navigationItem.setLeftBarButtonItems(leftButtons, animated: false)
    }
    
    @objc fileprivate func backTapped(sender: UIBarButtonItem) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func cancelTapped(sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
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
            cell.categoryID = category.categoryID
            cell.categoryName = category.name
            cell.subcategoriesCount = datasorce.countSubCategories(forParentCatId: category.categoryID)
            return cell
        }
        return UITableViewCell()
    }

}

extension CategoriesViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let categories = categories, categories.count > indexPath.row {
            let category = categories[indexPath.row]
            let storyboard = UIStoryboard(name: "newTransactionUI", bundle: nil)
            guard let controller = storyboard.instantiateInitialViewController() as? NewTransactionViewController else { return }
            controller.selectedCategory = category
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension CategoriesViewController : CategoryCellDelegate {
    
    func showSubcategoriesTapped(on sender: UIButton, inCell cell: CategoryTableViewCell) {
        
        if let categoryID = cell.categoryID, cell.subcategoriesCount > 0 {
            let storyboard = UIStoryboard(name: "Categories", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            if let controller = controller as? CategoriesViewController {
                controller.parentCategoryID = categoryID
                self.navigationController?.pushViewController(controller, animated: true)
            }

        }
        
    }

}






