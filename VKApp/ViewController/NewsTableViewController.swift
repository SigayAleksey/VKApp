//
//  NewsTableViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 25.03.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTableViewController: UITableViewController, CellHeightDelegate {

    var news = [New]()
    var token: NotificationToken?
    var refresher: UIRefreshControl!
    var cellHeight: CGFloat?
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshData()
        GetNews.get(count: 50) { [weak self] news in
            self?.news = news
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeight else { return 80 }
        return height
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.news, for: indexPath) as! NewsTableViewCell
        
        // CellHeightDelegate
        cell.delegate = self
        
        cell.newText.text = news[indexPath.row].text
        cell.commentCount = news[indexPath.row].comments.count
        cell.likeCount = news[indexPath.row].likes.count
        cell.repostCount = news[indexPath.row].reposts.count
        cell.viewCount = news[indexPath.row].views!.count
        cell.photoWidth = CGFloat(news[indexPath.row].attachments![0].photo!.width)
        cell.photoHeight = CGFloat(news[indexPath.row].attachments![0].photo!.height)
        // Запрос изображения и вставка в UIImageView
        var imageURL: URL
        if news[indexPath.row].attachments![0].photo!.photo_604 != nil {
             imageURL = URL(string: (news[indexPath.row].attachments![0].photo!.photo_604!))!
        } else {
            imageURL = URL(string: (news[indexPath.row].attachments![0].photo!.photo_130))!
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let data = try? Data(contentsOf: imageURL)
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.newPhoto.image = image
                }
            }
        }
        return cell
    }
    
    @objc func showNewData() {
        GetNews.get(count: 50) { [weak self] news in
            self?.news = news
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        refresher.endRefreshing()
    }
    
    // CellHeightDelegate
    func setCellHeight(height: CGFloat) {
        self.cellHeight = height + 20
    }
    
    func refreshData() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: Constant.refreshData)
        refresher.addTarget(self, action: #selector(NewsTableViewController.showNewData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    
    // MARK: - LogOff
    
    @IBAction func logOff(_ sender: Any) {
        AuthorizationViewController.logOff(self)
        self.dismiss(animated: true, completion: nil)
    }
    
}
