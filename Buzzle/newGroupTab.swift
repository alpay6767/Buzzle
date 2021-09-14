//
//  newgrouptab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 13.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Kingfisher
import ChameleonFramework
import PMAlertController
import BLTNBoard



class newGroupTab: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    
    lazy var bulletinManager: BLTNItemManager = {

        let page = BLTNPageItem(title: "Profile reported!")
        page.image = UIImage(named: "o3")

        page.descriptionText = " reported!"
        page.actionButtonTitle = "Nice!"
        page.actionHandler = { (item: BLTNActionItem) in
            self.vibratePhone()
            item.manager?.dismissBulletin(animated: true)
            
            
        }
        let rootItem: BLTNItem = page
        return BLTNItemManager(rootItem: rootItem)
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func cancle(_ sender: Any) {
        vibratePhone()
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func upload(_ sender: Any) {
        vibratePhone()
        if (name.text == "") {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. there are somet information missing", description: "Please fill in all fields!", buttontext: "Okeyy", imagename: "o2"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            
            let color = RandomFlatColorWithShade(shade: .light).lighten(byPercentage: 60).rgb()

            let currentnewgroup = Gruppe(id: "", name: name.text!, farbe: color!)
            self.saveGruppeInDB(gruppe: currentnewgroup)
        }
    }
    
    public func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


        }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveGruppeInDB(gruppe: Gruppe) {

        var ref: DatabaseReference!
        ref = Database.database().reference()
        let newid = ref.child("Gruppen").childByAutoId().key
        
        gruppe.id = newid
        
        /*fbhandler.uploadMedia(image: player.profilbild!, currentUser: player) { url in
             guard let url = url else { return }
            player.profilbildurl = url
            ref?.child("User").child(player.id!).setValue([
                "id" : player.id!,
                "username" : player.username!,
                "password" : player.password!,
                "level" : player.level,
                "profilbildurl" : url,
                "psn" : player.psn!,
                "xbox" : player.xbox!,
                "pc" : player.pc!
            ])
 
 */
        ref?.child("Gruppen").child(gruppe.id!).setValue([
            "id" : gruppe.id!,
            "name" : gruppe.name!,
            "farbe" : gruppe.farbe!
        ])
                    
            let vc = presentingViewController as? MainMenuTab
        vc?.loadGruppen()
        self.dismiss(animated: true) {
            
        }
            
        }
        
    
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
    
    func rgb() -> Int? {
            var fRed : CGFloat = 0
            var fGreen : CGFloat = 0
            var fBlue : CGFloat = 0
            var fAlpha: CGFloat = 0
            if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
                let iRed = Int(fRed * 255.0)
                let iGreen = Int(fGreen * 255.0)
                let iBlue = Int(fBlue * 255.0)
                let iAlpha = Int(fAlpha * 255.0)

                //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
                let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
                return rgb
            } else {
                // Could not extract RGBA components:
                return nil
            }
        }
    
    
    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {

            var currentHue: CGFloat = 0.0
            var currentSaturation: CGFloat = 0.0
            var currentBrigthness: CGFloat = 0.0
            var currentAlpha: CGFloat = 0.0

            if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha){
                return UIColor(hue: currentHue + hue,
                               saturation: currentSaturation + additionalSaturation,
                               brightness: currentBrigthness + additionalBrightness,
                               alpha: currentAlpha)
            } else {
                return self
            }
        }
    
    public func colorWithBrightness(brightness: CGFloat) -> UIColor {
            var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
            
            if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
                B += (brightness - 1.0)
                B = max(min(B, 1.0), 0.0)
                
                return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
            }
            
            return self
        }
}
