//
//  Currency.swift
//  finapp
//
//  Created by Oleksandr Kachanov on 1/7/17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation


func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        
        // I've found it on stackoverflow! For now it works perfectly fine.
        // http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type/32429125#32429125

        let next = withUnsafePointer(to: &i) {
            $0.withMemoryRebound(to: T.self, capacity: 1) {
                $0.pointee
            }
        }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

enum Currency : String {
    case GRN = "GRN"
    case USD = "USD"
    case EUR = "EUR"
    case ABC = "ABC"
}
