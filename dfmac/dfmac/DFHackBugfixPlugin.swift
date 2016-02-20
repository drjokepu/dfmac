//
//  DFHackBugfixPlugin.swift
//  DF Mac
//
//  Created by Tamas Czinege on 20/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class DFHackBugfixPlugin: DFHackPlugin {
    static func getAll() -> [DFHackBugfixPlugin] {
        return [
            DFHackBugfixPlugin(name: "fixdiplomats", desc: "Adds a Diplomat position to all Elven civilizations, allowing them to negotiate tree cutting quotas - and you to violate them and start wars."),
            DFHackBugfixPlugin(name: "fixmerchants", desc: "Adds the Guild Representative position to all Human civilizations, allowing them to make trade agreements.")
        ]
    }
}