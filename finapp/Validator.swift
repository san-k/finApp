//
//  TextValidator.swift
//  finapp
//
//  Created by Admin on 05.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation



enum ValidatorItem {
    case tunableTextField
    case datePicker((minDate: Date, maxDate:Date))
    case textView(couldBeEmpty: Bool)
}


class Validator {
    
    fileprivate var validationDic = [String : ValidatorItem]()
    fileprivate var invalidItems = Set<String>()
    
    func add(validateItem: ValidatorItem, withID id: String) {
        validationDic[id] = validateItem
    }

    func remove(validateItem: ValidatorItem, withID id: String) {
        validationDic.removeValue(forKey: id)
    }

    
    func validate(datePickerDate date: Date, withID strID: String) -> Bool  {
        
        guard let validateDate = validationDic[strID] else {return false}
        guard case let ValidatorItem.datePicker(minDate, maxDate) = validateDate else {return false}
        
        var matched = false

        if date >= minDate && date <= maxDate {
            matched = true
        }
        
        updateInvalidItems(for: strID, isMatched: matched)
        
        return matched
    }
    
    func validate(textViewText text: String?, withID strID: String) -> Bool {
        
        guard let validateText = validationDic[strID] else { return false}
        guard case let ValidatorItem.textView(couldBeEmpty) = validateText else {return false}
        
        let matched = couldBeEmpty || (text != nil)
        
        updateInvalidItems(for: strID, isMatched: matched)
        
        return matched
    }
    
    func validate(tunableField: TunableTextField) -> Bool {
        
        guard let strID = tunableField.restorationIdentifier else {return false}
        guard let validateItem = validationDic[strID] else {return false}
        guard case ValidatorItem.tunableTextField = validateItem else {return false}
        // here we know that for current tunable text field, ValidatorItem was added
        // even though it is not important for tunable TF, becourse it has all needed info inside
        
        // guard case let ValidatorItem.datePicker(midDate, maxDate) = validateItem else {return false}
        
        var matched = false
        
        // check for emptiness :)
        if tunableField.text == "" {
            switch tunableField.canBeEmpty {
            case .Can, .NoValue: matched = true
            case .Cant: matched = false
            }
        }
        // check regExp and here we can hardly unwrap text!
        else if let regExp = try? NSRegularExpression(pattern: tunableField.regexpPattern, options: []) {
            let text = tunableField.text!
            let nsText = text as NSString
            let fullRange = NSMakeRange(0, nsText.length)
            let matchString = regExp.stringByReplacingMatches(in: text, options: [], range: fullRange, withTemplate: "")
            
            if matchString == "" {
                matched = true
            }
        }
        
        updateInvalidItems(for: strID, isMatched: matched)
        
        return matched
    }
    
    fileprivate func updateInvalidItems(for strID: String, isMatched: Bool) {
    // work with invalid items Set
        if isMatched {
            invalidItems.remove(strID)
        } else {
            let _ = invalidItems.insert(strID)
        }
        
    }
    
    var isAllValidated: Bool { return invalidItems.isEmpty}
    
}
