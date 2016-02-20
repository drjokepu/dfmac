//
//  DFHackInitWriter.swift
//  DF Mac
//
//  Created by Tamas Czinege on 07/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

func writeDFHackInit(dest: NSURL) throws {
    if !Preferences.enableDFHack {
        return
    }
    
    let str = NSMutableString()
    writeKeyBindings(str)
    writeTweaks(str)
    writePlugins(str)
    writeScripts(str)
    try emitDFHackInit(str as String, dest: dest)
}

private func writeKeyBindings(str: NSMutableString) {
    
}

private func writeTweaks(str: NSMutableString) {
    for tweak in Preferences.tweaks {
        str.appendString("tweak \(tweak)\n")
    }
}

private func writePlugins(str: NSMutableString) {
    for plugin in Preferences.plugins {
        str.appendString("enable \(plugin)\n")
    }
}

private func writeScripts(str: NSMutableString) {
    
}

private func emitDFHackInit(contents: String, dest: NSURL) throws {
    try contents.writeToURL(dest, atomically: false, encoding: NSASCIIStringEncoding)
}