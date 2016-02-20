//
//  Plugin.swift
//  DF Mac
//
//  Created by Tamas Czinege on 20/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

class DFHackPlugin: DFHackConfigEntry {
    let name: String
    
    override var label: String {
        return name
    }
    
    init(name: String, desc: String) {
        self.name = name
        super.init(desc: desc)
    }
}