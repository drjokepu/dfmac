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
    
    var initTxtSettings: [GraphicsSetTxtSetting] {
        return []
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
        case .gemSet:
            return GemSet()
        default:
            return nil
        }
    }
}
