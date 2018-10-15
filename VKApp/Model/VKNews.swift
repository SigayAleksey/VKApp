//
//  VKNews.swift
//  VKApp
//
//  Created by Алексей Сигай on 25.03.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct VKNews: Decodable {
    struct Response: Decodable {
        let items: [New]
    }
    let response: Response
}
