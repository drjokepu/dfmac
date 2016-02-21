//
//  DisplayModeTransformer.swift
//  DF Mac
//
//  Created by Tamas Czinege on 05/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class DisplayModeTransformer: NSValueTransformer {
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
        
        guard let mode = DisplayMode(rawValue: strValue) else {
            return 0
        }
        
        return displayModeToIndex(mode)
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        switch value {
        case let intValue as Int:
            return indexToDisplayMode(intValue).rawValue
        case let str as String:
            return str
        default:
            return DisplayMode.standard.rawValue
        }
    }
    
    private func indexToDisplayMode(index: Int) -> DisplayMode {
        switch index {
        case 1: return .text
        case 2: return .frameBuffer
        case 3: return .twbt
        case 4: return .twbtLegacy
        case 5: return .vbo
        default: return .standard
        }
    }
    
    private func displayModeToIndex(mode: DisplayMode) -> Int {
        switch mode {
        case .text: return 1
        case .frameBuffer: return 2
        case .twbt: return 3
        case .twbtLegacy: return 4
        case .vbo: return 5
        default: return 0
        }
    }
    
    static func register() {
        setValueTransformer(DisplayModeTransformer(), forName: "DisplayModeTransformer")
    }
}