//
//  GetAllGroups.swift
//  VKApp
//
//  Created by Алексей Сигай on 14.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import RealmSwift

struct GetAllGroups {
    
    // Получение списка групп по параметру text и передача данных в Realm
    static func get(text: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let token = AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) else { return }
            let jsonURL = "https://api.vk.com/method/groups.search?q=\(text)&count=15&access_token=\(token)&v=\(Constant.apiVersion)"
            guard let url = URL(string: jsonURL) else { return }
            let appSession = URLSession(configuration: URLSessionConfiguration.default)
            appSession.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONDecoder().decode(VKAllGroups.self, from: data)
                    dataTransferToRealm(json.response.items)
                }
                catch let jsonError {
                    print("Error", jsonError)
                }
            }.resume()
        }
    }
    
    // Удаление старых данных из Realm и запись новых
    private static func dataTransferToRealm(_ data: [GroupFilter]) {
        do {
            let realm = try! Realm()
            let oldData = realm.objects(GroupFilter.self)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    // Получение списка групп по параметру из Realm
    static func getDataRealm() -> Results<GroupFilter> {
        var myGroups: Results<GroupFilter>
        let realm = try! Realm()
        myGroups = realm.objects(GroupFilter.self)
        return myGroups
    }
    
}
