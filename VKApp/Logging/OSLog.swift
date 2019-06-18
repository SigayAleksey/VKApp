//
//  OSLog.swift
//  VKApp
//
//  Created by Алексей Сигай on 28/02/2019.
//  Copyright © 2019 Sigay Aleksey. All rights reserved.
//

import Foundation
import os.log

struct OSLog {
    
    static func forEvent(event: String) {
        os_log("%{public}@", event)
    }
}
