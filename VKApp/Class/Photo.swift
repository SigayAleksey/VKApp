//
//  Photo.swift
//  VKApp
//
//  Created by Алексей Сигай on 02.02.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import RealmSwift

class Photo: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_100: String = ""
    
    convenience init(id: Int, first_name: String, last_name: String, photo_100: String) {
        
        self.init()
        
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.photo_100 = photo_100
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
