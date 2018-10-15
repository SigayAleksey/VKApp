//
//  MyFriendsTableViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 28.01.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class MyFriendsTableViewController: UITableViewController, GADBannerViewDelegate {
    
    var myFriends: Results<User>?
    var token: NotificationToken?
    var userID: Int?
    var refresher: UIRefreshControl!
    var bannerView: GADBannerView!
    var bannerViewTimer = Timer()
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshData()
        myFriends = GetFriends.getDataRealm()
        
        // BannerView
        bannerView = BannerAds.addBannerViewToView(viewController: self)
        bannerView.delegate = self
        startTimerBannerView()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends!.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.myFriends, for: indexPath) as! MyFriendsTableViewCell
        cell.userName.text = myFriends![indexPath.row].first_name + " " + myFriends![indexPath.row].last_name
        // Запрос изображения и вставка в UIImageView
        let imageURL = URL(string: myFriends![indexPath.row].photo_50)!
        DispatchQueue.global(qos: .userInteractive).async {
            let data = try? Data(contentsOf: imageURL)
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.userPhoto.image = image
                }
            }
        }
        return cell
    }
    
    @objc func showNewData() {
        GetFriends.get()
        
        guard let realm = try? Realm() else { return }
        myFriends = realm.objects(User.self)
        // Монитор изменений базы
        token = myFriends!.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        }
        
        refresher.endRefreshing()
    }
    
    func refreshData() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: Constant.refreshData)
        refresher.addTarget(self, action: #selector(MyFriendsTableViewController.showNewData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    
    // Remove BannerView
    private func startTimerBannerView() {
        bannerViewTimer.invalidate()
        bannerViewTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(removeBannerView), userInfo: nil, repeats: false)
    }
    @objc func removeBannerView() {
        bannerView.removeFromSuperview()
    }
    
    // MARK: - Data to UserPhotoCollectionViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserPhotoCollectionViewController {
            userID = myFriends![(tableView.indexPathForSelectedRow?.row)!].id
            destination.userID = self.userID
        }
    }
    
    // MARK: - LogOff

    @IBAction func logOff(_ sender: Any) {
        AuthorizationViewController.logOff(self)
        self.dismiss(animated: true, completion: nil)
    }
    
}
