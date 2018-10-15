//
//  GetUserPhoto.swift
//  VKApp
//
//  Created by Алексей Сигай on 12.03.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import RealmSwift

struct GetUserPhoto {
    
    // Получение фотографии выбранного пользователя
    static func get(userID: Int, completion: @escaping (Photo) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let token = AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) else { return }
            var userPhoto: Photo?
            let jsonURL = "https://api.vk.com/method/users.get?access_token=\(token)&user_id=\(userID)&fields=photo_100&v=\(Constant.apiVersion)"
            guard let url = URL(string: jsonURL) else { return }
            let appSession = URLSession(configuration: URLSessionConfiguration.default)
            appSession.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONDecoder().decode(VKUserPhoto.self, from: data)
                    userPhoto = json.response[0]
                    dataTransferToRealm(json.response[0])
                    completion(userPhoto!)
                }
                catch let jsonError {
                    print("Error", jsonError)
                }
            }.resume()
        }
    }
    
    // Удаление старых данных из Realm и запись новых
    private static func dataTransferToRealm(_ data: Photo) {
        DispatchQueue.main.async {
            do {
                let realm = try! Realm()
                let oldData = realm.objects(Photo.self)
                realm.beginWrite()
                realm.delete(oldData)
                realm.add(data)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }
    
    // Получение ссылки на фото пользователя из Realm
    static func getDataRealm() -> Photo? {
        var userPhotoArray = [Photo]()
        var userPhoto: Photo?
        let realm = try! Realm()
        userPhotoArray = Array(realm.objects(Photo.self))
        if userPhotoArray.count != 0 {
            userPhoto = userPhotoArray[0]
        }
        return userPhoto
    }
    
}
