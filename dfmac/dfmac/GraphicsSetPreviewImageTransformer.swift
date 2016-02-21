//
//  GraphicsSetPreviewImageTransformer.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Cocoa

final class GraphicsSetPreviewImageTransformer: NSValueTransformer {
    override static func transformedValueClass() -> AnyClass {
        return NSImage.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let strValue = value as? String else {
            return nil
        }
        
        guard let mode = GraphicsSet(rawValue: strValue) else {
            return nil
        }
        
        return graphicsSetToImage(mode)
    }
    
    private func graphicsSetToImage(mode: GraphicsSet) -> NSImage? {
        switch mode {
        case .cla:
            return NSImage(named: "cla_preview")
        case .gemSet:
            return NSImage(named: "gemset_preview")
        default:
            return nil
        }
    }
    
    static func register() {
        setValueTransformer(GraphicsSetPreviewImageTransformer(), forName: "GraphicsSetPreviewImageTransformer")
    }
}