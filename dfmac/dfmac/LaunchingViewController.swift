//
//  LaunchingViewController.swift
//  DF Mac
//
//  Created by Tamas Czinege on 20/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Cocoa

final class LaunchingViewController: NSViewController {
    @IBOutlet var progress: NSProgressIndicator?
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didLaunchFinish", name: LAUNCH_FINISHED, object: nil)
        progress?.startAnimation(self)
    }
    
    override func viewWillDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: LAUNCH_FINISHED, object: nil)
        progress?.stopAnimation(self)
    }
    
    @objc private func didLaunchFinish() {
        view.window!.sheetParent!.endSheet(view.window!, returnCode: NSModalResponseOK)
    }
}
