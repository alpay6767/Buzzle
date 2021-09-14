//
//  TransatorEndVC.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 15.08.21.
//  Copyright © 2021 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class TransatorEndVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func go(_ sender: Any) {
        vibratePhone()
        MainMenuTab.currentUser?.loadBlockedUser()
        MainMenuTab.currentUser?.loadLickedPosts()
        let pmanager = NotificationManager()
        pmanager.updateFBToken(user: MainMenuTab
                                .currentUser!)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "navvcc")
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
}
