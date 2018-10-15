//
//  BannerAds.swift
//  VKApp
//
//  Created by Алексей Сигай on 20.09.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import Foundation
import GoogleMobileAds

class BannerAds: UIViewController, GADBannerViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GADMobileAds.configure(withApplicationID: Constant.adMobID)
    }
    
    static func addBannerViewToView(viewController: UIViewController) -> GADBannerView {
        var bannerView: GADBannerView!
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        // bannerView.layer
        viewController.view.addSubview(bannerView)
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let bannerX = screenWidth/2 - 320/2
        let bannerY = screenHeight - 170
        let origin = CGPoint(x: bannerX, y: bannerY)
        let size = CGSize(width: 320, height: 50)
        bannerView.frame = CGRect(origin: origin, size: size)
        
        bannerView.adUnitID = Constant.adMobID
        bannerView.rootViewController = viewController
        bannerView.load(GADRequest())

        return bannerView
    }
    
}
