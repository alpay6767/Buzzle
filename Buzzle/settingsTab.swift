
//
//  settingsTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 13.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


class settingsTab: UIViewController {
    
    @IBOutlet weak var resetbtn: UIButton!
    @IBOutlet weak var profile_layout: UIView!
    @IBOutlet weak var logout_layout: UIView!
    
    
    let fbhandler = FBHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        if MainMenuTab.currentUser?.username == "Alpay" {
            resetbtn.isHidden = false
        } else {
            resetbtn.isHidden = true
        }
        let profile = UITapGestureRecognizer(target: self, action:  #selector(self.openprofile(sender:)))
        self.profile_layout.addGestureRecognizer(profile)
        let logout = UITapGestureRecognizer(target: self, action:  #selector(self.logoutt(sender:)))
        self.logout_layout.addGestureRecognizer(logout)

        
    }
    
    //Actions for ClickListeners:
    @IBAction func resetall(_ sender: Any) {
        vibratePhone()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        fbhandler.deleteAll() { fertig in
             guard let fertig = fertig else { return }
            
            
        }
    }
    
    @objc func openprofile(sender : UITapGestureRecognizer) {
        vibratePhone()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "editprofiletab") as! editprofileTab
        self.present(newViewController, animated: true, completion: nil)
    }
    @objc func logoutt(sender : UITapGestureRecognizer) {
        vibratePhone()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "LoggedIn")
        defaults.set("//", forKey: "token")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("User").child((MainMenuTab.currentUser?.id!)!).child("token").setValue("//")
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "logintab")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
        
    }
    
    
    
}

