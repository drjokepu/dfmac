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
        try writeInitTxt(originalInitTxtURL(), dest: gameInitTxtURL())
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
        return Preferences.displayMode == .text || Preferences.enableDFHack
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
                    ],
                    NSWorkspaceLaunchConfigurationEnvironment: [
                        "DFMAC_LAUNCHER_SCRIPT_NAME": Preferences.enableDFHack ? "dfhack" : "df"
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