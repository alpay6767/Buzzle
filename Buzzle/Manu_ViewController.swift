//
//  Menu_ViewController.swift
//  Housie
//
//  Created by Alpay Kücük on 03.08.21.
//

import Foundation
import UIKit
import SideMenu
import FirebaseDatabase
import BLTNBoard

class Manu_ViewController: UITableViewController {
    
    var selectedIndex = 0
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //MARK: do something when user presses menu item!
        
        vibratePhone()
        
        let nc = self.navigationController?.presentingViewController as! UINavigationController
        let ncroot = nc.viewControllers[0] as! ContainerViewController
                
        
        let currentSide = ncroot.children[ncroot.children.count-1]
        print("CurrentChild: " + currentSide.description)
        if (currentSide is MainMenuTab) {
            let tasksvc = currentSide as! MainMenuTab
            //tasksvc.label.cancel()
        }
        
        
        switch indexPath.row {
        case 0:
            /*
            let menuview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tasks_vc") as! Tasks_ViewController
            SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: {
                nc.popViewController(animated: false)
                nc.pushViewController(menuview, animated: false)

            })*/
            
            
            
            
            let menuview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainmenutab") as! MainMenuTab
            
            SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: {
                MainMenuTab.currentselectedView = .world

                menuview.willMove(toParent: ncroot)
                menuview.view.frame = ncroot.containerView.bounds
                ncroot.containerView.addSubview(menuview.view)
                ncroot.addChild(menuview)
                menuview.didMove(toParent: ncroot)
            })
            
            break

        case 1:
            
            if MainMenuTab.currentUser?.username == "notloggedin" {
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
                self.bulletinManager.showBulletin(above: self)
                
            } else {
                let menuview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editprofiletab") as! editprofileTab
                SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: {
                    
                    menuview.willMove(toParent: ncroot)
                    menuview.view.frame = ncroot.containerView.bounds
                    ncroot.containerView.addSubview(menuview.view)
                    ncroot.addChild(menuview)
                    menuview.didMove(toParent: ncroot)
                })            }
            
            
            break
        case 2:
            let menuview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainmenutab") as! MainMenuTab
            SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: {
                
                MainMenuTab.currentselectedView = .guns
                menuview.willMove(toParent: ncroot)
                menuview.view.frame = ncroot.containerView.bounds
                ncroot.containerView.addSubview(menuview.view)
                ncroot.addChild(menuview)
                menuview.didMove(toParent: ncroot)
            })
            
            
            break
        case 3:
            let menuview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainmenutab") as! MainMenuTab
            SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: {
                
                MainMenuTab.currentselectedView = .maps
                menuview.willMove(toParent: ncroot)
                menuview.view.frame = ncroot.containerView.bounds
                ncroot.containerView.addSubview(menuview.view)
                ncroot.addChild(menuview)
                menuview.didMove(toParent: ncroot)
            })
            
            
            break
        case 4:
            let menuview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainmenutab") as! MainMenuTab
            SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: {
                
                MainMenuTab.currentselectedView = .gruppen
                menuview.willMove(toParent: ncroot)
                menuview.view.frame = ncroot.containerView.bounds
                ncroot.containerView.addSubview(menuview.view)
                ncroot.addChild(menuview)
                menuview.didMove(toParent: ncroot)
            })
            
            break
        case 5:
            //settings
            let menuview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "infoviewcontroller") as! InfoViewController
            SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: {
                
                MainMenuTab.currentselectedView = .gruppen
                menuview.willMove(toParent: ncroot)
                menuview.view.frame = ncroot.containerView.bounds
                ncroot.containerView.addSubview(menuview.view)
                ncroot.addChild(menuview)
                menuview.didMove(toParent: ncroot)
            })
            break
        case 6:
            //logout
            vibratePhone()
            let page = BLTNPageItem(title: "Bye?")
            page.image = UIImage(systemName: "o8")

            page.descriptionText = "You are beeing logged out!"
            page.actionButtonTitle = "OK BYE"
            page.actionHandler = { (item: BLTNActionItem) in
                self.vibratePhone()
                item.manager?.dismissBulletin(animated: true)
                self.logout()

            }
            let rootItem: BLTNItem = page
            
            self.bulletinManager = BLTNItemManager(rootItem: rootItem)
            self.bulletinManager.showBulletin(above: self)
            break
        default:
            print("ERROR: Selection of drawer element failed!")
        }
        
    }
    
    func logout() {
        
        if MainMenuTab.currentUser?.username == "notloggedin" {
           
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "logintab")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
        } else {
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
    
    func openprofile() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "editprofiletab") as! editprofileTab
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
}
