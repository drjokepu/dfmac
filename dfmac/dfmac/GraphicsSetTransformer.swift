//
//  GraphicsSetTransformer.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class GraphicsSetTransformer: NSValueTransformer {
    override static func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override static func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let strValue = value as? String else {
            return 0
        }
        
        guard let mode = GraphicsSet(rawValue: strValue) else {
            return 0
        }
        
        return graphicsSetToIndex(mode)
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        switch value {
        case let intValue as Int:
            return indexToGraphicsSet(intValue).rawValue
        case let str as String:
            return str
        default:
            return DisplayMode.standard.rawValue
        }
    }
    
    private func indexToGraphicsSet(index: Int) -> GraphicsSet {
        switch index {
        case 1: return .gemSet
        default: return .none
        }
    }
    
    private func graphicsSetToIndex(mode: GraphicsSet) -> Int {
        switch mode {
        case .gemSet: return 1
        default: return 0
        }
    }
    
    static func register() {
        setValueTransformer(GraphicsSetTransformer(), forName: "GraphicsSetTransformer")
    }
}