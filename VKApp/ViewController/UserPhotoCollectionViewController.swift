//
//  UserPhotoCollectionViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 27.02.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit

class UserPhotoCollectionViewController: UICollectionViewController {
    
    var userID: Int?
    var userPhoto: Photo?
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 150, height: 150)
        
        refreshData()
        showNewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.userPhoto, for: indexPath) as! UserPhotoCollectionViewCell
        
        if self.userPhoto != nil {
            // Запрос изображения и вставка в UIImageView
            let imageURL = URL(string: (self.userPhoto?.photo_100)!)!
            let data = try? Data(contentsOf: imageURL)
            if let data = data {
                let image = UIImage(data: data)
                cell.userPhoto.image = image
            }
        }
        return cell
    }
    
    @objc func showNewData() {
        GetUserPhoto.get(userID: self.userID!) { [weak self] userPhotoGet in
            self?.userPhoto = userPhotoGet
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        refresher.endRefreshing()
    }
    
    func refreshData() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: Constant.refreshData)
        refresher.addTarget(self, action: #selector(UserPhotoCollectionViewController.showNewData), for: UIControl.Event.valueChanged)
        self.collectionView!.addSubview(refresher)
    }
    
}
