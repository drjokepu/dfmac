//
//  NoGraphicsSetSelectedTransformer.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class NoGraphicsSetSelectedTransformer: NSValueTransformer {
    private let negated: Bool
    
    init(negate: Bool) {
        self.negated = negate
        super.init()
    }
    
    override static func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let strValue = value as? String else {
            return negated ? 0 : 1
        }
        
        guard let mode = GraphicsSet(rawValue: strValue) else {
            return negated ? 0 : 1
        }

        return negated ? mode != .none : mode == .none
    }
    
    static func register() {
        setValueTransformer(NoGraphicsSetSelectedTransformer(negate: false), forName: "NoGraphicsSetSelectedTransformer")
        setValueTransformer(NoGraphicsSetSelectedTransformer(negate: true), forName: "GraphicsSetSelectedTransformer")
    }
}