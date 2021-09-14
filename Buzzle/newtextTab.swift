//
//  newspotTab.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 21.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import GrowingTextView
import PMAlertController
import FirebaseDatabase
import ChameleonFramework
import BLTNBoard


class newtextTab: UIViewController, GrowingTextViewDelegate {
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var spottext: GrowingTextView!
    @IBOutlet weak var postbtn: UIButton!
    
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
    
    var selectedView: selectedViews?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        spottext.placeholderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spottext.textAlignment = .center
        spottext.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        spottext.font = UIFont.systemFont(ofSize: 20)
        
        
        switch selectedView {
        case .world:
            text.text = "What do you want to say?"
            spottext.placeholder = "This is my message to the world!"
        case .gruppen:
            text.text = "What is the name of the group?"
            spottext.placeholder = "Name of the new group"
        default:
            print("ERROR")
        }
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
           UIView.animate(withDuration: 0.2) {
               self.view.layoutIfNeeded()
           }
        }
    @IBAction func cancle(_ sender: Any) {
        vibratePhone()
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func post(_ sender: Any) {
        vibratePhone()
        if (spottext.text == "") {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. text is missing!", description: "Please write a text to post it!", buttontext: "Okayy", imagename: "o6"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            
            switch selectedView {
            case .world:
                let currentspotpost = Spotting(id: "", userid: (MainMenuTab.currentUser?.id!)!, username: (MainMenuTab.currentUser?.username!)!, likes: 0, spottingtext: spottext.text, type: "text")
                
                let vc = presentingViewController as? UINavigationController
                let containervc = vc?.viewControllers[0]
                let mainmenuvc = containervc?.children[0] as! MainMenuTab
                mainmenuvc.exportSpotting(currentspotting: currentspotpost)
                
                self.presentingViewController?.dismiss(animated: true, completion: {
                        
                })
            case .gruppen:
                let color = RandomFlatColor().rgb()

                let currentnewgroup = Gruppe(id: "", name: spottext.text!, farbe: color!)
                self.saveGruppeInDB(gruppe: currentnewgroup)
            default:
                print("ERROR")
            }
            
            
            
            
        }
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
