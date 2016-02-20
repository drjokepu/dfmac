//
//  Launcher.swift
//  DF Mac
//
//  Created by Tamas Czinege on 04/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

private let hardLinkQueryKeys = [NSURLNameKey, NSURLIsDirectoryKey, NSURLIsSymbolicLinkKey]

final class Launcher {
    static func launch() {
        do {
            let sessionURL = try beginSession()
            try applyPreferences(sessionURL)
            try ensureSaveFolderIsLinked(sessionURL)
            launchGame(sessionURL)
        } catch {
            print("Failed to launch: \(error)")
        }
    }
    
    @warn_unused_result private static func beginSession() throws -> NSURL {
        let sessionURL = try Paths.makeUniqueSessionDirectory()

        let df0 = Paths.dfURL()
        let df1 = Paths.dfURL(forSession: sessionURL)
        try hardLinkTree(from: df0, to: df1)

        return sessionURL
    }
    
    private static func hardLinkTree(from t0: NSURL, to t1: NSURL) throws {
        var isDir = ObjCBool(false)
        if !NSFileManager.defaultManager().fileExistsAtPath(t0.path!, isDirectory: &isDir) {
            return
        }
        
        if isDir.boolValue {
            // create mirror folder
            try NSFileManager.defaultManager().createDirectoryAtURL(t1, withIntermediateDirectories: true, attributes: nil)
            let children = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(t0, includingPropertiesForKeys: hardLinkQueryKeys, options: [])
            
            // link each child
            for child in children {
                let fileInfo = try child.resourceValuesForKeys(hardLinkQueryKeys)
                let isChildDir = (fileInfo[NSURLIsDirectoryKey] as! NSNumber).boolValue
                let isSymLink = (fileInfo[NSURLIsSymbolicLinkKey] as! NSNumber).boolValue
                
                let c0 = child
                let c1 = NSURL(fileURLWithPath: NSString.pathWithComponents([t1.path!, child.lastPathComponent!]), isDirectory: isChildDir)
                
                if isSymLink {
                    try NSFileManager.defaultManager().copyItemAtURL(c0, toURL: c1)
                } else {
                    try hardLinkTree(from: c0, to: c1)
                }
            }
            
        } else {
            try NSFileManager.defaultManager().linkItemAtURL(t0, toURL: t1)
        }
    }
    
    private static func applyPreferences(sessionURL: NSURL) throws {
        try writeInitTxt(Paths.originalInitTxtURL(), dest: Paths.gameInitTxtURL(sessionURL))
        try writeDInitTxt(Paths.originalDInitTxtURL(), dest: Paths.gameDInitTxtURL(sessionURL))
        try writeDFHackInit(Paths.dfHackInitURL(sessionURL))
    }
    
    private static func needsTerminal() -> Bool {
        return Preferences.displayMode == .text || Preferences.enableDFHack
    }
    
    private static func ensureSaveFolderIsLinked(sessionURL: NSURL) throws {
        let sourceURL = Paths.localSaveFolderURL(sessionURL)
        let targetURL = try Paths.librarySaveFolderURL()
        try Paths.createDirectoryIfDoesNotExist(targetURL)

        if NSFileManager.defaultManager().fileExistsAtPath(sourceURL.path!) {
            try NSFileManager.defaultManager().removeItemAtURL(sourceURL)
        }
        
        try NSFileManager.defaultManager().createSymbolicLinkAtURL(sourceURL, withDestinationURL: targetURL)
    }
    
    private static func launchGame(sessionURL: NSURL) {
        if needsTerminal() {
            launchGameInTerminal(sessionURL)
        } else {
            launchGameDirectly(sessionURL)
        }
    }
    
    private static func launchGameDirectly(sessionURL: NSURL) {
        let libsDir = Paths.gameLibsFolderURL(sessionURL).path!
        let env = [
            "DYLD_LIBRARY_PATH": libsDir,
            "DYLD_FRAMEWORK_PATH": libsDir
        ]
        
        let task = NSTask()
        task.launchPath = Paths.gameExecutableURL(sessionURL).path!
        task.currentDirectoryPath = Paths.gameExecutableFolderURL(sessionURL).path!
        task.environment = env
        task.launch()
    }
    
    private static func launchGameInTerminal(sessionURL: NSURL) {
        let scriptSource =
            "tell App \"Terminal\"\n" +
            "  activate\n" +
            "  do script \"DFMAC_LAUNCHER_SCRIPT_NAME=\(Preferences.enableDFHack ? "dfhack" : "df") \\\"\(Paths.launchScriptURL(sessionURL).path!)\\\";exit\"\n" +
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