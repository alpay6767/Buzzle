//
//  registerTab.swift
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
import BLTNBoard

class registerTab: UIViewController {
    
    @IBOutlet weak var photo_layout: UIView!
    @IBOutlet weak var name_layout: UIView!
    @IBOutlet weak var password_layout: UIView!
    @IBOutlet weak var rang_layout: UIView!
    
    @IBOutlet weak var ladebalken: NVActivityIndicatorView!
    @IBOutlet weak var nametxt: UILabel!
    @IBOutlet weak var passwordtxt: UILabel!
    @IBOutlet weak var rangtxt: UILabel!
    @IBOutlet weak var profilebild: UIImageView!
    var picker: YPImagePicker?
    
    let fbhandler = FBHandler()
    
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
        
        hideKeyboardWhenTappedAround()
        
        let name = UITapGestureRecognizer(target: self, action:  #selector(self.enterName(sender:)))
        self.name_layout.addGestureRecognizer(name)
        
        let rang = UITapGestureRecognizer(target: self, action:  #selector(self.enterRang(sender:)))
        self.rang_layout.addGestureRecognizer(rang)
        
        let password = UITapGestureRecognizer(target: self, action:  #selector(self.enterPassword(sender:)))
        self.password_layout.addGestureRecognizer(password)
        
        profilebild.layer.cornerRadius = profilebild.bounds.width/2
        profilebild.clipsToBounds = true
        confImagepicker()

        
    }
    
    //Actions for ClickListeners:
    
    @objc func enterName(sender : UITapGestureRecognizer) {
        vibratePhone()
        openTextFieldPicker(hint: "Name")
    }
    
    @objc func enterPassword(sender : UITapGestureRecognizer) {
        vibratePhone()
        openPasswordPicker(hint: "Password")
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
    
    
    func openTextFieldPicker(hint: String) {
        
        let alertVC = PMAlertController(title: "What is your name?", description: "", image: UIImage(named: "personalidlogo"), style: .alert)
        
        alertVC.alertTitle.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        alertVC.dismissWithBackgroudTouch = true
        alertVC.gravityDismissAnimation = true


        alertVC.addTextField { (textField) in
                    textField?.placeholder = hint
                }
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            self.nametxt.text = alertVC.textFields[0].text
        }))
        

        self.present(alertVC, animated: true, completion: nil)

        
    }
    
    func openPasswordPicker(hint: String) {
        
        let alertVC = PMAlertController(title: "What password do you want?", description: "", image: UIImage(named: "schlosslogo"), style: .alert)
        
        alertVC.alertTitle.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        alertVC.dismissWithBackgroudTouch = true
        alertVC.gravityDismissAnimation = true


        alertVC.addTextField { (textField) in
                    textField?.placeholder = hint
                }
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            self.passwordtxt.text = alertVC.textFields[0].text
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
    
    
    @IBAction func register(_ sender: Any) {
        vibratePhone()
        if (nametxt.text!.isEmpty || passwordtxt.text!.isEmpty || rangtxt.text!.isEmpty || profilebild.image?.description == UIImage(named: "placeholderpic")?.description) {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. some information is missing!", description: "Please fill in all fields to continue", buttontext: "Okayy", imagename: "o5"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            
            
            checkIfUsernameExists(username: nametxt.text!.lowercased())
            
            
        }
    }
    
    
    func checkIfUsernameExists(username: String) {
        
        self.ladebalken.startAnimating()

        
        fbhandler.checkIfUsernameExists(username: username) { found  in
            guard let found = found else { return }
            
            if (!found) {
                
                var currentNewUser = Player(id: "", username: self.nametxt.text!, password: self.passwordtxt.text!, level: Int(self.rangtxt.text!)!, profilbildurl: "", psn: "", xbox: "", pc: "", token: AppDelegate.instanceIDToken)
                currentNewUser.profilbild = self.profilebild.image
                
                self.saveUserInDB(player: currentNewUser)
            } else {
                self.ladebalken.stopAnimating()
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. This username already exists", description: "Please choose another username!", buttontext: "Okay", imagename: "o2"))
                self.bulletinManager.showBulletin(above: self)
            }
        
        }
    }
    
    
    
    
    //DB Methods:
    
    func saveUserInDB(player: Player) {

        var ref: DatabaseReference!
        ref = Database.database().reference()
        let newid = ref.child("User").childByAutoId().key
        
        player.id = newid
        
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
                "token" : AppDelegate.instanceIDToken
            ])
            
            self.fbhandler.saveUserToDefaults(user: player)
            let pushManager = NotificationManager()
            pushManager.registerForPushNotifications()
            pushManager.updateFBToken(user: player)
            self.ladebalken.stopAnimating()
            MainMenuTab.currentUser = player
            
            self.vibratePhone()
            let page = BLTNPageItem(title: "Successfully registered!")
            page.image = UIImage(named: "o1")

            page.descriptionText = "Welcome to our community"
            page.actionButtonTitle = "Enter Buzzle!"
            page.actionHandler = { (item: BLTNActionItem) in
                
                item.manager?.dismissBulletin(animated: true)

                self.vibratePhone()
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
            let rootItem: BLTNItem = page
            
            self.bulletinManager = BLTNItemManager(rootItem: rootItem)
            self.bulletinManager.showBulletin(above: self)
            
            
        }
        
    }
    
    
    
}


extension registerTab: NumberPickerDelegate {
    func selectedNumber(_ number: Int) {
        rangtxt.text = number.description
    }
}

