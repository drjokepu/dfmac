//
//  Packager.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

private let hardLinkQueryKeys = [NSURLNameKey, NSURLIsDirectoryKey, NSURLIsSymbolicLinkKey]

func hardLinkTree(from t0: NSURL, to t1: NSURL) throws {
    var isDir = ObjCBool(false)
    if !NSFileManager.defaultManager().fileExistsAtPath(t0.path!, isDirectory: &isDir) {
        return
    }
    
    if !isDir && NSFileManager.defaultManager().fileExistsAtPath(t1.path!) {
        try NSFileManager.defaultManager().removeItemAtURL(t1)
    }
    
    if isDir.boolValue {
        // create mirror folder
        try NSFileManager.defaultManager().createDirectoryAtURL(t1, withIntermediateDirectories: true, attributes: nil)
        let children = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(t0, includingPropertiesForKeys: hardLinkQueryKeys, options: [])
        
        // link each child
        for child in children {
            let fileInfo = try child.resourceValuesForKeys(hardLinkQueryKeys)
            let isChildDir = (fileInfo[NSURLIsDirectoryKey] as! NSNumber).boolValue
            let isSymLink = (fileInfo[NSURLIsSymbolicLinkKey] as! NSNumber).boolValue
            
            let c0 = child
            let c1 = NSURL(fileURLWithPath: NSString.pathWithComponents([t1.path!, child.lastPathComponent!]), isDirectory: isChildDir)
            
            if isSymLink {
                try NSFileManager.defaultManager().copyItemAtURL(c0, toURL: c1)
            } else {
                try hardLinkTree(from: c0, to: c1)
            }
        }
        
    } else {
        try NSFileManager.defaultManager().linkItemAtURL(t0, toURL: t1)
    }
}