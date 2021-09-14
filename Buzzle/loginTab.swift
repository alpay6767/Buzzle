//
//  loginTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 13.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import UIKit
import PMAlertController
import FirebaseDatabase
import NVActivityIndicatorView
import BLTNBoard

class loginTab: UIViewController {
    @IBOutlet weak var username_eingabe: UITextField!
    
    @IBOutlet weak var passwordlabel: UILabel!
    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var password_eingabe: UITextField!
    
    @IBOutlet weak var skipbtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var ladebalken: NVActivityIndicatorView!
    @IBOutlet weak var noaccountbtn: UIButton!
    
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
        
        
        
    }
    
    fileprivate func skiplogin() {
        if AppDelegate.sperre {
            
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "We are working!", description: "This app is currently down! We are making improvments!", buttontext: "Nice", imagename: "o10"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            
            let user = Player(username: "notloggedin")
            MainMenuTab.currentUser = user
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "navvcc")
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func skip(_ sender: Any) {
        
        vibratePhone()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations:  {
            
            self.logo.transform = CGAffineTransform(translationX: 0, y: -40)
            self.username_eingabe.transform = CGAffineTransform(translationX: 0, y: 60)
            self.password_eingabe.transform = CGAffineTransform(translationX: 0, y: 60)
            self.loginbtn.transform = CGAffineTransform(translationX: 0, y: 60)
            self.usernamelabel.transform = CGAffineTransform(translationX: 0, y: 60)
            self.passwordlabel.transform = CGAffineTransform(translationX: 0, y: 60)
            
            
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations:  {
                
                self.logo.transform = CGAffineTransform(translationX: 0, y: 40)
                
                
                
            }) { (_) in
                
                
                self.skiplogin()
                
            }
        }
 
 

    }
    
    fileprivate func loginlogin() {
        ladebalken.startAnimating()
        checkLogin(username: username_eingabe.text!, password: password_eingabe.text!)
    }
    
    @IBAction func login(_ sender: Any) {
        vibratePhone()
        if username_eingabe.text!.isEmpty || password_eingabe.text!.isEmpty || AppDelegate.sperre{
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Login failed!", description: "Some informations are wrong!", buttontext: "Okeyy :(", imagename: "o2"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations:  {
                
                self.logo.transform = CGAffineTransform(translationX: 0, y: -40)
                self.username_eingabe.transform = CGAffineTransform(translationX: 0, y: 60)
                self.password_eingabe.transform = CGAffineTransform(translationX: 0, y: 60)
                self.loginbtn.transform = CGAffineTransform(translationX: 0, y: 60)
                self.usernamelabel.transform = CGAffineTransform(translationX: 0, y: 60)
                self.passwordlabel.transform = CGAffineTransform(translationX: 0, y: 60)
                
                
                
            }) { (_) in
                
                self.loginlogin()
            }
            
        }
    }
    
    func checkLogin(username: String, password: String) {
        
        fbhandler.checkUserCredentials(username: username, password: password) { authentificated,foundUser  in
             guard let authentificated = authentificated else { return }
            guard let foundUser = foundUser else {return}
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations:  {
                
                
                self.logo.transform = CGAffineTransform(translationX: 0, y: 0)
                self.username_eingabe.transform = CGAffineTransform(translationX: 0, y: 0)
                self.password_eingabe.transform = CGAffineTransform(translationX: 0, y: 0)
                self.loginbtn.transform = CGAffineTransform(translationX: 0, y: 0)
                self.usernamelabel.transform = CGAffineTransform(translationX: 0, y: 0)
                self.passwordlabel.transform = CGAffineTransform(translationX: 0, y: 0)
                
                
            }) { (_) in
                
                if (authentificated) {
                    
                    self.fbhandler.saveUserToDefaults(user: foundUser)
                    
                    
                    
                    MainMenuTab.currentUser = foundUser
                    MainMenuTab.currentUser?.loadBlockedUser()
                    MainMenuTab.currentUser?.loadLickedPosts()
                    let pmanager = NotificationManager()
                    pmanager.updateFBToken(user: MainMenuTab
                                            .currentUser!)
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "navvcc")
                    newViewController.modalPresentationStyle = .fullScreen
                    self.present(newViewController, animated: true, completion: nil)
                    
                    
                    
                    
                    
                    /*MainMenuTab.currentUser = foundUser
                    let pmanager = NotificationManager()
                    pmanager.updateFBToken(user: MainMenuTab.currentUser!)
                    MainMenuTab.currentUser?.loadBlockedUser()
                    MainMenuTab.currentUser?.loadLickedPosts()
                    print("Blocked: " + MainMenuTab.currentUser!.blockedList.description)
                    
                    let mainvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainmenutab")
                    mainvc.modalPresentationStyle = .fullScreen
                    self.present(mainvc, animated: true) {}
                    
                    print("Eingeloggt: " + foundUser.username!)
 */
                } else {
                    self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Login didn't work", description: "Please check your entries!", buttontext: "Okayy", imagename: "o5"))
                    self.bulletinManager.showBulletin(above: self)
                }
                self.ladebalken.stopAnimating()
            }
        }
    }
}
