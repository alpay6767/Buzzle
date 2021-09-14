
//
//  editprofileTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 13.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import NumberPicker
import YPImagePicker
import NVActivityIndicatorView
import FirebaseDatabase
import PMAlertController
import SideMenu
import BLTNBoard



class editprofileTab: UIViewController {
    
    @IBOutlet weak var xbox_layout: UIView!
    @IBOutlet weak var photo_layout: UIView!
    @IBOutlet weak var psn_layout: UIView!
    @IBOutlet weak var rang_layout: UIView!
    @IBOutlet weak var pc_layout: UIView!
    
    @IBOutlet weak var ladebalken: NVActivityIndicatorView!
    
    @IBOutlet weak var pctxt: UILabel!
    @IBOutlet weak var xboxtxt: UILabel!
    @IBOutlet weak var psntxt: UILabel!
    @IBOutlet weak var rangtxt: UILabel!
    @IBOutlet weak var profilebild: UIImageView!
    var picker: YPImagePicker?
    
    let fbhandler = FBHandler()
    
    var menu: SideMenuNavigationController?
    
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
        
        let user = MainMenuTab.currentUser
        let url = URL(string: (MainMenuTab.currentUser?.profilbildurl)!)
        profilebild.kf.setImage(with: url)
        psntxt.text = MainMenuTab.currentUser?.psn
        pctxt.text = MainMenuTab.currentUser?.pc
        xboxtxt.text = MainMenuTab.currentUser?.xbox
        rangtxt.text = MainMenuTab.currentUser?.level?.description
        
        
        hideKeyboardWhenTappedAround()
        
        let psn = UITapGestureRecognizer(target: self, action:  #selector(self.enterpsn(sender:)))
        self.psn_layout.addGestureRecognizer(psn)
        let xbox = UITapGestureRecognizer(target: self, action:  #selector(self.enterxbox(sender:)))
        self.xbox_layout.addGestureRecognizer(xbox)
        let pc = UITapGestureRecognizer(target: self, action:  #selector(self.enterpc(sender:)))
        self.pc_layout.addGestureRecognizer(pc)
        
        let rang = UITapGestureRecognizer(target: self, action:  #selector(self.enterRang(sender:)))
        self.rang_layout.addGestureRecognizer(rang)
        
        profilebild.layer.cornerRadius = profilebild.bounds.width/2
        profilebild.clipsToBounds = true
        confImagepicker()

        
        menu = SideMenuManager.default.leftMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
        
    }
    
    @IBAction func openmenu(_ sender: Any) {
        menu = SideMenuManager.default.leftMenuNavigationController
        self.present(menu!, animated: true) {
            
        }
    }
    //Actions for ClickListeners:
    
    @objc func enterpsn(sender : UITapGestureRecognizer) {
        vibratePhone()
           openpsntextpicker(hint: "PSN name")
       }
    @objc func enterxbox(sender : UITapGestureRecognizer) {
        vibratePhone()
           openxboxtextpicker(hint: "XBOX name")
       }
    @objc func enterpc(sender : UITapGestureRecognizer) {
        vibratePhone()
           openpctextpicker(hint: "PC name")
       }
    
    @objc func enterRang(sender : UITapGestureRecognizer) {
        vibratePhone()
        openRangPicker()
    }
    
    func openRangPicker() {
        let numberPicker = NumberPicker(delegate: self, maxNumber: 155) // set max number
        numberPicker.bgGradients = [#colorLiteral(red: 0.08178366721, green: 0.08178366721, blue: 0.08178366721, alpha: 1), #colorLiteral(red: 0.07999999821, green: 0.07999999821, blue: 0.07999999821, alpha: 1)]
        numberPicker.tintColor = .white
        numberPicker.heading = "Rang"
        if rangtxt.text!.isEmpty {
            numberPicker.defaultSelectedNumber = 20        }
        else {
            numberPicker.defaultSelectedNumber = Int(rangtxt.text!)!
        }

        self.present(numberPicker, animated: true, completion: nil)
    }
    
    
    func openpsntextpicker(hint: String) {
        
        let alertVC = PMAlertController(title: "What is your psn name?", description: "", image: #imageLiteral(resourceName: "psnlogo"), style: .alert)
        
        alertVC.alertTitle.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        alertVC.dismissWithBackgroudTouch = true
        alertVC.gravityDismissAnimation = true


        alertVC.addTextField { (textField) in
                    textField?.placeholder = hint
                }
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            self.psntxt.text = alertVC.textFields[0].text
        }))
        

        self.present(alertVC, animated: true, completion: nil)

        
    }
    
    func openxboxtextpicker(hint: String) {
        
        let alertVC = PMAlertController(title: "What is your xbox name?", description: "", image: #imageLiteral(resourceName: "xboxlogo"), style: .alert)
        
        alertVC.alertTitle.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        alertVC.dismissWithBackgroudTouch = true
        alertVC.gravityDismissAnimation = true


        alertVC.addTextField { (textField) in
                    textField?.placeholder = hint
                }
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            self.xboxtxt.text = alertVC.textFields[0].text
        }))
        

        self.present(alertVC, animated: true, completion: nil)

        
    }
    
    func openpctextpicker(hint: String) {
        
        let alertVC = PMAlertController(title: "What is your pc name?", description: "", image: #imageLiteral(resourceName: "pclogo"), style: .alert)
        
        alertVC.alertTitle.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        alertVC.dismissWithBackgroudTouch = true
        alertVC.gravityDismissAnimation = true


        alertVC.addTextField { (textField) in
                    textField?.placeholder = hint
                }
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            self.pctxt.text = alertVC.textFields[0].text
        }))
        

        self.present(alertVC, animated: true, completion: nil)

        
    }

    
    @IBAction func changepic(_ sender: Any) {
        vibratePhone()
        present(picker!, animated: true, completion: nil)
    }
    
    func confImagepicker() {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = true
        config.library.mediaType = YPlibraryMediaType.photo
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.maxCameraZoomFactor = 1.0
        picker = YPImagePicker(configuration: config)
        
        picker!.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.profilebild.image = photo.image
            }
            picker!.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        vibratePhone()
        self.ladebalken.startAnimating()
        
        MainMenuTab.currentUser?.level = Int(rangtxt.text!)
        MainMenuTab.currentUser?.psn = psntxt.text!
        MainMenuTab.currentUser?.xbox = xboxtxt.text!
        MainMenuTab.currentUser?.pc = pctxt.text!
        MainMenuTab.currentUser?.profilbild = self.profilebild.image
        
        self.saveUserInDB(player: MainMenuTab.currentUser!)
        
    }

    
    
    
    //DB Methods:
    
    func saveUserInDB(player: Player) {

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        fbhandler.uploadMedia(image: player.profilbild!, currentUser: player) { url in
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
                "pc" : player.pc!,
                "token" : player.token!
            ])
            
            self.fbhandler.saveUserToDefaults(user: player)
            
            self.ladebalken.stopAnimating()
            
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Profile updated!", description: "All changes were saved!", buttontext: "Nice", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
            
        }
        
    }
    

    
}


extension editprofileTab: NumberPickerDelegate {
    func selectedNumber(_ number: Int) {
        rangtxt.text = number.description
    }
}

