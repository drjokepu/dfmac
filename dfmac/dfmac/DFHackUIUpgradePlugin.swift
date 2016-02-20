//
//  DFHackUIUpgradePlugin.swift
//  DF Mac
//
//  Created by Tamas Czinege on 20/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class DFHackUIUpgradePlugin: DFHackPlugin {
    static func getAll() -> [DFHackUIUpgradePlugin] {
        return [
            DFHackUIUpgradePlugin(name: "automaterial", desc: "This makes building constructions (walls, floors, fortifications, etc) a little bit easier by saving you from having to trawl through long lists of materials each time you place one."),
            DFHackUIUpgradePlugin(name: "automelt", desc: "When automelt is enabled for a stockpile, any meltable items placed in it will be designated to be melted."),
            DFHackUIUpgradePlugin(name: "autotrade", desc: "When autotrade is enabled for a stockpile, any items placed in it will be designated to be taken to the Trade Depot whenever merchants are on the map."),
            DFHackUIUpgradePlugin(name: "buildingplan", desc: "This plugin adds a planning mode for furniture placement."),
            DFHackUIUpgradePlugin(name: "command-prompt", desc: "An in-game DFHack terminal, where you can enter other commands."),
            DFHackUIUpgradePlugin(name: "confirm", desc: "Implements several confirmation dialogs for potentially destructive actions (for example, seizing goods from traders or deleting hauling routes)."),
            DFHackUIUpgradePlugin(name: "follow", desc: "Makes the game view follow the currently highlighted unit after you exit from the current menu or cursor mode. Handy for watching dwarves running around. Deactivated by moving the view manually."),
            DFHackUIUpgradePlugin(name: "hotkeys", desc: "Opens an in-game screen showing which DFHack keybindings are active in the current context."),
            DFHackUIUpgradePlugin(name: "manipulator", desc: "An in-game equivalent to the popular program Dwarf Therapist."),
            DFHackUIUpgradePlugin(name: "mousequery", desc: "Adds mouse controls to the DF interface, eg click-and-drag designations."),
            DFHackUIUpgradePlugin(name: "nopause", desc: "Disables pausing (both manual and automatic) with the exception of pause forced by reveal hell. This is nice for digging under rivers."),
            DFHackUIUpgradePlugin(name: "resume", desc: "Allows automatic resumption of suspended constructions, along with colored UI hints for construction status."),
            DFHackUIUpgradePlugin(name: "search", desc: "The search plugin adds search to a number of screens."),
            DFHackUIUpgradePlugin(name: "stocks", desc: "Replaces the DF stocks screen with an improved version."),
            DFHackUIUpgradePlugin(name: "trackstop", desc: "This plugin allows you to view and/or change the track stop's friction and dump direction settings, using the keybindings from the track stop building interface."),
        ]
    }
}