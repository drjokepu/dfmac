//
//  InitTxtWriter.swift
//  DF Mac
//
//  Created by Tamas Czinege on 07/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

func writeInitTxt(src: NSURL, dest: NSURL) throws {
    let initTxt = try NSMutableString(contentsOfURL: src, encoding: NSASCIIStringEncoding)
    updateDisplaySettings(initTxt)
    try emitInitTxt(initTxt as String, dest: dest)
}

private func updateDisplaySettings(txt: NSMutableString) {
    updateSetting(txt, key: "PRINT_MODE", value: Preferences.displayMode.rawValue)
    updateSetting(txt, key: "WINDOWED", value: boolValue(!Preferences.fullScreen))
    if (!Preferences.fullScreen) {
        updateSetting(txt, key: "WINDOWEDX", value: String(Preferences.windowedWidth))
        updateSetting(txt, key: "WINDOWEDY", value: String(Preferences.windowedHeight))
    }
    
    updateSetting(txt, key: "FPS", value: boolValue(Preferences.showFPS))
    updateSetting(txt, key: "INTRO", value: boolValue(Preferences.playIntro))
}

private func updateSetting(txt: NSMutableString, key: String, value: String) {
    do {
        let exp = try NSRegularExpression(pattern: "^\\[\(key):[^\\]]+\\]$", options: NSRegularExpressionOptions.AnchorsMatchLines)
        let matches = exp.replaceMatchesInString(txt, options: [], range: NSMakeRange(0, txt.length), withTemplate: "[\(key):\(value)]")
        if matches == 0 {
            txt.appendString("\n[\(key):\(value)]")
        }
    } catch {
        print("failed to update setting: \(error)")
    }
}

private func boolValue(value: Bool) -> String {
    return value ? "YES" : "NO"
}

private func emitInitTxt(contents: String, dest: NSURL) throws {
    try contents.writeToURL(dest, atomically: false, encoding: NSASCIIStringEncoding)
}