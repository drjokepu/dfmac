//
//  Tweak.swift
//  DF Mac
//
//  Created by Tamas Czinege on 07/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

final class DFHackTweak: DFHackConfigEntry {
    let name: String
    
    override var label: String {
        return name
    }
    
    init(name: String, desc: String) {
        self.name = name
        super.init(desc: desc)
    }
    
    static func getAll() -> [DFHackTweak] {
        return [
            DFHackTweak(name: "adamantine-cloth-wear", desc: "Prevents adamantine clothing from wearing out while being worn."),
            DFHackTweak(name: "advmode-contained", desc: "Works around an issue where the screen tries to force you to select the contents separately from the container in adventure mode. This forcefully skips child reagents."),
            DFHackTweak(name: "block-labors", desc: "Prevents labors that can’t be used from being toggled."),
            DFHackTweak(name: "civ-view-agreement", desc: "Fixes overlapping text on the “view agreement” screen."),
            DFHackTweak(name: "craft-age-wear", desc: "Fixes the behavior of crafted items wearing out over time. With this tweak, items made from cloth and leather will gain a level of wear every 20 years."),
            DFHackTweak(name: "embark-profile-name", desc: "Allows the use of lowercase letters when saving embark profiles"),
            DFHackTweak(name: "eggs-fertile", desc: "Displays a fertility indicator on nestboxes"),
            DFHackTweak(name: "farm-plot-select", desc: "Adds “Select all” and “Deselect all” options to farm plot menus."),
            DFHackTweak(name: "fast-heat", desc: "Improves temperature update performance."),
            DFHackTweak(name: "fast-trade", desc: "Makes Shift-Down in the Move Goods to Depot and Trade screens select the current item (fully, in case of a stack), and scroll down one line."),
            DFHackTweak(name: "fps-min", desc: "Fixes the in-game minimum FPS setting."),
            DFHackTweak(name: "hide-priority", desc: "Adds an option to hide designation priority indicators."),
            DFHackTweak(name: "import-priority-category", desc: "Allows changing the priority of all goods in a category when discussing an import agreement with the liaison."),
            DFHackTweak(name: "kitchen-keys", desc: "Fixes DF kitchen meal keybindings."),
            DFHackTweak(name: "kitchen-prefs-color", desc: "Changes color of enabled items to green in kitchen preferences."),
            DFHackTweak(name: "kitchen-prefs-empty", desc: "Fixes a layout issue with empty kitchen tabs."),
            DFHackTweak(name: "manager-quantity", desc: "Removes the limit of 30 jobs per manager order."),
            DFHackTweak(name: "max-wheelbarrow", desc: "Allows assigning more than 3 wheelbarrows to a stockpile."),
            DFHackTweak(name: "military-color-assigned", desc: "Color squad candidates already assigned to other squads in yellow/green to make them stand out more in the list."),
            DFHackTweak(name: "military-stable-assign", desc: "Preserve list order and cursor position when assigning to squad, i.e. stop the rightmost list of the Positions page of the military screen from constantly resetting to the top."),
            DFHackTweak(name: "nestbox-color", desc: "Fixes the color of built nestboxes."),
            DFHackTweak(name: "shift-8-scroll", desc: "Gives Shift-8 (or *) priority when scrolling menus, instead of scrolling the map."),
            DFHackTweak(name: "stable-cursor", desc: "Saves the exact cursor position between t/q/k/d/b/etc menus of fortress mode."),
            DFHackTweak(name: "title-start-rename", desc: "Adds a safe rename option to the title screen “Start Playing” menu."),
            DFHackTweak(name: "tradereq-pet-gender", desc: "Displays pet genders on the trade request screen.")
        ]
    }
}