//
//  GraphicsSetInstaller.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

class GraphicsSetInstaller {
    var name: String {
        return "NONE"
    }
    
    var graphicsFontName: String {
        return ""
    }
    
    var initTxtSettings: [GraphicsSetTxtSetting] {
        return GraphicsSetInstaller.makeDefaultInitTxtSettings(graphicsFontName)
    }
    
    func install(sessionURL: NSURL) throws {
        let src = Paths.graphicsSetURL(name)
        let dest = Paths.gameExecutableFolderURL(sessionURL)
        
        try hardLinkTree(from: src, to: dest)
    }
    
    func configureInitTxt(txt: NSMutableString) {
        for setting in initTxtSettings {
            setting.apply(txt)
        }
    }
    
    static func get(graphicsSet: GraphicsSet) -> GraphicsSetInstaller? {
        switch graphicsSet {
        case .cla:
            return CLA()
        case .gemSet:
            return GemSet()
        default:
            return nil
        }
    }
    
    static func makeDefaultInitTxtSettings(graphicsFont: String) -> [GraphicsSetTxtSetting] {
        return [
            GraphicsSetTxtSetting(key: "GRAPHICS", value: "YES"),
            GraphicsSetTxtSetting(key: "GRAPHICS_WINDOWEDX", value: String(Preferences.windowedWidth)),
            GraphicsSetTxtSetting(key: "GRAPHICS_WINDOWEDY", value: String(Preferences.windowedHeight)),
            GraphicsSetTxtSetting(key: "GRAPHICS_FONT", value: graphicsFont),
            GraphicsSetTxtSetting(key: "GRAPHICS_FULLSCREENX", value: "0"),
            GraphicsSetTxtSetting(key: "GRAPHICS_FULLSCREENY", value: "0"),
            GraphicsSetTxtSetting(key: "GRAPHICS_FULLFONT", value: graphicsFont),
            GraphicsSetTxtSetting(key: "GRAPHICS_BLACK_SPACE", value: "YES"),
            GraphicsSetTxtSetting(key: "TEXTURE_PARAM", value: "LINEAR"),
        ]
    }
}
