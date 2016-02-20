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
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    private static func registerTransformers() {
        IntegerTransformer.register()
        DisplayModeTransformer.register()
    }
    
    @IBAction func eraseSaves(sender: AnyObject?) {
        let alert = NSAlert()
        alert.alertStyle = .CriticalAlertStyle
        alert.messageText = "Your saves will be erased permanently."
        alert.addButtonWithTitle("Erase")
        alert.addButtonWithTitle("Cancel")
        
        if alert.runModal() == NSAlertFirstButtonReturn {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(Paths.librarySaveFolderURL())
            } catch {
                print("Failed to erase saves: \(error)")
            }
        }
    }
}

enum AppDelegateError: ErrorType {
    case CannotFindApplicationSupport
}