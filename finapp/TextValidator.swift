//
//  TextValidator.swift
//  finapp
//
//  Created by Admin on 05.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation


class TextValidator {
    
    private var textFieldsSet: Set<String>
    
    init(with set: Set<String>) {
        textFieldsSet = set
    }
    
    func validate(field: TunableTextField) -> Bool {
        var matched = false
        
        // check regExp
        if let regExp = try? NSRegularExpression(pattern: field.regexpPattern, options: []) {
            let text = field.text ?? ""
            let nsText = text as NSString
            let fullRange = NSMakeRange(0, nsText.length)
            let matchString = regExp.stringByReplacingMatches(in: text, options: [], range: fullRange, withTemplate: "")
            
            if matchString == "" {
                matched = true
            }
        }
        
        // work with text Field Set
        if matched {
            textFieldsSet.remove(field.valiadtorID)
        } else {
            let _ = textFieldsSet.insert(field.valiadtorID)
        }
        
        return matched
    }
    
    var isAllValidated: Bool { return textFieldsSet.isEmpty}
    
}
