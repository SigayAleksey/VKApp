//
//  New.swift
//  VKApp
//
//  Created by Алексей Сигай on 01.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

class New: Decodable {
    
    struct Attachment: Decodable {
        let type: String
        let photo: PostPhoto?
        init(type: String, photo: PostPhoto) {
            self.type = type
            self.photo = photo
        }
    }
    struct PostPhoto: Decodable {
        let id: Int
        let photo_130: String
        let photo_604: String?
        let width: Int
        let height: Int
        let text: String
        init(id: Int, photo_130: String, photo_604: String, width: Int, height: Int, text: String) {
            self.id = id
            self.photo_130 = photo_130
            self.photo_604 = photo_604
            self.width = width
            self.height = height
            self.text = text
        }
    }
    struct Comments: Decodable {
        let count: Int
    }
    struct Likes: Decodable {
        let count: Int
    }
    struct Reposts: Decodable {
        let count: Int
    }
    struct Views: Decodable {
        let count: Int
    }
    
    let type: String
    let post_id: Int
    let text: String
    let attachments: [Attachment]?
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views?
    
    init(type: String, post_id: Int, text: String, attachments: [Attachment], comments: Comments, likes: Likes, reposts: Reposts, views: Views) {
        self.type = type
        self.post_id = post_id
        self.text = text
        self.attachments = attachments
        self.comments = comments
        self.likes = likes
        self.reposts = reposts
        self.views = views
    }
    
}
