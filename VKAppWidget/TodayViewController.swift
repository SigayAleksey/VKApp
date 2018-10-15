//
//  TodayViewController.swift
//  VKAppWidget
//
//  Created by Алексей Сигай on 26.05.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
//    var news = [New]()
    
    @IBOutlet weak var greeting: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greeting.text = "Hi"

        
//        GetNewsWidget.get() { [weak self] news in
//            self?.news = news
////            DispatchQueue.main.async {
////                self?.tableView.reloadData()
////            }
//            print(news)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
