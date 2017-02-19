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

extension CategoriesViewController : CategoryCellDelegate {
    
    func showSubcategoriesTapped(on sender: UIButton, inCell cell: CategoryTableViewCell) {
        
        if let categoryID = cell.categoryID, cell.subcategoriesCount > 0 {
            let controller = CategoriesViewController()
            controller.parentCategoryID = categoryID
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }

}






