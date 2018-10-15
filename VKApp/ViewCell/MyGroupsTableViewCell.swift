//
//  MyGroupsTableViewCell.swift
//  VKApp
//
//  Created by Алексей Сигай on 28.01.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupPhoto: UIImageView!
    @IBOutlet weak var groupName: UILabel!

    override func awakeFromNib() {
        groupPhoto.translatesAutoresizingMaskIntoConstraints = false
        groupName.translatesAutoresizingMaskIntoConstraints = false
        super.awakeFromNib()
    }
    
    func makeFrame() {
        groupPhoto.frame = GetFrameBasic.photo()
        groupName.frame = GetFrameBasic.name(bounds: bounds)
    }
    
}
