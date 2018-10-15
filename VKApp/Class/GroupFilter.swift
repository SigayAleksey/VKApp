//
//  GroupFilter.swift
//  VKApp
//
//  Created by Алексей Сигай on 15.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import RealmSwift

class GroupFilter: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var is_closed: Int = 0
    @objc dynamic var photo_50: String = ""
    
    convenience init(id: Int, name: String, is_closed: Int, photo_50: String) {
        
        self.init()
        
        self.id = id
        self.name = name
        self.is_closed = is_closed
        self.photo_50 = photo_50
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
