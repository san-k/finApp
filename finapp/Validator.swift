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
    case simpleTextField((canBeEmpty: Bool, regExpPattern: String))
    case datePicker((minDate: Date, maxDate: Date))
    case textView(canBeEmpty: Bool)
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
        
        var isValid = false

        if date >= minDate && date <= maxDate {
            isValid = true
        }
        
        updateInvalidItems(for: strID, isValid: isValid)
        
        return isValid
    }
    
    func validate(textViewText text: String?, withID strID: String) -> Bool {
        
        guard let validateTextItem = validationDic[strID] else { return false}
        guard case let ValidatorItem.textView(canBeEmpty) = validateTextItem else { return false }
        
        let isValid = canBeEmpty || ((text != nil) && (text!.characters.count > 0))
        
        updateInvalidItems(for: strID, isValid: isValid)
        
        return isValid
    }
    
    func validate(simpleTextFieldText text:String?, withID strID:String) -> Bool {
        guard let validateTextItem = validationDic[strID] else { return false }
        guard case let ValidatorItem.simpleTextField(canBeEmpty, regExpPattern) = validateTextItem else { return false }
        
        // check emptiness
        var isValid = canBeEmpty || ((text != nil) && (text!.characters.count > 0))
        
        if isValid == true {
            isValid = check(text: text!, forPattern: regExpPattern)
        }
        
        return isValid
    }
    
    func validate(tunableField: TunableTextField) -> Bool {
        
        guard let strID = tunableField.restorationIdentifier else {return false}
        guard let validateItem = validationDic[strID] else {return false}
        guard case ValidatorItem.tunableTextField = validateItem else {return false}
        // here we know that for current tunable text field, ValidatorItem was added
        // even though it is not important for tunable TF, becourse it has all needed info inside
        
        // guard case let ValidatorItem.datePicker(midDate, maxDate) = validateItem else {return false}
        
        var isValid = false
        
        // check for emptiness
        if (tunableField.text == nil || tunableField.text == "") {
            switch tunableField.canBeEmpty {
            case .Can, .NoValue: isValid = true
            case .Cant: isValid = false
            }
        }
        // check regExp and here we can hardly unwrap text!
        else {
            isValid = check(text: tunableField.text!, forPattern: tunableField.regexpPattern)
        }

        updateInvalidItems(for: strID, isValid: isValid)
        
        return isValid
    }
    
    fileprivate func check(text: String, forPattern pattern: String) -> Bool {
        
        if let regExp = try? NSRegularExpression(pattern: pattern, options: []) {
            let text = text
            let nsText = text as NSString
            let fullRange = NSMakeRange(0, nsText.length)
            let matchString = regExp.stringByReplacingMatches(in: text, options: [], range: fullRange, withTemplate: "")
            
            if matchString == "" {
                return true
            }
        }
        return false
    }
    
    
    fileprivate func updateInvalidItems(for strID: String, isValid: Bool) {
    // work with invalid items Set
        if isValid {
            invalidItems.remove(strID)
        } else {
            let _ = invalidItems.insert(strID)
        }
        
    }
    
    var isAllValidated: Bool { return invalidItems.isEmpty}
    
}
