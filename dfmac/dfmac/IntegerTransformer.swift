//
//  IntegerTransformer.swift
//  DF Mac
//
//  Created by Tamas Czinege on 05/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class IntegerTransformer: NSValueTransformer {
    override static func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override static func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let intValue = value as? Int else {
            return ""
        }
        
        return String(intValue)
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        switch value {
        case let intValue as Int:
            return intValue
        case let str as String:
            if let intValue = Int(str) {
                return intValue
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    static func register() {
        setValueTransformer(IntegerTransformer(), forName: "IntegerTransformer")
    }
}