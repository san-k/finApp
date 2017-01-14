//
//  AppSettings.swift
//  finapp
//
//  Created by Admin on 14.01.17.
//  Copyright © 2017 Oleksandr Kachanov. All rights reserved.
//

import Foundation


class AppSettings {

    static let sharedSettings:AppSettings = {
        let settings = AppSettings()
        return settings
    }()
    
    
    var datasource: AddEntity & UpdateEntity & GetEntityInfo & CalculateEntityInfo;
    
    
    private init() {
        datasource = CDDataSourse()
    }
    
}
