//
//  KeyboardListener.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 2/6/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardListener : NotificationObserver{
    
//    func keyboardDidShow(withRect rect: CGRect)
//    func keyboardWillhow(withRect rect: CGRect)
//    func keyboardDidShow(withRect rect: CGRect)
//    func keyboardDidShow(withRect rect: CGRect)
}

extension KeyboardListener {

    
    
}


protocol NotificationObserver {}

extension NotificationObserver where Self: AnyObject {
    
    func observe(notification: Notification.Name, selector: Selector, fromPoster poster: Any?) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: poster)
    }
    
    func stopObserve(notification: Notification.Name, fromPoster poster: Any?) {
        NotificationCenter.default.removeObserver(self, name: notification, object: poster)
    }
    
    func stopObserveAll() {
        NotificationCenter.default.removeObserver(self)
    }
}
