//
//  KeyboardListener.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 2/6/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardListener: NotificationObserver {
    func keyboardWillshow(absoluteFrame: CGRect, currentViewFrame: CGRect, duration: TimeInterval)
    func keyboardWillHide(duration: TimeInterval)
}

extension KeyboardListener where Self: UIViewController {
    
    func observeKeyboardWillNotifications() {

        observeFromAll(notification: Notification.Name.UIKeyboardWillShow) { [weak weakSelf = self] (notification) in
            guard let userDictionary = notification.userInfo else { return }
            guard let frameValue = userDictionary[UIKeyboardFrameEndUserInfoKey] as? NSValue else{ return }
            guard let duration = userDictionary[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            let absoluteFrame = frameValue.cgRectValue
            let currentViewFrame = self.view.convert(absoluteFrame, from: nil)
            
            if let strongSelf = weakSelf {
                strongSelf.keyboardWillshow(absoluteFrame: absoluteFrame, currentViewFrame: currentViewFrame, duration: duration)
            }
            
        }
        
        observeFromAll(notification: Notification.Name.UIKeyboardWillHide) { [weak weakSelf = self] (notification) in
            guard let userDictionary = notification.userInfo else { return }
            guard let duration = userDictionary[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            
            if let strongSelf = weakSelf {
                strongSelf.keyboardWillHide(duration: duration)
            }

        }
        
        func stopObserveKeyboardWillNotifications() {
            stopObserveFromAll(NotificationArr: [Notification.Name.UIKeyboardWillShow, Notification.Name.UIKeyboardWillHide])
        }
    }
}

@objc protocol NotificationObserver {}

extension NotificationObserver {
    
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
    
    func stopObserveFromAll(NotificationArr arr: [Notification.Name]) {
        arr.forEach{ stopObserveFromAll(notification: $0) }
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
