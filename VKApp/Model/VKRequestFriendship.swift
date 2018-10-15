//
//  VKRequestFriendship.swift
//  VKApp
//
//  Created by Алексей Сигай on 16.05.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct VKRequestFriendship: Decodable {
    struct Response: Decodable {
        let count: Int
        let items: [Int]
    }
    let response: Response
}
