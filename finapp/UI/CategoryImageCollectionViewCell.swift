//
//  CategoryImageCollectionViewCell.swift
//  finapp
//
//  Created by Admin on 12.03.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class CategoryImageCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var categoryImageView: UIImageView! {
        didSet {
            setupImageView()
        }
    }
    
    public var categoryImage: UIImage? {
        get { return categoryImageView.image }
        set { categoryImageView.image = newValue }
    }
    
    public func setCategoryImage(from text: String) {
        categoryImageView.image = AppSettings.sharedSettings.categoryImage(with: text)
    }
    
    fileprivate func setupImageView() {
        categoryImageView.contentMode = UIViewContentMode.center
        categoryImageView.backgroundColor = UIColor.yellow
        categoryImageView.layer.cornerRadius = 10.0
        categoryImageView.layer.borderColor = UIColor.black.cgColor
        categoryImageView.layer.borderWidth = 1.0
    }
    
}
