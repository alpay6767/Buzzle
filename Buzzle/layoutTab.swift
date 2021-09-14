//
//  layoutTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 03.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class layoutTab: UIViewController {
    
    
    @IBOutlet weak var bild: UIImageView!
    var bannerView: GADBannerView!
    
    static var art: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-7177574010293341/4240801914"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        switch layoutTab.art {
        case "eroberung":
            bild.image = MapDetailsTab.currentMap.eroberung_bild
            break
        case "maplayout":
            bild.image = MapDetailsTab.currentMap.maplayout_bild
            break
        case "hardpoint":
            bild.image = MapDetailsTab.currentMap.hardpoint_bild
            break
        default:
            break
        }
        
        
        
    }
    
}
