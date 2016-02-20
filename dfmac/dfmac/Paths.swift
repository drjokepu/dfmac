//
//  Paths.swift
//  DF Mac
//
//  Created by Tamas Czinege on 20/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class Paths {
    /** bundle/Contents/Resources/df */
    static func dfURL() -> NSURL {
        return NSBundle.mainBundle().URLForResource("df", withExtension: nil)!
    }
    
    /** session/Contents/Resources/df */
    static func dfURL(forSession sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([sessionURL.path!, "df"]))
    }
    
    /** bundle/Contents/Resources/df/init/init.txt */
    static func originalInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "init", "init.txt"]))
    }
    
    /** bundle/Contents/Resources/df/init/d_init.txt */
    static func originalDInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "init", "d_init.txt"]))
    }
    
    /** session/df/df_osx/data/init/init.txt */
    static func gameInitTxtURL(sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL(forSession: sessionURL).path!, "df_osx", "data", "init", "init.txt"]))
    }
    
    /** session/df/df_osx/data/init/d_init.txt */
    static func gameDInitTxtURL(sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL(forSession: sessionURL).path!, "df_osx", "data", "init", "d_init.txt"]))
    }
    
    /** session/df/df_osx/dfhack.init */
    static func dfHackInitURL(sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL(forSession: sessionURL).path!, "df_osx", "dfhack.init"]))
    }
    
    /** session/df/df_osx/dwarfort.exe */
    static func gameExecutableURL(sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL(forSession: sessionURL).path!, "df_osx", "dwarfort.exe"]))
    }
    
    /** session/df/df_osx */
    static func gameExecutableFolderURL(sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL(forSession: sessionURL).path!, "df_osx"]))
    }
    
    /** session/df/df_osx/libs */
    static func gameLibsFolderURL(sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL(forSession: sessionURL).path!, "df_osx", "libs"]))
    }
    
    /** session/df/df_osx/data/save */
    static func localSaveFolderURL(sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL(forSession: sessionURL).path!, "df_osx", "data", "save"]))
    }
    
    /** ~/Library/Application Support/io.github.drjokepu.dfmac/save/active */
    static func librarySaveFolderURL() throws -> NSURL {
        let appSupport = try appSupportURL()
        return NSURL(fileURLWithPath: NSString.pathWithComponents([appSupport.path!, "save", "active"]), isDirectory: true)
    }
    
    /** session/df/launch.sh */
    static func launchScriptURL(sessionURL: NSURL) -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL(forSession: sessionURL).path!, "launch.sh"]))
    }
    
    /** ~/Library/Application Support/io.github.drjokepu.dfmac */
    static func appSupportURL() throws -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        if urls.count == 0 {
            throw AppDelegateError.CannotFindApplicationSupport
        }
        
        let appSupport = urls[0]
        return NSURL(fileURLWithPath: NSString.pathWithComponents([appSupport.path!, NSBundle.mainBundle().bundleIdentifier!]), isDirectory: true)
    }
    
    static func temporaryDirectory() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([NSTemporaryDirectory(), NSBundle.mainBundle().bundleIdentifier!]), isDirectory: true)
    }
    
    static func sessionsDirectory() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([temporaryDirectory().path!, "sessions"]), isDirectory: true)
    }
    
    @warn_unused_result static func makeUniqueSessionDirectory() throws -> NSURL {
        let uuidStr = CFUUIDCreateString(nil, CFUUIDCreate(nil)) as NSString as String
        let dirURL = NSURL(fileURLWithPath: NSString.pathWithComponents([sessionsDirectory().path!, uuidStr]), isDirectory: true)
        try createDirectoryIfDoesNotExist(dirURL)
        return dirURL
    }
    
    /**
      Creates a directory if it does not exist already.
      - parameter folderURL: The URL of the directory to create.
      */
    static func createDirectoryIfDoesNotExist(folderURL: NSURL) throws {
        if !NSFileManager.defaultManager().fileExistsAtPath(folderURL.path!) {
            try NSFileManager.defaultManager().createDirectoryAtURL(folderURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
}