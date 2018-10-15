//
//  GetRequestFriendship.swift
//  VKApp
//
//  Created by Алексей Сигай on 16.05.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import RealmSwift

struct GetRequestFriendship {
    
    static func get(completion: @escaping (Int) -> Void) {
        var requestCount = 0
        guard let token = AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) else { return }
        let jsonURL = "https://api.vk.com/method/friends.getRequests?access_token=\(token)&need_viewed=1&v=\(Constant.apiVersion)"
        guard let url = URL(string: jsonURL) else { return }
        let appSession = URLSession(configuration: URLSessionConfiguration.default)
        appSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(VKRequestFriendship.self, from: data)
                requestCount = json.response.count
                completion(requestCount)
            }
            catch let jsonError {
                print("Error", jsonError)
            }
        }.resume()
    }
    
}

