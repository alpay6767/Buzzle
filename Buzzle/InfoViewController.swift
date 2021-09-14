//
//  InfoViewController.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 15.08.21.
//  Copyright © 2021 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import BLTNBoard

class InfoViewController: UIViewController {
    
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = SideMenuManager.default.leftMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)

        
        
    }
    @IBAction func openmenu(_ sender: Any) {
        menu = SideMenuManager.default.leftMenuNavigationController
        self.present(menu!, animated: true) {
            
        }
    }
    @IBAction func visitinsta(_ sender: Any) {
        vibratePhone()
        let Username =  "alpaykuccuk" // Your Instagram Username here
            let appURL = URL(string: "instagram://user?username=\(Username)")!
            let application = UIApplication.shared

            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: "https://instagram.com/\(Username)")!
                application.open(webURL)
            }
    }
    @IBAction func visittiktok(_ sender: Any) {
        vibratePhone()
        let Username =  "mrrobotzz" // Your Instagram Username here
        //https://www.tiktok.com/@mrrobotzz
            let application = UIApplication.shared
        //https://www.tiktok.com/@(username)
            let webURL = URL(string: "https://www.tiktok.com/@\(Username)")!
            application.open(webURL)
    }
    
}
