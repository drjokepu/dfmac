//
//  AppDelegate.swift
//  dfmac
//
//  Created by Tamas Czinege on 04/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        AppDelegate.registerTransformers()
        Preferences.registerDefaults()
        AppDelegate.registerCleanup()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    private static func registerTransformers() {
        IntegerTransformer.register()
        DisplayModeTransformer.register()
    }
    
    private static func registerCleanup() {
        atexit { cleanupSessions() }
    }
    
    @IBAction func eraseSaves(sender: AnyObject?) {
        let alert = NSAlert()
        alert.alertStyle = .CriticalAlertStyle
        alert.messageText = "Your saves will be erased permanently."
        alert.addButtonWithTitle("Erase")
        alert.addButtonWithTitle("Cancel")
        
        if alert.runModal() == NSAlertFirstButtonReturn {
            do {
                let url = try Paths.librarySaveFolderURL()
                if NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
                    try NSFileManager.defaultManager().removeItemAtURL(url)
                }
            } catch {
                print("Failed to erase saves: \(error)")
            }
        }
    }
}

private func cleanupSessions() {
    autoreleasepool {
        let sessionsDir = Paths.sessionsDirectory()
        if NSFileManager.defaultManager().fileExistsAtPath(sessionsDir.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(sessionsDir)
            } catch {
                print("Failed to clean up temporary sessions: \(error)")
            }
        }
    }
}

enum AppDelegateError: ErrorType {
    case CannotFindApplicationSupport
}