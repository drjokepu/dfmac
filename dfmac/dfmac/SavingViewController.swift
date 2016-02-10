//
//  SavingViewController.swift
//  DF Mac
//
//  Created by Tamas Czinege on 09/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Cocoa

final class SavingViewController: NSViewController {
    @IBOutlet var noneRadioButton: NSButton!
    @IBOutlet var seasonalRadioButton: NSButton!
    @IBOutlet var yearlyRadioButton: NSButton!
    
    override func viewDidLoad() {
        updateAutoSaveModeSelection()
    }
    
    private func updateAutoSaveModeSelection() {
        let mode = Preferences.autoSave
        noneRadioButton.state = SavingViewController.autoSaveButtonState(mode, expected: .none)
        seasonalRadioButton.state = SavingViewController.autoSaveButtonState(mode, expected: .seasonal)
        yearlyRadioButton.state = SavingViewController.autoSaveButtonState(mode, expected: .yearly)
    }
    
    private static func autoSaveButtonState(actual: AutoSaveMode, expected: AutoSaveMode) -> Int {
        return (actual.rawValue == expected.rawValue) ? NSOnState : NSOffState
    }
    
    private func autoSaveModeFromButton(button: NSButton) -> AutoSaveMode? {
        switch button {
        case noneRadioButton:
            return .none
        case seasonalRadioButton:
            return .seasonal
        case yearlyRadioButton:
            return .yearly
        default:
            return nil
        }
    }
    
    @IBAction func didSelectAutoSaveMode(sender: AnyObject?) {
        guard let button = sender as? NSButton else {
            return
        }
        
        guard let mode = autoSaveModeFromButton(button) else {
            return
        }
        
        Preferences.autoSave = mode
    }
}