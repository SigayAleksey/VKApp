//
//  AppError.swift
//  VKApp
//
//  Created by Алексей Сигай on 26/02/2019.
//  Copyright © 2019 Sigay Aleksey. All rights reserved.
//

import Foundation

/// Формат вывода ошибки пользователю
struct ErrorMessageForUser {
    let title: String
    let message: String?
}

/// Виды сетевых ошибок приложения
enum AppError: Error {
    case serverError
    case networkConectionLost
    case timeOut
    case unknownError
}

/// Описание ошибок приложения и возрат текста для алерта
extension AppError {
    var description: ErrorMessageForUser {
        switch self {
        case .serverError:
            return ErrorMessageForUser(title: "Ошибка сервера", message: "Пожалуйста, повторите попытку позже")
        case .networkConectionLost:
            return ErrorMessageForUser(title: "Отсутствует интернет соединение", message: "Пожалуйста, повторите попытку после восстановления сетевого подключения")
        case .timeOut:
            return ErrorMessageForUser(title: "Сервер временно недоступен", message: "Пожалуйста, повторите попытку позже")
        case .unknownError:
            return ErrorMessageForUser(title: "Неизвестная ошибка", message: "Если проблема повоторится, обратитесь, пожалуйста, в техподдержку")
        }
    }
}
