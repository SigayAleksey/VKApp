//
//  ErrorParser.swift
//  VKApp
//
//  Created by Алексей Сигай on 26/02/2019.
//  Copyright © 2019 Sigay Aleksey. All rights reserved.
//

import Foundation
import Alamofire

protocol ErrorParserPro {
    func parse(_ result: Error) -> AppError
    func parse(_ reauest: URLRequest?, _ response: HTTPURLResponse, _ data: Data?) -> Request.ValidationResult
}

class ErrorParser: ErrorParserPro {
    
    func parse(_ result: Error) -> AppError {
        let error = result as NSError
        
        if [101, 121, -1008, -1011].contains(error.code) {
            return AppError.serverError
        }
        if [-1005, 1009].contains(error.code) {
            return AppError.networkConectionLost
        }
        if [-1001].contains(error.code) {
            return AppError.timeOut
        }
        return AppError.unknownError
    }
    
    func parse(_ request: URLRequest?, _ response: HTTPURLResponse, _ data: Data?) -> Request.ValidationResult {
        if (200..<299).contains(response.statusCode) {
            return .failure(AppError.serverError)
        } else if data == nil {
            return .failure(AppError.serverError)
        } else {
            return .success
        }
    }
}
