//
//  Preferences.swift
//  DF Mac
//
//  Created by Tamas Czinege on 04/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

private enum PreferencesKey: String {
    case displayMode = "displayMode"
    case fullScreen = "fullScreen"
    case showFPS = "showFPS"
    case playIntro = "playIntro"
    case windowedWidth = "windowedWidth"
    case windowedHeight = "windowedHeight"
    
    case enableDFHack = "enableDFHack"
    case tweaks = "tweaks"
}

final class Preferences {
    static var displayMode: DisplayMode {
        if let mode = DisplayMode(rawValue: stringForKey(.displayMode)) {
            return mode
        } else {
            return .standard
        }
    }
    
    static var fullScreen: Bool {
        return boolForKey(.fullScreen)
    }
    
    static var showFPS: Bool {
        return boolForKey(.showFPS)
    }
    
    static var playIntro: Bool {
        return boolForKey(.playIntro)
    }
    
    static var windowedWidth: Int {
        return intForKey(.windowedWidth)
    }
    
    static var windowedHeight: Int {
        return intForKey(.windowedHeight)
    }
    
    static var enableDFHack: Bool {
        return boolForKey(.enableDFHack)
    }
    
    static var tweaks: [String] {
        get {
            let val: [NSString] =  arrayForKey(.tweaks)
            return val as! [String]
        } set(value) {
            let val: [NSString] = value as [NSString]
            NSUserDefaults.standardUserDefaults().setObject(val, forKey: PreferencesKey.tweaks.rawValue)
        }
    }
    
    private static func boolForKey(key: PreferencesKey) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key.rawValue)
    }
    
    private static func intForKey(key: PreferencesKey) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(key.rawValue)
    }
    
    private static func stringForKey(key: PreferencesKey) -> String {
        if let str = NSUserDefaults.standardUserDefaults().stringForKey(key.rawValue) {
            return str
        } else {
            return ""
        }
    }
    
    private static func arrayForKey<T: AnyObject>(key: PreferencesKey) -> [T] {
        if let arr = NSUserDefaults.standardUserDefaults().arrayForKey(key.rawValue) as? [T] {
            return arr
        } else {
            return []
        }
    }
    
    static func registerDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.registerDefaults([
            PreferencesKey.displayMode.rawValue: DisplayMode.vbo.rawValue,
            PreferencesKey.fullScreen.rawValue: false,
            PreferencesKey.showFPS.rawValue: false,
            PreferencesKey.playIntro.rawValue: true,
            PreferencesKey.windowedWidth.rawValue: 80,
            PreferencesKey.windowedHeight.rawValue: 25,
            PreferencesKey.enableDFHack.rawValue: false,
            PreferencesKey.tweaks.rawValue: [
                "stable-cursor",
                "advmode-contained",
                "fast-trade",
                "military-stable-assign",
                "military-color-assigned",
                "craft-age-wear",
                "farm-plot-select",
                "import-priority-category",
                "block-labors",
                "civ-view-agreement",
                "fps-min",
                "hide-priority",
                "kitchen-keys",
                "kitchen-prefs-empty",
                "max-wheelbarrow",
                "shift-8-scroll",
                "title-start-rename"
            ]
        ])
    }
}