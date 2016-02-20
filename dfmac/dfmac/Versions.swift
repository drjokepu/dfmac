//
//  Versions.swift
//  DF Mac
//
//  Created by Tamas Czinege on 20/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class Versions {
    private let _dfVersion: String
    private let _dfHackVersion: String
    
    private static let sharedVersions: Versions = Versions.loadShared()
    
    static var df: String {
        return sharedVersions._dfVersion
    }
    
    static var dfHack: String {
        return sharedVersions._dfHackVersion
    }
    
    private init(dfVersion: String, dfHackVersion: String) {
        self._dfVersion = dfVersion
        self._dfHackVersion = dfHackVersion
    }
    
    private static func loadShared() -> Versions {
        do {
            let dfVersion = try readDFVersion()
            let dfHackVersion = try readDFHackVersion()
            return Versions(dfVersion: dfVersion, dfHackVersion: dfHackVersion)
        } catch {
            print("Cannot read version information: \(error)")
            return Versions(dfVersion: "unknown", dfHackVersion: "unknown")
        }
    }
    
    private static func readDFVersion() throws -> String {
        return try readVersionFile("dfversion")
    }
    
    private static func readDFHackVersion() throws -> String {
        return try readVersionFile("dfhackversion")
    }
    
    private static func readVersionFile(filename: String) throws -> String {
        let versionFileURL = NSURL(fileURLWithPath: NSString.pathWithComponents([Paths.dfURL().path!, filename]), isDirectory: false)
        return try NSString(contentsOfURL: versionFileURL, encoding: NSASCIIStringEncoding) as String
    }
}