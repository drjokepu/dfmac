//
//  DisplayMode.swift
//  DF Mac
//
//  Created by Tamas Czinege on 05/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

enum DisplayMode: String {
    case standard = "STANDARD"
    case text = "TEXT"
    case frameBuffer = "FRAME_BUFFER"
    case twbt = "TWBT"
    case twbtLegacy = "TWBT_LEGACY"
    case vbo = "VBO"
}

func displayModeRequiresDFHack(mode: DisplayMode) -> Bool {
    switch mode {
    case .twbt, .twbtLegacy:
        return true
    default:
        return false
    }
}