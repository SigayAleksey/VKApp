//
//  FBUserAddGroup.swift
//  VKApp
//
//  Created by Алексей Сигай on 16.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct UserAdd: Codable {
    let users: [FBUser]

    var toAny: Any {
        return [
            "users": users.map { $0.toAny }
        ]
    }
}

struct FBUser: Codable {
    let user: Int
    let groups: [FBGroup]
    
    var toAny: Any {
        return [
            "user": user,
            "groups": groups.map { $0.toAny }
        ]
    }
}

struct FBGroup: Codable{
    let group: Int
    
    var toAny: Any {
        return [
            "group": group
        ]
    }
}
