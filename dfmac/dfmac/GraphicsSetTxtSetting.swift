//
//  GraphicsSetTxtSetting.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class GraphicsSetTxtSetting {
    let key: String
    let value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    func apply(txt: NSMutableString) {
        updateInitSetting(txt, key: key, value: value)
    }
    
    func isFontSetting() -> Bool {
        return key == "FONT" || key == "FULLFONT"
    }
}