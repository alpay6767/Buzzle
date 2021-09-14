//
//  eulaTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 28.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit


class eulaTab: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func accept(_ sender: Any) {
        vibratePhone()
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "eula")
        dismiss(animated: true) {
            
        }
    }
    
    @IBAction func decline(_ sender: Any) {
        vibratePhone()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "eula")
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "logintab")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
}
