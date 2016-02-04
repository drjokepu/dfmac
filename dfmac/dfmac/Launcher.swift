//
//  Launcher.swift
//  DF Mac
//
//  Created by Tamas Czinege on 04/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class Launcher {
    let preferences: Preferences
    
    init(preferences: Preferences) {
        self.preferences = preferences
    }
    
    func launch() {
        do {
            try applyPreferences()
        } catch {
            print("Failed to appy preferences: \(error)")
        }
        
        launchGame()
    }
    
    private func applyPreferences() throws {
        let initTxt = try NSMutableString(contentsOfURL: Launcher.originalInitTxtURL(), encoding: NSASCIIStringEncoding)
        updateSetting(initTxt, key: "PRINT_MODE", value: "STANDARD")
        try Launcher.emitInitTxt(initTxt as String)
    }

    private func updateSetting(txt: NSMutableString, key: String, value: String) {
        do {
            let exp = try NSRegularExpression(pattern: "^\\[\(key):[^\\]]+\\]$", options: NSRegularExpressionOptions.AnchorsMatchLines)
            let matches = exp.replaceMatchesInString(txt, options: [], range: NSMakeRange(0, txt.length), withTemplate: "[\(key):\(value)]")
            if matches == 0 {
                txt.appendString("\n[\(key):\(value)]")
            }
        } catch {
            print("failed to update setting: \(error)")
        }
    }
    
    private static func emitInitTxt(initTxt: String) throws {
        try initTxt.writeToURL(Launcher.gameInitTxtURL(), atomically: false, encoding: NSASCIIStringEncoding)
    }
    
    private static func originalInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "init", "init.txt"]))
    }
    
    private static func gameInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "data", "init", "init.txt"]))
    }
    
    private static func gameExecutableURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "dwarfort.exe"]))
    }
    
    private static func gameExecutableFolderURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx"]))
    }
    
    private static func gameLibsFolderURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "libs"]))
    }
    
    private static func dfURL() -> NSURL {
        return NSBundle.mainBundle().URLForResource("df", withExtension: nil)!
    }
    
    private func launchGame() {
        let libsDir = Launcher.gameLibsFolderURL().path!
        var env = [String: String]()
        env["DYLD_LIBRARY_PATH"] = libsDir
        env["DYLD_FRAMEWORK_PATH"] = libsDir
        
        let task = NSTask()
        task.launchPath = Launcher.gameExecutableURL().path!
        task.currentDirectoryPath = Launcher.gameExecutableFolderURL().path!
        task.environment = env
        task.launch()
    }
}

private func makeSettingRegExp() -> NSRegularExpression {
    var exp: NSRegularExpression? = nil
    do {
        exp = try NSRegularExpression(pattern: "^\\[([^:]+):([^\\]+)\\]$", options: [])
    } catch {
        print("failed to initialize regular expression: \(error)")
    }
    
    return exp!
}