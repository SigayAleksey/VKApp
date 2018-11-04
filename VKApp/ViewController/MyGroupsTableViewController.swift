//
//  MyGroupsTableViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 28.01.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit
import RealmSwift
import VK_ios_sdk
import FirebaseDatabase

class MyGroupsTableViewController: UITableViewController {
    
    var userID: Int!
    var myGroups: Results<Group>?
    var token: NotificationToken?
    var refresher: UIRefreshControl!
    
    deinit {
        token?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshData()
        if AuthorizationViewController.userDefaults.bool(forKey: Constant.Key.firstDisplayGroups) == true {
            showNewData()
            AuthorizationViewController.userDefaults.set(false, forKey: Constant.Key.firstDisplayGroups)
        }
        myGroups = GetGroups.getDataRealm()
        userID = Int(AuthorizationViewController.getUserId())
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups!.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.myGroups, for: indexPath) as! MyGroupsTableViewCell
        cell.groupName.text = myGroups![indexPath.row].name
        // Запрос изображения и вставка в UIImageView
        let imageURL = URL(string: myGroups![indexPath.row].photo_50)!
        DispatchQueue.global(qos: .userInteractive).async {
            let data = try? Data(contentsOf: imageURL)
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.groupPhoto.image = image
                }
            }
        }
        return cell
    }
    
    @objc func showNewData() {
        GetGroups.get()
        guard let realm = try? Realm() else { return }
        myGroups = realm.objects(Group.self)
        // Монитор изменений базы
        token = myGroups!.observe { [weak self] (changes: RealmCollectionChange) in
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
        refresher.addTarget(self, action: #selector(MyGroupsTableViewController.showNewData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    
    // MARK: - Add new Group
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == Constant.Segue.addGroup {
            let AllGroupController = segue.source as! AllGroupsTableViewController
            if let indexPath = AllGroupController.tableView.indexPathForSelectedRow {
                let groupID = AllGroupController.allGroups![indexPath.row].id

                var groupСontained = false
                myGroups!.forEach { group in
                    if group.id == groupID {
                        groupСontained = true
                        return
                    }
                }
                if !groupСontained {
                    AddGroup.add(groupID: groupID)
                     let userModelFB = FBUser(user: userID, groups: [
                        FBGroup(group: groupID)
                    ])
                    let data = [userModelFB].map { $0.toAny }
                    Database.database().reference().child("VKApp").setValue(data)
                }
            }
        }
    }
    
    // MARK: - LogOff
    
    @IBAction func logOff(_ sender: Any) {
        AuthorizationViewController.logOff(self)
        self.dismiss(animated: true, completion: nil)
    }

}
