//
//  NetworkService.swift
//  VKApp
//
//  Created by Алексей Сигай on 26/02/2019.
//  Copyright © 2019 Sigay Aleksey. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkServicePro {
    func reqest<T: Decodable>(
        _ request: URLRequestConvertible,
        completion: @escaping (T?, Error?) -> Void)
}

class NetworkService: NetworkServicePro {
    let errorParcer: ErrorParserPro
    let sessionManager: SessionManager
    
    init(
        errorParcer: ErrorParserPro,
        sessionManager: SessionManager) {
        
        self.errorParcer = errorParcer
        self.sessionManager = sessionManager
    }
    
    func reqest<T: Decodable>(
        _ request: URLRequestConvertible,
        completion: @escaping (T?, Error?) -> Void) {
        
        sessionManager
            .request(request)
            .validate(errorParcer.parse)
            .responseData { [weak self] resрonse in
                if let resрonseError = resрonse.error {
                    let error = self?.errorParcer.parse(resрonseError)
                    completion(nil, error)
                    return
                }
                do {
                    
                    /* For debuging
                     debugPrint(resрonse)
                     print(resрonse.result.value!)
                     print(try JSONSerialization.jsonObject(with: resрonse.result.value!, options: []) as! [String: Any])
                     */
                    let value = try JSONDecoder().decode(T.self, from: resрonse.result.value!)
                    completion(value, nil)
                } catch {
                    let error = self?.errorParcer.parse(error)
                    completion(nil, error)
                }
        }
    }
}
