//
//  MyFriendsTableViewCell.swift
//  VKApp
//
//  Created by Алексей Сигай on 28.01.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!

    override func awakeFromNib() {
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        super.awakeFromNib()
    }
    
    func makeFrame() {
        userPhoto.frame = GetFrameBasic.photo()
        userName.frame = GetFrameBasic.name(bounds: bounds)
    }

}
