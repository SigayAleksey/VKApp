//
//  AllGroupsTableViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 28.01.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit
import RealmSwift

class AllGroupsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    
    var allGroups: Results<GroupFilter>?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return allGroups!.count
        } else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.allGroups, for: indexPath) as! AllGroupsTableViewCell
        cell.groupName.text = allGroups![indexPath.row].name
        // Запрос изображения и вставка в UIImageView
        let imageURL = URL(string: allGroups![indexPath.row].photo_50)!
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            self.view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            GetAllGroups.get(text: { return searchBar.text! }())
            allGroups = GetAllGroups.getDataRealm()
            tableView.reloadData()
        }
    }

}
