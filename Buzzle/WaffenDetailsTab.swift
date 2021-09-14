//
//  WaffenDetailsTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 30.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import JGProgressHUD
import YPImagePicker
import GoogleMobileAds

class WaffenDetailsTab: UIViewController{
    
    @IBOutlet weak var kontrolle_bar: UIProgressView!
    @IBOutlet weak var mobilität_bar: UIProgressView!
    @IBOutlet weak var feuerrate_bar: UIProgressView!
    @IBOutlet weak var reichweite_bar: UIProgressView!
    @IBOutlet weak var schaden_bar: UIProgressView!
    @IBOutlet weak var genauigkeit_bar: UIProgressView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bild: UIImageView!
    
    @IBOutlet weak var accuracy: UILabel!
    @IBOutlet weak var control: UILabel!
    @IBOutlet weak var mobility: UILabel!
    @IBOutlet weak var firerate: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var damage: UILabel!
    
    
    static var currentWaffe = Waffe()
    var selectedImage: UIImage?
    
    var bannerView: GADBannerView!
    
    
    static var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-7177574010293341/4240801914"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        name.text = WaffenDetailsTab.currentWaffe.name
        bild.image = WaffenDetailsTab.currentWaffe.bild
        let genauigkeit_f: Float = Float((WaffenDetailsTab.currentWaffe.genauigkeit)!) / 100
        genauigkeit_bar.setProgress(genauigkeit_f, animated: true)
        let schaden_f: Float = Float((WaffenDetailsTab.currentWaffe.schaden)!) / 100
        schaden_bar.setProgress(schaden_f, animated: true)
        let reichweite_f: Float = Float((WaffenDetailsTab.currentWaffe.reichweite)!) / 100
        reichweite_bar.setProgress(reichweite_f, animated: true)
        let feuerrate_f: Float = Float((WaffenDetailsTab.currentWaffe.feuerrate)!) / 100
        feuerrate_bar.setProgress(feuerrate_f, animated: true)
        let mobility_f: Float = Float((WaffenDetailsTab.currentWaffe.mobilität)!) / 100
        mobilität_bar.setProgress(mobility_f, animated: true)
        let kontrolle: Float = Float((WaffenDetailsTab.currentWaffe.kontrolle)!) / 100
        kontrolle_bar.setProgress(kontrolle, animated: true)
        
        accuracy.text = accuracy.text! + " (" + Int(genauigkeit_f*100).description + "%)"
        damage.text = damage.text! + " (" + Int(schaden_f*100).description + "%)"
        range.text = range.text! + " (" + Int(reichweite_f*100).description + "%)"
        firerate.text = firerate.text! + " (" + Int(feuerrate_f*100).description + "%)"
        mobility.text = mobility.text! + " (" + Int(mobility_f*100).description + "%)"
        control.text = control.text! + " (" + Int(kontrolle*100).description + "%)"
        
    }
}

