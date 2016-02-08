//
//  DFHackConfigEntry.swift
//  DF Mac
//
//  Created by Tamas Czinege on 07/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

class DFHackConfigEntry {
    let description: String
    
    var label: String {
        return "(no name)"
    }
    
    init(desc: String) {
        self.description = desc
    }
}