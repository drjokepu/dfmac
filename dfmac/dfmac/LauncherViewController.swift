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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didLaunchStart", name: LAUNCH_STARTED, object: nil)
    }
    
    override func viewWillDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: LAUNCH_STARTED, object: nil)
    }
    
    @objc private func didLaunchStart() {
        guard let vc = self.storyboard?.instantiateControllerWithIdentifier("launchingViewController") as? LaunchingViewController else {
            print("cannot find launchingViewController in storyboard")
            return
        }

        presentViewControllerAsSheet(vc)
    }
    
    @IBAction func didClickQuit(sender: AnyObject?) {
        view.window?.close()
    }
    
    @IBAction func didClickLaunch(sender: AnyObject?) {
        Launcher.launch()
    }
}

