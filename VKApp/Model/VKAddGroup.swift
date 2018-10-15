//
//  VKAddGroup.swift
//  VKApp
//
//  Created by Алексей Сигай on 15.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct VKAddGroup: Decodable {
    struct Error: Decodable {
        let error_code: Int
        let error_msg: String
    }
    let response: Int?
    let error: Error?
}
