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
    updateGameplaySettings(initTxt)
    try emitDInitTxt(initTxt as String, dest: dest)
}

private func updateSavingSettings(txt: NSMutableString) {
    updateInitSetting(txt, key: "AUTOSAVE", value: Preferences.autoSave.rawValue)
    updateInitSetting(txt, key: "AUTOBACKUP", value: boolValueForInitFile(Preferences.autoBackup))
    updateInitSetting(txt, key: "AUTOSAVE_PAUSE", value: boolValueForInitFile(Preferences.pauseOnSave))
    updateInitSetting(txt, key: "INITIAL_SAVE", value: boolValueForInitFile(Preferences.initialSave))
    updateInitSetting(txt, key: "PAUSE_ON_LOAD", value: boolValueForInitFile(Preferences.pauseOnLoad))
}

private func updateGameplaySettings(txt: NSMutableString) {
    updateInitSetting(txt, key: "POPULATION_CAP", value: String(Preferences.populationCap))
    updateInitSetting(txt, key: "BABY_CHILD_CAP", value: "\(Preferences.childCap):\(Preferences.adultChildRatio)")
    updateInitSetting(txt, key: "VISITOR_CAP", value: String(Preferences.visitorCap))
    
    updateInitSetting(txt, key: "TEMPERATURE", value: boolValueForInitFile(Preferences.temperature))
    updateInitSetting(txt, key: "WEATHER", value: boolValueForInitFile(Preferences.weather))
    updateInitSetting(txt, key: "CAVEINS", value: boolValueForInitFile(Preferences.caveIns))
    updateInitSetting(txt, key: "INVADERS", value: boolValueForInitFile(Preferences.invasions))
    updateInitSetting(txt, key: "INVASION_SOLDIER_CAP", value: String(Preferences.invasionSoldierCap))
    updateInitSetting(txt, key: "INVASION_MONSTER_CAP", value: String(Preferences.invasionMonsterCap))
    
    updateInitSetting(txt, key: "ARTIFACTS", value: boolValueForInitFile(Preferences.artifacts))
    updateInitSetting(txt, key: "GRAZE_COEFFICIENT", value: String(Preferences.grazeCoefficient))
}

private func emitDInitTxt(contents: String, dest: NSURL) throws {
    try contents.writeToURL(dest, atomically: false, encoding: NSASCIIStringEncoding)
}