//
//  DFHackViewController.swift
//  DF Mac
//
//  Created by Tamas Czinege on 07/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Cocoa

final class DFHackViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    private enum ConfigRow {
        case GroupHeader(String)
        case TweakRow(Tweak)
        case Unknown
    }
    
    private enum TweakViewTag: Int {
        case Check = 2001
    }
    
    let tweaks: [Tweak]
    
    required init?(coder: NSCoder) {
        self.tweaks = Tweak.getAll()
        super.init(coder: coder)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 1 + tweaks.count
    }
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        return row == 0
    }
    
    private func rowAtIndex(row: Int) -> ConfigRow {
        switch row {
        case 0:
            return .GroupHeader("Tweaks")
        case 1 ..< tweaks.count + 1:
            return .TweakRow(tweaks[row - 1])
        default:
            return .Unknown
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
        }
        
        view.textField?.stringValue = tweak.description
        return view
    }
    
    /**
     Find the first superview that is an instance of NSTableView
    */
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
    
    @IBAction func didClickCheckBox(sender: AnyObject?) {
        guard let checkBox = sender as? NSButton else {
            return
        }
        
        guard let tableView = DFHackViewController.findTableViewSuperView(checkBox) else {
            return
        }
        
        guard let tweak = DFHackViewController.tweakAtRow(rowAtIndex(tableView.rowForView(checkBox.superview!))) else {
            return
        }
        
        var set = Set(Preferences.tweaks)
        if checkBox.state == NSOnState {
            set.insert(tweak.name)
        } else {
            set.remove(tweak.name)
        }
        
        Preferences.tweaks = [String](set)
    }
}
