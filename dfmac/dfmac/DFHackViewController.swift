//
//  DFHackViewController.swift
//  DF Mac
//
//  Created by Tamas Czinege on 07/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Cocoa

final class DFHackViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    private enum ConfigSection {
        case Bugfixes([DFHackBugfixPlugin])
        case Tweaks([DFHackTweak])
        case UIUpgrades([DFHackUIUpgradePlugin])
    }
    
    private enum ConfigRow {
        case GroupHeader(String)
        case PluginRow(DFHackPlugin)
        case TweakRow(DFHackTweak)
        case Unknown
    }
    
    private enum TweakViewTag: Int {
        case Check = 2001
    }
    
    private let sections: [ConfigSection]
    
    @IBOutlet var dfhackTable: NSTableView? = nil
    
    required init?(coder: NSCoder) {
        self.sections = [
            .Bugfixes(DFHackBugfixPlugin.getAll()),
            .Tweaks(DFHackTweak.getAll()),
            .UIUpgrades(DFHackUIUpgradePlugin.getAll())
        ]
        
        super.init(coder: coder)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return sections.reduce(0) { $0 + DFHackViewController.numberOfRowsInSection($1) }
    }
    
    private static func numberOfRowsInSection(section: ConfigSection) -> Int {
        return numberOfItemsInSection(section) + 1
    }
    
    private static func numberOfItemsInSection(section: ConfigSection) -> Int {
        switch section {
        case .Bugfixes(let bugfixes):
            return bugfixes.count
        case .Tweaks(let tweaks):
            return tweaks.count
        case .UIUpgrades(let upgrades):
            return upgrades.count
        }
    }
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        switch rowAtIndex(row) {
        case .GroupHeader:
            return true
        default:
            return false
        }
    }
    
    private func rowAtIndex(row: Int) -> ConfigRow {
        var rowCount = 0
        var rowSectionMaybe: ConfigSection? = nil
        var indexInSection = 0
        
        for section in sections {
            let nextRowCount = rowCount + DFHackViewController.numberOfRowsInSection(section)
            if row >= rowCount && row < nextRowCount {
                rowSectionMaybe = section
                indexInSection = row - rowCount
                break
            } else {
                rowCount = nextRowCount
            }
        }
        
        guard let section = rowSectionMaybe else {
            return .Unknown
        }
        
        if indexInSection == 0 {
            return DFHackViewController.headerForSection(section)
        } else {
            return DFHackViewController.rowInSection(section, index: indexInSection - 1)
        }
    }
    
    private static func headerForSection(section: ConfigSection) -> ConfigRow {
        switch section {
        case .Bugfixes:
            return .GroupHeader("Bug Fixes")
        case .Tweaks:
            return .GroupHeader("Tweaks")
        case .UIUpgrades:
            return .GroupHeader("User Interface Upgrades")
        }
    }
    
    private static func rowInSection(section: ConfigSection, index: Int) -> ConfigRow {
        switch section {
        case .Bugfixes(let bugfixes):
            return .PluginRow(bugfixes[index])
        case .Tweaks(let tweaks):
            return .TweakRow(tweaks[index])
        case .UIUpgrades(let upgrades):
            return .PluginRow(upgrades[index])
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        switch rowAtIndex(row) {
        case .PluginRow, .TweakRow:
            return 78
        default:
            return 17
        }
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        switch rowAtIndex(row) {
        case .GroupHeader(let label):
            return makeGroupRow(tableView, name: label)
        case .PluginRow(let plugin):
            return makePluginRow(tableView, plugin: plugin)
        case .TweakRow(let tweak):
            return makeTweakRow(tableView, tweak: tweak)
        default:
            return nil
        }
    }
    
    private func makeGroupRow(tableView: NSTableView, name: String) -> NSView? {
        guard let view = tableView.makeViewWithIdentifier("group", owner: self) as? NSTableCellView else {
            return nil
        }
        
        view.textField?.stringValue = name
        return view
    }
    
    private func makePluginRow(tableView: NSTableView, plugin: DFHackPlugin) -> NSView? {
        guard let view = tableView.makeViewWithIdentifier("plugin", owner: self) as? NSTableCellView else {
            return nil
        }
        
        if let checkBox = view.viewWithTag(TweakViewTag.Check.rawValue) as? NSButton {
            checkBox.title = plugin.label
            checkBox.state = Preferences.plugins.contains(plugin.name) ? NSOnState : NSOffState
            checkBox.enabled = Preferences.enableDFHack
        }
        
        view.textField?.stringValue = plugin.description
        return view
    }
    
    private func makeTweakRow(tableView: NSTableView, tweak: DFHackTweak) -> NSView? {
        guard let view = tableView.makeViewWithIdentifier("tweak", owner: self) as? NSTableCellView else {
            return nil
        }
        
        if let checkBox = view.viewWithTag(TweakViewTag.Check.rawValue) as? NSButton {
            checkBox.title = tweak.label
            checkBox.state = Preferences.tweaks.contains(tweak.name) ? NSOnState : NSOffState
            checkBox.enabled = Preferences.enableDFHack
        }
        
        view.textField?.stringValue = tweak.description
        return view
    }
    
    /**  Find the first superview that is an instance of NSTableView */
    private static func findTableViewSuperView(view: NSView) -> NSTableView? {
        if let tableView = view as? NSTableView {
            return tableView
        } else {
            if let superView = view.superview {
                return findTableViewSuperView(superView)
            } else {
                return nil
            }
        }
    }
    
    @IBAction func didClickEnableDFHack(sender: AnyObject) {
        dfhackTable?.reloadData()
        
        if !Preferences.enableDFHack && Preferences.displayMode == .twbt {
            Preferences.displayMode = .vbo
        }
    }
    
    @IBAction func didClickCheckBox(sender: AnyObject?) {
        guard let checkBox = sender as? NSButton else {
            return
        }
        
        let selected = (checkBox.state == NSOnState)
        
        guard let tableView = DFHackViewController.findTableViewSuperView(checkBox) else {
            return
        }
        
        switch rowAtIndex(tableView.rowForView(checkBox.superview!)) {
        case .PluginRow(let plugin):
            didSelectPlugin(plugin, selected: selected)
        case .TweakRow(let tweak):
            didSelectTweak(tweak, selected: selected)
        default: break
        }
    }
    
    private func didSelectPlugin(plugin: DFHackPlugin, selected: Bool) {
        var set = Set(Preferences.plugins)
        if selected {
            set.insert(plugin.name)
        } else {
            set.remove(plugin.name)
        }
        
        Preferences.plugins = [String](set)
    }
    
    private func didSelectTweak(tweak: DFHackTweak, selected: Bool) {
        var set = Set(Preferences.tweaks)
        if selected {
            set.insert(tweak.name)
        } else {
            set.remove(tweak.name)
        }
        
        Preferences.tweaks = [String](set)
    }
}
