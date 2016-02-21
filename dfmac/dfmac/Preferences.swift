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
    
    case autoSave = "autoSave"
    case autoBackup = "autoBackup"
    case initialSave = "initialSave"
    case pauseOnSave = "pauseOnSave"
    case pauseOnLoad = "pauseOnLoad"
    
    case populationCap = "populationCap"
    case childCap = "childCap"
    case adultChildRatio = "adultChildRatio"
    case visitorCap = "visitorCap"
    case temperature = "temperature"
    case weather = "weather"
    case caveIns = "caveIns"
    case invasions = "invasions"
    case invasionSoldierCap = "invasionSoldierCap"
    case invasionMonsterCap = "invasionMonsterCap"
    case artifacts = "artifacts"
    case grazeCoefficient = "grazeCoefficient"
    
    case enableDFHack = "enableDFHack"
    case plugins = "plugins"
    case tweaks = "tweaks"
}

final class Preferences {
    // display
    static var displayMode: DisplayMode {
        get {
            if let mode = DisplayMode(rawValue: stringForKey(.displayMode)) {
                return mode
            } else {
                return .standard
            }
        }
        set (value) {
            NSUserDefaults.standardUserDefaults().setObject(value.rawValue, forKey: PreferencesKey.displayMode.rawValue)
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
    
    
    // saving
    static var autoSave: AutoSaveMode {
        get {
            if let mode = AutoSaveMode(rawValue: stringForKey(.autoSave)) {
                return mode
            } else {
                return .none
            }
        }
        set(value) {
            if value == .none {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(PreferencesKey.autoSave.rawValue)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(value.rawValue, forKey: PreferencesKey.autoSave.rawValue)
            }
        }
    }
    
    static var autoBackup: Bool {
        return boolForKey(.autoBackup)
    }
    
    static var initialSave: Bool {
        return boolForKey(.initialSave)
    }
    
    static var pauseOnSave: Bool {
        return boolForKey(.pauseOnSave)
    }
    
    static var pauseOnLoad: Bool {
        return boolForKey(.pauseOnLoad)
    }
    
    // gameplay
    static var populationCap: Int {
        return intForKey(.populationCap)
    }
    
    static var childCap: Int {
        return intForKey(.childCap)
    }
    
    static var adultChildRatio: Int {
        return intForKey(.adultChildRatio)
    }
    
    static var visitorCap: Int {
        return intForKey(.visitorCap)
    }
    
    static var temperature: Bool {
        return boolForKey(.temperature)
    }
    
    static var weather: Bool {
        return boolForKey(.weather)
    }
    
    static var caveIns: Bool {
        return boolForKey(.caveIns)
    }
    
    static var invasions: Bool {
        return boolForKey(.invasions)
    }
    
    static var invasionSoldierCap: Int {
        return intForKey(.invasionSoldierCap)
    }
    
    static var invasionMonsterCap: Int {
        return intForKey(.invasionMonsterCap)
    }
    
    static var artifacts: Bool {
        return boolForKey(.artifacts)
    }
    
    static var grazeCoefficient: Int {
        return intForKey(.grazeCoefficient)
    }
    
    // dfhack
    static var enableDFHack: Bool {
        return boolForKey(.enableDFHack)
    }
    
    static var plugins: [String] {
        get {
            let val: [NSString] =  arrayForKey(.plugins)
            return val as! [String]
        } set(value) {
            let val: [NSString] = value as [NSString]
            NSUserDefaults.standardUserDefaults().setObject(val, forKey: PreferencesKey.plugins.rawValue)
        }
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
            PreferencesKey.displayMode.rawValue: DisplayMode.twbt.rawValue,
            PreferencesKey.fullScreen.rawValue: false,
            PreferencesKey.showFPS.rawValue: false,
            PreferencesKey.playIntro.rawValue: false,
            PreferencesKey.windowedWidth.rawValue: 1200,
            PreferencesKey.windowedHeight.rawValue: 675,
            
            PreferencesKey.autoSave.rawValue: AutoSaveMode.none.rawValue,
            PreferencesKey.autoBackup.rawValue: false,
            PreferencesKey.initialSave.rawValue: false,
            PreferencesKey.pauseOnLoad.rawValue: true,
            PreferencesKey.pauseOnSave.rawValue: false,
            
            PreferencesKey.populationCap.rawValue: 200,
            PreferencesKey.childCap.rawValue: 100,
            PreferencesKey.adultChildRatio.rawValue: 1000,
            PreferencesKey.visitorCap.rawValue: 100,
            PreferencesKey.temperature.rawValue: true,
            PreferencesKey.weather.rawValue: true,
            PreferencesKey.caveIns.rawValue: true,
            PreferencesKey.invasions.rawValue: true,
            PreferencesKey.invasionSoldierCap.rawValue: 120,
            PreferencesKey.invasionMonsterCap.rawValue: 40,
            PreferencesKey.artifacts.rawValue: true,
            PreferencesKey.grazeCoefficient.rawValue: 100,
            
            PreferencesKey.enableDFHack.rawValue: true,
            PreferencesKey.plugins.rawValue: [
                "title-version",
                "manipulator",
                "search",
                "automaterial",
                "confirm",
                "dwarfmonitor",
                "mousequery",
                "autogems",
                "automelt",
                "autotrade",
                "buildingplan",
                "resume",
                "trackstop",
                "zone",
                "stocks",
                "autochop",
                "stockflow",
                "stockpiles"
            ],
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