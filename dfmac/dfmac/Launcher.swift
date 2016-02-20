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
            try ensureSaveFolderIsLinked()
        } catch {
            print("Failed to launch: \(error)")
        }
        
        launchGame()
    }
    
    private static func applyPreferences() throws {
        try writeInitTxt(Paths.originalInitTxtURL(), dest: Paths.gameInitTxtURL())
        try writeDInitTxt(Paths.originalDInitTxtURL(), dest: Paths.gameDInitTxtURL())
        try writeDFHackInit(Paths.dfHackInitURL())
    }
    
    private static func needsTerminal() -> Bool {
        return Preferences.displayMode == .text || Preferences.enableDFHack
    }
    
    private static func ensureSaveFolderIsLinked() throws {
        try unlinkSaveFolder()
        let sourceURL = Paths.localSaveFolderURL()
        let targetURL = try Paths.librarySaveFolderURL()
        try Paths.createDirectoryIfDoesNotExist(targetURL)
        
        try NSFileManager.defaultManager().createSymbolicLinkAtURL(sourceURL, withDestinationURL: targetURL)
    }
    
    private static func unlinkSaveFolder() throws {
        let url = Paths.localSaveFolderURL()
        if NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
            try NSFileManager.defaultManager().removeItemAtURL(url)
        }
    }
    
    private static func launchGame() {
        if needsTerminal() {
            launchGameInTerminal()
        } else {
            launchGameDirectly()
        }
    }
    
    private static func launchGameDirectly() {
        let libsDir = Paths.gameLibsFolderURL().path!
        let env = [
            "DYLD_LIBRARY_PATH": libsDir,
            "DYLD_FRAMEWORK_PATH": libsDir
        ]
        
        let task = NSTask()
        task.launchPath = Paths.gameExecutableURL().path!
        task.currentDirectoryPath = Paths.gameExecutableFolderURL().path!
        task.environment = env
        task.launch()
    }
    
    private static func launchGameInTerminal() {
        let scriptSource =
            "tell App \"Terminal\"\n" +
            "  activate\n" +
            "  do script \"DFMAC_LAUNCHER_SCRIPT_NAME=\(Preferences.enableDFHack ? "dfhack" : "df") \\\"\(Paths.launchScriptURL().path!)\\\";exit\"\n" +
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