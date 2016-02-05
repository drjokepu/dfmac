//
//  Launcher.swift
//  DF Mac
//
//  Created by Tamas Czinege on 04/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import AppKit
import Foundation

final class Launcher {
    static func launch() {
        do {
            try applyPreferences()
        } catch {
            print("Failed to appy preferences: \(error)")
        }
        
        launchGame()
    }
    
    private static func applyPreferences() throws {
        let initTxt = try NSMutableString(contentsOfURL: Launcher.originalInitTxtURL(), encoding: NSASCIIStringEncoding)
        updateDisplaySettings(initTxt)
        try Launcher.emitInitTxt(initTxt as String)
    }
    
    private static func updateDisplaySettings(txt: NSMutableString) {
        updateSetting(txt, key: "PRINT_MODE", value: Preferences.displayMode.rawValue)
        updateSetting(txt, key: "WINDOWED", value: boolValue(!Preferences.fullScreen))
        if (!Preferences.fullScreen) {
            updateSetting(txt, key: "WINDOWEDX", value: String(Preferences.windowedWidth))
            updateSetting(txt, key: "WINDOWEDY", value: String(Preferences.windowedHeight))
        }
        
        updateSetting(txt, key: "FPS", value: boolValue(Preferences.showFPS))
        updateSetting(txt, key: "INTRO", value: boolValue(Preferences.playIntro))
    }

    private static func updateSetting(txt: NSMutableString, key: String, value: String) {
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
    
    private static func boolValue(value: Bool) -> String {
        return value ? "YES" : "NO"
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
    
    private static func launchScriptURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "launch.sh"]))
    }
    
    private static func dfURL() -> NSURL {
        return NSBundle.mainBundle().URLForResource("df", withExtension: nil)!
    }
    
    private static func needsTerminal() -> Bool {
        return Preferences.displayMode == .text
    }
    
    private static func launchGame() {
        if needsTerminal() {
            launchGameInTerminal()
        } else {
            launchGameDirectly()
        }
    }
    
    private static func launchGameDirectly() {
        let libsDir = Launcher.gameLibsFolderURL().path!
        let env = [
            "DYLD_LIBRARY_PATH": libsDir,
            "DYLD_FRAMEWORK_PATH": libsDir
        ]
        
        let task = NSTask()
        task.launchPath = Launcher.gameExecutableURL().path!
        task.currentDirectoryPath = Launcher.gameExecutableFolderURL().path!
        task.environment = env
        task.launch()
    }
    
    private static func launchGameInTerminal() {
        do {
            let ws = NSWorkspace.sharedWorkspace()
            guard let terminalAppURL = ws.URLForApplicationWithBundleIdentifier("com.apple.Terminal") else {
                print("Could not find Terminal.app")
                return
            }
            
            try ws.launchApplicationAtURL(
                terminalAppURL,
                options: .NewInstance,
                configuration: [
                    NSWorkspaceLaunchConfigurationArguments: [
                        launchScriptURL().path!
                    ]
                ]
            )
        } catch {
            print("Failed to launch game in terminal: \(error)")
        }
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