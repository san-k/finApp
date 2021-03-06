//
//  CategoryTableViewCell.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 2/17/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit


protocol CategoryCellDelegate : class {
    
    func showSubcategoriesTapped(on sender: UIButton, inCell cell:CategoryTableViewCell)

}


class CategoryTableViewCell: UITableViewCell {

    weak var delegate: CategoryCellDelegate?
    
    open var categoryImage: UIImage? {
        get {return categoryImagaView.image}
        set { categoryImagaView.image = newValue}
    }
    
    open var categoryName:String? {
        get {return name.text}
        set {name.text = newValue}
    }
    
    open var subcategoriesCount: Int32 {
        get {
            guard let stringNum = subCatCount.text, let intNum = Int32(stringNum) else {return 0}
            return intNum
        }
        set {
            if newValue == 0 {
                subCatLabel.text = "add sub cat"
                subCatCount.text = nil
            } else {
                subCatLabel.text = "sub cat"
                subCatCount.text = String(newValue)
            }
        }
    }
    
    public struct Locals {
        static let reuseIdentifier = "CategoryTableViewCell"
    }
    
    public func set(from category: FinTransactionCategory?) {
        if let category = category {
            name.text = category.name
            if let imageName = category.imageName {
                categoryImagaView.image = AppSettings.sharedSettings.categoryImage(with: imageName)
            } else {
                categoryImagaView.image = nil
            }
            subcategoriesCount = category.subcategoriesCount
            // subcategoriesCount = datasource.countSubCategories(forParentCatId: category.categoryID)
        } else  {
            name.text = nil
            categoryImagaView.image = nil
            subCatLabel.text = nil
            subCatCount.text = nil
        }
    }
    
    @IBOutlet fileprivate weak var categoryImagaView: UIImageView!
    @IBOutlet fileprivate weak var name: UILabel!
    @IBOutlet fileprivate weak var subCatCount: UILabel!
    @IBOutlet weak var subCatLabel: UILabel!
    
    @IBAction fileprivate func showSubcategories(_ sender: UIButton) {
        delegate?.showSubcategoriesTapped(on: sender, inCell: self)
    }
    
}
