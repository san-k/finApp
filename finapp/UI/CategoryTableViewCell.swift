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
    
    open var categoryID: UUID?
    
    open var categoryImage: UIImage? {
        get {return categoryImagaView.image}
        set { categoryImagaView.image = newValue}
    }
    
    open var categoryName:String? {
        get {return name.text}
        set {name.text = newValue}
    }
    
    open var subcategoriesCount:Int {
        get {
            guard let stringNum = subCatCount.text, let intNum = Int(stringNum) else {return 0}
            return intNum
        }
        set {subCatCount.text = String(newValue)}
    }
    
    public struct Locals {
        static let reuseIdentifier = "CategoryTableViewCell"
    }
    
    @IBOutlet fileprivate weak var categoryImagaView: UIImageView!
    @IBOutlet fileprivate weak var name: UILabel!
    @IBOutlet fileprivate weak var subCatCount: UILabel!
    
    @IBAction fileprivate func showSubcategories(_ sender: UIButton) {
        delegate?.showSubcategoriesTapped(on: sender, inCell: self)
    }
    
}
