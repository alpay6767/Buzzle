//
//  mapDetailsTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 01.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class MapDetailsTab: UIViewController {
    @IBOutlet weak var beschreibung: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bild: UIImageView!
    
    static var currentMap = Map()
    
    var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-7177574010293341/4240801914"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        name.text = MapDetailsTab.currentMap.name
        bild.image = MapDetailsTab.currentMap.bild
        beschreibung.text = MapDetailsTab.currentMap.beschreibung
    }
    
    @IBAction func open_maplayout(_ sender: Any) {
        vibratePhone()
        layoutTab.art = "maplayout"
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "layouttab") as! layoutTab
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func openeroberung(_ sender: Any) {
        vibratePhone()
        layoutTab.art = "eroberung"
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "layouttab") as! layoutTab
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func openhardpoint(_ sender: Any) {
        vibratePhone()
        layoutTab.art = "hardpoint"
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "layouttab") as! layoutTab
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
