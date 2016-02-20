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
    
    /** bundle/Contents/Resources/df/init/init.txt */
    static func originalInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "init", "init.txt"]))
    }
    
    /** bundle/Contents/Resources/df/init/d_init.txt */
    static func originalDInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "init", "d_init.txt"]))
    }
    
    /** bundle/Contents/Resources/df/df_osx/data/init/init.txt */
    static func gameInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "data", "init", "init.txt"]))
    }
    
    /** bundle/Contents/Resources/df/df_osx/data/init/d_init.txt */
    static func gameDInitTxtURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "data", "init", "d_init.txt"]))
    }
    
    /** bundle/Contents/Resources/df/df_osx/dfhack.init */
    static func dfHackInitURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "dfhack.init"]))
    }
    
    /** bundle/Contents/Resources/df/df_osx/dwarfort.exe */
    static func gameExecutableURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "dwarfort.exe"]))
    }
    
    /** bundle/Contents/Resources/df/df_osx */
    static func gameExecutableFolderURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx"]))
    }
    
    /** bundle/Contents/Resources/df/df_osx/libs */
    static func gameLibsFolderURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "libs"]))
    }
    
    /** bundle/Contents/Resources/df/df_osx/data/save */
    static func localSaveFolderURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "df_osx", "data", "save"]))
    }
    
    /** ~/Library/Application Support/io.github.drjokepu.dfmac/save/active */
    static func librarySaveFolderURL() throws -> NSURL {
        let appSupport = try appSupportURL()
        return NSURL(fileURLWithPath: NSString.pathWithComponents([appSupport.path!, "save", "active"]), isDirectory: true)
    }
    
    /** bundle/Contents/Resources/df/launch.sh */
    static func launchScriptURL() -> NSURL {
        return NSURL(fileURLWithPath: NSString.pathWithComponents([dfURL().path!, "launch.sh"]))
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