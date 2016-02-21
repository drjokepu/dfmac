//
//  DFHackUIUpgradePlugin.swift
//  DF Mac
//
//  Created by Tamas Czinege on 20/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class DFHackJobPlugin: DFHackPlugin {
    static func getAll() -> [DFHackJobPlugin] {
        return [
            DFHackJobPlugin(name: "autochop", desc: "Automatically manage tree cutting designation to keep available logs withing given quotas."),
            DFHackJobPlugin(name: "autodump", desc: "This plugin adds an option to the menu for stockpiles when enabled. When autodump is enabled for a stockpile, any items placed in the stockpile will automatically be designated to be dumped."),
            DFHackJobPlugin(name: "autogems", desc: "Creates a new Workshop Order setting, automatically cutting rough gems when enabled."),
            DFHackJobPlugin(name: "autohauler", desc: "Autohauler is an autolabor fork. Rather than the all-of-the-above means of autolabor, autohauler will instead only manage hauling labors and leave skilled labors entirely to the user, who will probably use Dwarf Therapist to do so."),
            DFHackJobPlugin(name: "autolabor", desc: "Automatically manage dwarf labors to efficiently complete jobs. Autolabor tries to keep as many dwarves as possible busy but also tries to have dwarves specialize in specific skills."),
            DFHackJobPlugin(name: "stockflow", desc: "Allows the fortress bookkeeper to queue jobs through the manager, based on space or items available in stockpiles."),
            DFHackJobPlugin(name: "workflow", desc: "Manage control of repeat jobs."),
        ]
    }
}