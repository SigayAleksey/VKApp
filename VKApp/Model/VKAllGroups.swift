//
//  VKAllGroups.swift
//  VKApp
//
//  Created by Алексей Сигай on 15.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct VKAllGroups: Decodable {
    struct Response: Decodable {
        let count: Int
        let items: [GroupFilter]
    }
    let response: Response
}
