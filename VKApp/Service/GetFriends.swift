//
//  GetFriends.swift
//  VKApp
//
//  Created by Алексей Сигай on 12.03.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import RealmSwift

struct GetFriends {
    
    // Получение списка друзей текущего пользователя и передача данных в Realm
    static func get() {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let token = AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) else { return }
            let jsonURL = "https://api.vk.com/method/friends.get?access_token=\(token)&lang=ru&fields=name,photo_50&v=\(Constant.apiVersion)"
            guard let url = URL(string: jsonURL) else { return }
            let appSession = URLSession(configuration: URLSessionConfiguration.default)
            appSession.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONDecoder().decode(VKFriends.self, from: data)
                    dataTransferToRealm(json.response.items)
                }
                catch let jsonError {
                    print("Error", jsonError)
                }
            }.resume()
        }
    }
    
    // Удаление старых данных из Realm и запись новых
    private static func dataTransferToRealm(_ data: [User]) {
        do {
            let realm = try! Realm()
            let oldData = realm.objects(User.self)
            print(realm.configuration.fileURL!)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    // Получение списка друзей пользователя из Realm
    static func getDataRealm() -> Results<User> {
        var myFriends: Results<User>
        let realm = try! Realm()
        myFriends = realm.objects(User.self)
        return myFriends
    }
    
}
