//
//  SendPost.swift
//  VKApp
//
//  Created by Алексей Сигай on 05.10.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import MapKit

struct SendPost {
    
    static func send(text: String, coordinates: CLLocation?, completion: @escaping (Int) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let token = AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) else { return }
            var jsonURLString = ""
            if coordinates != nil {
                jsonURLString = "https://api.vk.com/method/wall.post?access_token=\(token)&message=\(text)&lat=\(coordinates!.coordinate.latitude)&long=\(coordinates!.coordinate.longitude)&v=\(Constant.apiVersion)"
            } else {
                jsonURLString = "https://api.vk.com/method/wall.post?access_token=\(token)&message=\(text)&v=\(Constant.apiVersion)"
            }
            print(jsonURLString)
            
            guard let url = URL(string: jsonURLString) else { return }
            print("url \(url)")

            let appSession = URLSession(configuration: URLSessionConfiguration.default)
            appSession.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONDecoder().decode(VKPost.self, from: data)
                    completion(json.response.post_id)
                }
                catch let jsonError {
                    print("Error", jsonError)
                }
            }.resume()
        }
    }
  
}
