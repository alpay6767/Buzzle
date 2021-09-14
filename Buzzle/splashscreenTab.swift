//
//  splashscreenTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 25.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import RevealingSplashView


class splashsreenTab: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "buzzle_schrift")!, iconInitialSize: CGSize(width: 252, height: 147), backgroundColor: #colorLiteral(red: 0.1134431671, green: 0.1134431671, blue: 0.1134431671, alpha: 1))

        revealingSplashView.heartAttack = true
        revealingSplashView.animationType = SplashAnimationType.woobleAndZoomOut
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)

        //Starts animation
        revealingSplashView.startAnimation(){
            
            let defaults = UserDefaults.standard
            let loggedIn = defaults.bool(forKey: "LoggedIn")
            
            
            if(loggedIn) {
                MainMenuTab.currentUser = AppDelegate.getUserFromDefaults()
                MainMenuTab.currentUser?.loadBlockedUser()
                MainMenuTab.currentUser?.loadLickedPosts()
                let pmanager = NotificationManager()
                pmanager.updateFBToken(user: MainMenuTab
                                        .currentUser!)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "navvcc")
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: true, completion: nil)
            } else {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "logintab") as! loginTab
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: true, completion: nil)
                
            }
            
        }

    }
    
    
}
