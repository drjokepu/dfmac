//
//  DispatchQueues.swift
//  DF Mac
//
//  Created by Tamas Czinege on 20/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Foundation

let launcherQueue = dispatch_queue_create("launcher", DISPATCH_QUEUE_CONCURRENT)