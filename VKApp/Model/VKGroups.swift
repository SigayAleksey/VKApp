//
//  VKGroups.swift
//  VKApp
//
//  Created by Алексей Сигай on 13.03.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct VKGroups: Decodable {
    struct Response: Decodable {
        let count: Int
        let items: [Group]
    }
    let response: Response
}
