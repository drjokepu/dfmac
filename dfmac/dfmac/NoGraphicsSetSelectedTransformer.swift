//
//  NoGraphicsSetSelectedTransformer.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class NoGraphicsSetSelectedTransformer: NSValueTransformer {
    override static func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let strValue = value as? String else {
            return 1
        }
        
        guard let mode = GraphicsSet(rawValue: strValue) else {
            return 1
        }

        return mode == .none
    }
    
    static func register() {
        setValueTransformer(NoGraphicsSetSelectedTransformer(), forName: "NoGraphicsSetSelectedTransformer")
    }
}