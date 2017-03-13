//
//  CategoryImagesViewController.swift
//  finapp
//
//  Created by Admin on 11.03.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class CategoryImagesController : NSObject {

    public var collectionView: UICollectionView
    
    // typealias DidSelectHandler =
    public var didSelectHandler: (String?) -> Void
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.didSelectHandler = { string in }
        super.init()
        setup()
    }
    
    fileprivate func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CategoryImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryImageCollectionViewCell")
    
//        tableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: kAccountCellIdentifier)
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 71
    }
}


extension CategoryImagesController : UICollectionViewDataSource {

    static let countOfHardcodedImages = 20
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryImagesController.countOfHardcodedImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryImageCollectionViewCell", for: indexPath)
        if let cell = cell as? CategoryImageCollectionViewCell {
            cell.categoryImageName = "catewgoryImage-\(indexPath.row + 1)" // this is just magic, according to caterogy images naming
        }
        return cell
    }
}

extension CategoryImagesController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryImageCollectionViewCell {
            didSelectHandler(cell.categoryImageName)
        }
    }
}
