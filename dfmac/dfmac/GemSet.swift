//
//  GemSet.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class GemSet: GraphicsSetInstaller {
    override var name: String {
        return "gemset"
    }
    
    override var initTxtSettings: [GraphicsSetTxtSetting] {
        return [
            GraphicsSetTxtSetting(key: "GRAPHICS", value: "YES"),
            GraphicsSetTxtSetting(key: "GRAPHICS_WINDOWEDX", value: "0"),
            GraphicsSetTxtSetting(key: "GRAPHICS_WINDOWEDY", value: "0"),
            GraphicsSetTxtSetting(key: "GRAPHICS_FONT", value: "gemset_map.png"),
            GraphicsSetTxtSetting(key: "GRAPHICS_FULLSCREENX", value: "0"),
            GraphicsSetTxtSetting(key: "GRAPHICS_FULLSCREENY:", value: "0"),
            GraphicsSetTxtSetting(key: "GRAPHICS_FULLFONT", value: "gemset_map.png"),
            GraphicsSetTxtSetting(key: "GRAPHICS_BLACK_SPACE", value: "YES"),
            GraphicsSetTxtSetting(key: "TEXTURE_PARAM", value: "LINEAR"),
        ]
    }
}