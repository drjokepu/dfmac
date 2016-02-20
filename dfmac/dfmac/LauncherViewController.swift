//
//  ViewController.swift
//  dfmac
//
//  Created by Tamas Czinege on 04/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Cocoa

final class LauncherViewController: NSViewController {
    @IBOutlet var versionLabel: NSTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel?.stringValue = "Dwarf Fortress: \(Versions.df) DFHack: \(Versions.dfHack)"
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func didClickQuit(sender: AnyObject?) {
        view.window?.close()
    }
    
    @IBAction func didClickLaunch(sender: AnyObject?) {
        Launcher.launch()
    }
}

