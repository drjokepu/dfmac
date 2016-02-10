//
//  Launcher.swift
//  DF Mac
//
//  Created by Tamas Czinege on 04/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

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
        try writeDInitTxt(originalDInitTxtURL(), dest: gameDInitTxtURL())
        try writeDFHackInit(dfHackInitURL())
    }

    private static func originalInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "init", "init.txt"]))
    }
    
    private static func originalDInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "init", "d_init.txt"]))
    }
    
    private static func gameInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "data", "init", "init.txt"]))
    }
    
    private static func gameDInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "data", "init", "d_init.txt"]))
    }
    
    private static func dfHackInitURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "dfhack.init"]))
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
        let scriptSource =
            "tell App \"Terminal\"\n" +
            "  activate\n" +
            "  do script \"DFMAC_LAUNCHER_SCRIPT_NAME=\(Preferences.enableDFHack ? "dfhack" : "df") \\\"\(launchScriptURL().path!)\\\";exit\"\n" +
            "end\n"
        
        guard let script = NSAppleScript(source: scriptSource) else {
            print("Failed to parse initialize launcher script")
            return
        }
        
        var errors: NSDictionary? = nil
        script.executeAndReturnError(&errors) as NSAppleEventDescriptor?
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