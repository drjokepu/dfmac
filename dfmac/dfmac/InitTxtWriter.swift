//
//  InitTxtWriter.swift
//  DF Mac
//
//  Created by Tamas Czinege on 07/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

func writeInitTxt(src: NSURL, dest: NSURL, graphicsSet: GraphicsSetInstaller?) throws {
    let initTxt = try NSMutableString(contentsOfURL: src, encoding: NSASCIIStringEncoding)
    updateDisplaySettings(initTxt)
    
    if let grf = graphicsSet {
        grf.configureInitTxt(initTxt)
    }
    
    try emitInitTxt(initTxt as String, dest: dest)
}

private func updateDisplaySettings(txt: NSMutableString) {
    updateInitSetting(txt, key: "PRINT_MODE", value: Preferences.displayMode.rawValue)
    updateInitSetting(txt, key: "WINDOWED", value: boolValueForInitFile(!Preferences.fullScreen))
    if (!Preferences.fullScreen) {
        updateInitSetting(txt, key: "WINDOWEDX", value: String(Preferences.windowedWidth))
        updateInitSetting(txt, key: "WINDOWEDY", value: String(Preferences.windowedHeight))
    }
    
    updateInitSetting(txt, key: "FPS", value: boolValueForInitFile(Preferences.showFPS))
    updateInitSetting(txt, key: "INTRO", value: boolValueForInitFile(Preferences.playIntro))
}

private func emitInitTxt(contents: String, dest: NSURL) throws {
    try contents.writeToURL(dest, atomically: false, encoding: NSASCIIStringEncoding)
}