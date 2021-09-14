//
//  profileTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 24.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import PMAlertController
import AZDialogView
import BLTNBoard
import SideMenu

class profileTab: UIViewController {
    
    @IBOutlet weak var morebtn: UIButton!
    @IBOutlet weak var pc: UILabel!
    @IBOutlet weak var xbox: UILabel!
    @IBOutlet weak var psn: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pbild: UIImageView!
    var currentPlayer: Player?
    
    let fbhandler = FBHandler()
    
    var menu: SideMenuNavigationController?

    
    lazy var bulletinManager: BLTNItemManager = {

        let page = BLTNPageItem(title: "Profile reported!")
        page.image = UIImage(named: "o3")

        page.descriptionText = currentPlayer!.username! + " reported!"
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
        level.text = currentPlayer?.level?.description
        name.text = currentPlayer?.username
        let url = URL(string: (currentPlayer?.profilbildurl)!)
        pbild.kf.setImage(with: url)
        pbild.layer.cornerRadius = pbild.bounds.width/2
        pbild.clipsToBounds = true
        //pbild.layer.borderWidth = 3
        //pbild.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        getAccountNames()
        
        
        if (currentPlayer?.username == MainMenuTab.currentUser?.username) {
            morebtn.isHidden = true
        } else {
            morebtn.isHidden = false
        }
        
        
        menu = SideMenuManager.default.leftMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
    }
    
    
    @IBAction func showmore(_ sender: Any) {
        vibratePhone()
        if MainMenuTab.currentUser?.username == "notloggedin" {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            showMore()
        }
    }
    
    
    func showFailedOpenMoreDialog() {
        let dialog = AZDialogViewController(title: "You have to log in first!", message: "Please register yourself for free")
        dialog.titleColor = .black
        dialog.messageColor = .black
        dialog.alertBackgroundColor = .white
        dialog.dismissDirection = .bottom
        dialog.dismissWithOutsideTouch = true
        dialog.showSeparator = true
        dialog.rubberEnabled = true
        dialog.blurBackground = false
        dialog.blurEffectStyle = .light
        dialog.show(in: self)
    }
    
    func getAccountNames() {
        
        psn.text = AccountToString(accountname: (currentPlayer?.psn)!)
        xbox.text = AccountToString(accountname: (currentPlayer?.xbox)!)
        pc.text = AccountToString(accountname: (currentPlayer?.pc)!)
        
    }
    
    func AccountToString(accountname: String) -> String {
        
        switch accountname {
        case "":
            return "/"
            break
        default:
            return accountname
        }
        
    }
    
    func showMore() {
        
        let alertVC = PMAlertController(title: "More", description: "Choose to report or block a person so you dont have to see their stuff", image: UIImage(named: "personalidlogo"), style: .alert)
        
        alertVC.alertTitle.textColor = #colorLiteral(red: 0.04610475525, green: 0.04610475525, blue: 0.04610475525, alpha: 1)
        alertVC.dismissWithBackgroudTouch = true
        alertVC.gravityDismissAnimation = true
        
        if (MainMenuTab.currentUser!.hasBlockedUser(playerid: (currentPlayer?.id)!)) {
            alertVC.addAction(PMAlertAction(title: "Unblock", style: .default, action: { () in
                //entblockieren
                MainMenuTab.currentUser!.unblockUser(playerid: (self.currentPlayer?.id)!)
                let presentvc = self.presentingViewController as? MainMenuTab
                presentvc?.loadPosts()
                
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Unblocked", description: "U have unblocked this user!", buttontext: "Nice", imagename: "o2"))
                self.bulletinManager.showBulletin(above: self)
            }))
        } else {
        
            alertVC.addAction(PMAlertAction(title: "Block", style: .default, action: { () in
                //blockieren
                MainMenuTab.currentUser!.blockUser(playerid: (self.currentPlayer?.id)!)
                let presentvc = self.presentingViewController as? MainMenuTab
                presentvc?.loadPosts()
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Blocked", description: "U have blocked this user!", buttontext: "Nice", imagename: "o6"))
                self.bulletinManager.showBulletin(above: self)
            }))
        }
        
        alertVC.addAction(PMAlertAction(title: "Report", style: .default, action: { () in
            //melden
            self.fbhandler.meldeUser(playerid: (self.currentPlayer?.id)!)
            
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Reported", description: "U have reported this user!", buttontext: "Nice", imagename: "o1"))
            self.bulletinManager.showBulletin(above: self)
            
        }))
        

        self.present(alertVC, animated: true, completion: nil)

        
    }
    
    
    
}

extension UIViewController {
    
    func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
            guard let url = URL.init(string: urlString) else {
                return  imageCompletionHandler(nil)
            }
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    imageCompletionHandler(value.image)
                case .failure:
                    imageCompletionHandler(nil)
                }
            }
        }
    
    func createNewMeldung(title: String, description: String, buttontext: String, imagename: String) -> BLTNItem {
        vibratePhone()
        let page = BLTNPageItem(title: title)
        page.image = UIImage(named: imagename)

        page.descriptionText = description
        page.actionButtonTitle = buttontext
        page.actionHandler = { (item: BLTNActionItem) in
            self.vibratePhone()
            item.manager?.dismissBulletin(animated: true)
        }
        let rootItem: BLTNItem = page
    
        return rootItem
    }
}
