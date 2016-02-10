//
//  DInitWriter.swift
//  DF Mac
//
//  Created by Tamas Czinege on 10/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

func writeDInitTxt(src: NSURL, dest: NSURL) throws {
    let initTxt = try NSMutableString(contentsOfURL: src, encoding: NSASCIIStringEncoding)
    updateSavingSettings(initTxt)
    try emitDInitTxt(initTxt as String, dest: dest)
}

private func updateSavingSettings(txt: NSMutableString) {
    updateInitSetting(txt, key: "AUTOSAVE", value: Preferences.autoSave.rawValue)
    updateInitSetting(txt, key: "AUTOBACKUP", value: boolValueForInitFile(Preferences.autoBackup))
    updateInitSetting(txt, key: "AUTOSAVE_PAUSE", value: boolValueForInitFile(Preferences.pauseOnSave))
    updateInitSetting(txt, key: "INITIAL_SAVE", value: boolValueForInitFile(Preferences.initialSave))
    updateInitSetting(txt, key: "PAUSE_ON_LOAD", value: boolValueForInitFile(Preferences.pauseOnLoad))
}

private func emitDInitTxt(contents: String, dest: NSURL) throws {
    try contents.writeToURL(dest, atomically: false, encoding: NSASCIIStringEncoding)
}