//
//  UserViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 27.02.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var userPhoto: UIImageView!
    var userID: Int?
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUserPhoto()
    }

    func setUserPhoto() {
        GetUserPhoto.get(userID: self.userID!) { [weak self] photo in
            self?.photo = photo
            
            if self?.photo != nil {
                // Запрос изображения и вставка в UIImageView
                let imageURL = URL(string: ((self?.photo!.photo_100)!))!
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.userPhoto.image = image
                    }
                }
            }
        }
    }
}
