//
//  VKFriends.swift
//  VKApp
//
//  Created by Алексей Сигай on 14.03.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct VKFriends: Decodable {
    struct Response: Decodable {
        let count: Int
        let items: [User]
    }
    let response: Response
}
