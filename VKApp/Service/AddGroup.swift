//
//  AddGroup.swift
//  VKApp
//
//  Created by Алексей Сигай on 15.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct AddGroup {
    
    static func add(groupID: Int) {

        DispatchQueue.global(qos: .userInteractive).async {
            guard let token = AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) else { return }
            let jsonURL = "https://api.vk.com/method/groups.join?group_id=\(groupID)&access_token=\(token)&v=\(Constant.apiVersion)"
            guard let url = URL(string: jsonURL) else { return }
            let appSession = URLSession(configuration: URLSessionConfiguration.default)
            appSession.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONDecoder().decode(VKAddGroup.self, from: data)
                    if json.error?.error_code != nil {
                        print("Error addGroup: \(json.error!.error_code)")
                    }
                }
                catch let jsonError {
                    print("Error", jsonError)
                }
            }.resume()
        }
    }

}
