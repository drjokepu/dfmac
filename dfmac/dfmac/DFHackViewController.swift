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
        case Tweaks([Tweak])
    }
    
    private enum ConfigRow {
        case GroupHeader(String)
        case TweakRow(Tweak)
        case Unknown
    }
    
    private enum TweakViewTag: Int {
        case Check = 2001
    }
    
    private let sections: [ConfigSection]
    
    @IBOutlet var dfhackTable: NSTableView? = nil
    
    required init?(coder: NSCoder) {
        self.sections = [
            .Tweaks(Tweak.getAll())
        ]
        
        super.init(coder: coder)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return sections.reduce(0) { $0 + DFHackViewController.numberOfRowsInSection($1) + 1 }
    }
    
    private static func numberOfRowsInSection(section: ConfigSection) -> Int {
        switch section {
        case .Tweaks(let tweaks):
            return tweaks.count
        }
    }
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        return row == 0
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
        case .Tweaks(_):
            return .GroupHeader("Tweaks")
        }
    }
    
    private static func rowInSection(section: ConfigSection, index: Int) -> ConfigRow {
        switch section {
        case .Tweaks(let tweaks):
            return .TweakRow(tweaks[index])
        }
    }
    
    private static func tweakAtRow(row: ConfigRow) -> Tweak? {
        switch row {
        case .TweakRow(let tweak):
            return tweak
        default:
            return nil
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        switch rowAtIndex(row) {
        case .TweakRow:
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
    
    private func makeTweakRow(tableView: NSTableView, tweak: Tweak) -> NSView? {
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
        case .TweakRow(let tweak):
            didSelectTweak(tweak, selected: selected)
        default: break
        }
    }
    
    private func didSelectTweak(tweak: Tweak, selected: Bool) {
        var set = Set(Preferences.tweaks)
        if selected {
            set.insert(tweak.name)
        } else {
            set.remove(tweak.name)
        }
        
        Preferences.tweaks = [String](set)
    }
}
