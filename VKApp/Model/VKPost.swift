//
//  VKPost.swift
//  VKApp
//
//  Created by Алексей Сигай on 05.10.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct VKPost: Decodable {
    struct Response: Decodable {
        let post_id: Int
    }
    let response: Response
}
