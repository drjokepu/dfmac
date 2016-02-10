//
//  DFInitWriterTools.swift
//  DF Mac
//
//  Created by Tamas Czinege on 10/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

func updateInitSetting(txt: NSMutableString, key: String, value: String) {
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

func boolValueForInitFile(value: Bool) -> String {
    return value ? "YES" : "NO"
}