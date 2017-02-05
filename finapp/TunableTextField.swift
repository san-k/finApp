//
//  TunableTextField.swift
//  finapp
//
//  Created by Admin on 05.02.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import UIKit

class TunableTextField: UITextField {

    enum TextType {
        case NoValue
        case Text
        case IntegerNumber
        case FloatNumber
    }
    
    enum CanBeEmpty {
        case NoValue
        case Can
        case Cant
    }
    
    var textType = TextType.NoValue
    var canBeEmpty = CanBeEmpty.NoValue

}
