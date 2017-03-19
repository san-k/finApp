//
//  AppSettings.swift
//  finapp
//
//  Created by Admin on 14.01.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import UIKit // sshould be deleted
// i've added it just for fileprivate func image(from string: String, attributes: [String: Any], size: CGSize) -> UIImage?


class AppSettings {

    public static let sharedSettings:AppSettings = {
        let settings = AppSettings()
        return settings
    }()
    
    public func categoryImage(with name: String) -> UIImage? {
        return imagesDic[name]
    }
    
    public var datasource: AddEntity & UpdateEntity & GetEntityInfo & RemoveEntity & CalculateEntityInfo;
    public var defaultAccount: FinAccount?
    
    lazy fileprivate var imagesDic: [String : UIImage] = {
        var dic = [String : UIImage]()
        for a in 1...20 {
            dic["catewgoryImage-\(a)"] = AppSettings.makeImage(from: String(a))
        }
        return dic
    }()
    
    
    fileprivate init() {
        datasource = CDDataSourse()
    }
    
    static fileprivate func makeImage(from string: String) -> UIImage? {
        let attributes: [String: Any] = [NSFontAttributeName : UIFont(name: "HelveticaNeue", size: CGFloat(30.0))! ]
        let size = string.characters.count == 1 ? CGSize(width: 30.0, height: 30.0) : CGSize(width: 40.0, height: 40.0)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        string.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
