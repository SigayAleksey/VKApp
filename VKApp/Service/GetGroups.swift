//
//  GetGroups.swift
//  VKApp
//
//  Created by Алексей Сигай on 12.03.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import RealmSwift

struct GetGroups {
    
    // Получение списка групп текущего пользователя и передача данных в Realm
    static func get() {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let token = AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) else { return }
            let jsonURL = "https://api.vk.com/method/groups.get?access_token=\(token)&extended=1&fields=id,name,photo_50&v=\(Constant.apiVersion)"
            guard let url = URL(string: jsonURL) else { return }
            let appSession = URLSession(configuration: URLSessionConfiguration.default)
            appSession.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONDecoder().decode(VKGroups.self, from: data)
                    dataTransferToRealm(json.response.items)
                }
                catch let jsonError {
                    print("Error", jsonError)
                }
            }.resume()
        }
    }
    
    // Удаление старых данных из Realm и запись новых
    private static func dataTransferToRealm(_ data: [Group]) {
        do {
            let realm = try! Realm()
            print(realm.configuration.fileURL!)
            let oldData = realm.objects(Group.self)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    // Получение списка групп пользователя из Realm
    static func getDataRealm() -> Results<Group> {
        var myGroups: Results<Group>
        let realm = try! Realm()
        myGroups = realm.objects(Group.self)
        return myGroups
    }
    
}
