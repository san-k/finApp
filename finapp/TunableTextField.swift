//
//  TunableTextField.swift
//  finapp
//
//  Created by Admin on 05.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class TunableTextField: UITextField {

    enum TextType: String {
        case NoValue = "NoValue"
        case Text = "Text"
        case IntegerNumber = "IntegerNumber"
        case FloatNumber = "FloatNumber"
    }
    
    enum CanBeEmpty: String {
        case NoValue = "NoValue"
        case Can = "Can"
        case Cant = "Cant"
    }

    @IBInspectable
    var valiadtorID: String = ""
    @IBInspectable
    var textTypeAdapter: String {
        get { return textType.rawValue }
        // It would be beter if it crashes when there is a wrong string in storyboard
        set { textType = TextType(rawValue: newValue)! }
    }
    var textType: TextType = TextType.NoValue
    @IBInspectable
    var CanBeEmptyAdapter: String {
        get { return canBeEmpty.rawValue }
        // It would be beter if it crashes when there is a wrong string in storyboard
        set { canBeEmpty = CanBeEmpty(rawValue: newValue)! }
    }
    var canBeEmpty: CanBeEmpty = CanBeEmpty.NoValue
    @IBInspectable
    var regexpPattern: String = "."

}
