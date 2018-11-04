//
//  AuthorizationViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 28.01.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit
import VK_ios_sdk
import RealmSwift
import UserNotifications

class AuthorizationViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    private let scope = [VK_PER_FRIENDS, VK_PER_GROUPS, VK_PER_WALL]

    @IBOutlet weak var logStatusLabel: UILabel!
    static let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Разрешение для бэйджа на иконке
        let userNotification = UNUserNotificationCenter.current()
        userNotification.requestAuthorization(options: [.badge, .alert, .sound]) { (sucess, error) in
            print("requestAuthorization: sucess")
        }
        
        VKSdk.initialize(withAppId: Constant.appID, apiVersion: Constant.apiVersion).register(self)
        VKSdk.instance().uiDelegate = self
        // Проверка доступности предыдущей сессии
        VKSdk.wakeUpSession(scope) { state, error in
            if state == .authorized && AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) != nil {
                self.entry()
            } else if error != nil {
                self.logStatusLabel.text = "Please, try again"
            } else {
                self.logStatusLabel.text = "Please, log in..."
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logStatusLabel.text = "Log OFF"
        if AuthorizationViewController.userDefaults.string(forKey: Constant.Key.token) != nil {
            entry()
        }
    }
    
    // MARK: - Запуск авторизации
    
    @IBAction private func logON(_ sender: UIButton) {
        VKSdk.forceLogout()
        VKSdk.authorize(scope)
    }
    
    // Авторизация через Safari
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.navigationController?.topViewController?.present(controller, animated: true, completion: nil)
    }
    
    // Делегат авторизации для получения token
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            self.logStatusLabel.text = "Log ON"
            let token = VKSdk.accessToken().accessToken!
            AuthorizationViewController.userDefaults.set(token, forKey: Constant.Key.token)
            AuthorizationViewController.userDefaults.set(true, forKey: Constant.Key.firstDisplayFriends)
            AuthorizationViewController.userDefaults.set(true, forKey: Constant.Key.firstDisplayGroups)
            navigationController?.topViewController?.performSegue(withIdentifier: Constant.Segue.authorization, sender: self)
        } else {
            print("AuthorizationFinished: NO")
        }
    }
    func vkSdkUserAuthorizationFailed() {
        print("AuthorizationFailed")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Переход на TabBarControllet в случае получения token
    func entry() {
        self.performSegue(withIdentifier: Constant.Segue.authorization, sender: self)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        var viewController: VKCaptchaViewController
        viewController = VKCaptchaViewController.captchaControllerWithError(captchaError)
        viewController.present(in: self.navigationController?.topViewController)
    }
    
    static func getUserId() -> String {
        let userId = String(VKSdk.accessToken().userId)
        return userId
    }
    
    // MARK: - Выход из профиля

    static func logOff(_ viewController: UIViewController) -> Void {
        // Очистра данных Realm
        do {
            let realm = try! Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
        // Очистка токена
        AuthorizationViewController.userDefaults.removeObject(forKey: Constant.Key.token)
        AuthorizationViewController.userDefaults.removeObject(forKey: Constant.Key.firstDisplayFriends)
        AuthorizationViewController.userDefaults.removeObject(forKey: Constant.Key.firstDisplayGroups)
    }

}
