//
//  CategoryImageCollectionViewCell.swift
//  finapp
//
//  Created by Admin on 12.03.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class CategoryImageCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet fileprivate weak var categoryImageView: UIImageView! {
        didSet {
            setupImageView()
        }
    }
    
    public var categoryImageName: String? {
        didSet { setCategoryImage(from: categoryImageName) }
    }
    public var categoryImage: UIImage? {
        get { return categoryImageView.image }
    }
    
    
    fileprivate func setCategoryImage(from name: String?) {
        if let name = name {
            categoryImageView.image = AppSettings.sharedSettings.categoryImage(with: name)
        } else {
            categoryImageView.image = nil
        }
        
    }
    
    fileprivate func setupImageView() {
        categoryImageView.contentMode = UIViewContentMode.center
        categoryImageView.backgroundColor = UIColor.yellow
        categoryImageView.layer.cornerRadius = 10.0
        categoryImageView.layer.borderColor = UIColor.black.cgColor
        categoryImageView.layer.borderWidth = 1.0
    }
    
}
