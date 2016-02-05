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
}

