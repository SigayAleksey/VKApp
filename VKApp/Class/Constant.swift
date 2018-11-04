//
//  Constant.swift
//  VKApp
//
//  Created by Алексей Сигай on 15.10.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct Constant {
    
    static let apiVersion =     "5.71"
    static let appID =          "6360164"
    static let refreshData =    "Обновление данных..."
    
    // Test adUnitID for BannerView
    static let adMobID =        "ca-app-pub-3940256099942544/2934735716"
    
    struct Key {
        static let token =              "token"
        static let lastUpdate =         "lastUpdate"
        static let firstDisplayFriends =   "firstDisplayFriends"
        static let firstDisplayGroups =    "firstDisplayGroups"
    }
    
    struct Segue {
        static let authorization =  "Authorization"
        static let showPhoto =      "ShowPhoto"
        static let addGroup =       "AddGroup"
        static let addLocation =    "AddLocation"
    }
    
    struct Cell {
        static let myFriends =  "MyFriendsCell"
        static let userPhoto =  "UserPhotoCell"
        static let myGroups =   "MyGroupsCell"
        static let allGroups =  "AllGroupsCell"
        static let news =       "NewsCell"
    }
}
