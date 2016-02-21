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
        case .afro:
            return NSImage(named: "afro_preview")
        case .cla:
            return NSImage(named: "cla_preview")
        case .duerer:
            return NSImage(named: "duerer_preview")
        case .gemSet:
            return NSImage(named: "gemset_preview")
        case .grimFortress:
            return NSImage(named: "grimfortress_preview")
        case .ironhand:
            return NSImage(named: "ironhand_preview")
        case .jollyBastion:
            return NSImage(named: "jolly_bastion_preview")
        case .mayday:
            return NSImage(named: "mayday_preview")
        case .obsidian:
            return NSImage(named: "obsidian_preview")
        case .phoebus:
            return NSImage(named: "phoebus_preview")
        case .shizzle:
            return NSImage(named: "shizzle_preview")
        case .spacefox:
            return NSImage(named: "spacefox_preview")
        case .taffer:
            return NSImage(named: "taffer_preview")
        case .tergel:
            return NSImage(named: "tergel_preview")
        case .wanderlust:
            return NSImage(named: "wanderlust_preview")
        default:
            return nil
        }
    }
    
    static func register() {
        setValueTransformer(GraphicsSetPreviewImageTransformer(), forName: "GraphicsSetPreviewImageTransformer")
    }
}