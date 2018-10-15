//
//  GetNews.swift
//  VKApp
//
//  Created by Алексей Сигай on 04.10.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation

struct GetNews {
    
    static func get(count: Int, completion: @escaping ([New]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var news = [New]()
            guard let token = AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) else { return }
            let jsonURL = "https://api.vk.com/method/newsfeed.get?&filters=post&count=\(count)&access_token=\(token)&v=\(Constant.apiVersion)"
            
            print(jsonURL)
            
            guard let url = URL(string: jsonURL) else { return }
            let appSession = URLSession(configuration: URLSessionConfiguration.default)
            appSession.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONDecoder().decode(VKNews.self, from: data)
                    for new in json.response.items {
                        if new.attachments != nil && new.attachments![0].type == "photo" {
                            news.append(new)
                        }
                    }
                    completion(news)
                }
                catch let jsonError {
                    print("Error", jsonError)
                }
            }.resume()
        }
    }
    
}
