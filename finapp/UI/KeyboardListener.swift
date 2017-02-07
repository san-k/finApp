//
//  KeyboardListener.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 2/6/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import UIKit

@objc protocol KeyboardListener: NotificationObserver {
    func keyboardWillhow(withRect rect: CGRect)
    //    func keyboardDidShow(withRect rect: CGRect)
    //    func keyboardDidShow(withRect rect: CGRect)
    //    func keyboardDidShow(withRect rect: CGRect)
}

extension KeyboardListener where Self: UIViewController {
    
    func observeKeyboardWillNotifications() {

        observeFromAll(notification: Notification.Name.UIKeyboardWillShow) { [weakSelf = self] (notification) in
            let keyboardRect = CGRect()
            weakSelf.keyboardWillhow(withRect: keyboardRect)
        }
    }
 
    
    
    
}

@objc protocol NotificationObserver {}

extension NotificationObserver where Self : UIViewController {
    
    typealias NotificationClosure = (Notification) -> Void
    
    func observeFromAll(notification: Notification.Name, selector: Selector) {
        observe(notification: notification, selector: selector, fromPoster: nil)
    }

    func observeFromAll(notification: Notification.Name, using closure: @escaping NotificationClosure) {
        observe(notification: notification, fromPoster: nil, using: closure)
    }
    
    func observe(notification: Notification.Name, selector: Selector, fromPoster poster: Any?) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: poster)
    }

    func observe(notification: Notification.Name, fromPoster poster: Any?, using closure: @escaping NotificationClosure) {
        NotificationCenter.default.addObserver(forName: notification, object: poster, queue: nil, using: closure)
    }
    
    func stopObserveFromAll(notification: Notification.Name) {
        stopObserve(notification: notification, fromPoster: nil)
    }
    
    func stopObserve(notification: Notification.Name, fromPoster poster: Any?) {
        NotificationCenter.default.removeObserver(self, name: notification, object: poster)
    }
    
    func stopObserveAll() {
        NotificationCenter.default.removeObserver(self)
    }
}
