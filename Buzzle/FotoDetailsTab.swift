//
//  FotoDetailsTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 01.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import JGProgressHUD
import AZDialogView
import GoogleMobileAds
import Kingfisher
import FaveButton
import PMAlertController
import ASPVideoPlayer
import ChameleonFramework
import BLTNBoard

class FotoDetailsTab: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var sendbtn: UIButton!
    @IBOutlet weak var commenttext: UITextField!
    @IBOutlet weak var comments_cv: UICollectionView!
    
    var bannerView: GADBannerView!
    
    static var currentPost: Post?
    var commentslis = [Kommentar]()
    let fbhandler = FBHandler()
    var currentselectedview = selectedViews.world
    
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
        // In this case, we instantiate the banner with desired ad size.
       /* bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-7177574010293341/4240801914"
        bannerView.rootViewController = self
        //bannerView.load(GADRequest())
        */
        
        hideKeyboardWhenTappedAround()
        comments_cv.delegate = self
        comments_cv.dataSource = self

        loadComments()
        
        
    }
    
    
    @IBAction func showmore(_ sender: Any) {
        vibratePhone()
        
        if MainMenuTab.currentUser?.username == "notloggedin" {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            showMorePic()
        }
        
    }
    
    func showMoreComment(commentid: String) {
        
        
        
        let alertVC = PMAlertController(title: "More", description: "Choose to report or block a comment so you dont have to see it again", image: UIImage(named: "personalidlogo"), style: .alert)
        
        alertVC.alertTitle.textColor = #colorLiteral(red: 0.04610475525, green: 0.04610475525, blue: 0.04610475525, alpha: 1)
        alertVC.dismissWithBackgroudTouch = true
        alertVC.gravityDismissAnimation = true
        
        if (MainMenuTab.currentUser!.hasBlockedUser(playerid: (commentid))) {
            alertVC.addAction(PMAlertAction(title: "Unblock", style: .default, action: { () in
                //entblockieren
                MainMenuTab.currentUser!.unblockUser(playerid: (commentid))
                self.loadComments()
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Unblocked!", description: "This comment was unblocked", buttontext: "Nice!", imagename: "o7"))
                self.bulletinManager.showBulletin(above: self)            }))
        } else {
        
            alertVC.addAction(PMAlertAction(title: "Block", style: .default, action: { () in
                //blockieren
                MainMenuTab.currentUser!.blockUser(playerid: (commentid))
                self.loadComments()
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Blocked!", description: "This comment was blocked!", buttontext: "Nice", imagename: "o3"))
                self.bulletinManager.showBulletin(above: self)
            }))
        }
        
        alertVC.addAction(PMAlertAction(title: "Report", style: .default, action: { () in
            //melden
            self.fbhandler.meldeUser(playerid: (commentid))

            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Reported!", description: "This comment was reported!", buttontext: "Nice", imagename: "o2"))
            self.bulletinManager.showBulletin(above: self)
        }))
        

        self.present(alertVC, animated: true, completion: nil)
        

        
    }
    
    func showMorePic() {
        
        let alertVC = PMAlertController(title: "More", description: "Choose to report or block a Post so you dont have to see it again", image: UIImage(named: "personalidlogo"), style: .alert)
        
        alertVC.alertTitle.textColor = #colorLiteral(red: 0.04610475525, green: 0.04610475525, blue: 0.04610475525, alpha: 1)
        alertVC.dismissWithBackgroudTouch = true
        alertVC.gravityDismissAnimation = true
        
        if (MainMenuTab.currentUser!.hasBlockedUser(playerid: (FotoDetailsTab.currentPost!.id!))) {
            alertVC.addAction(PMAlertAction(title: "Unblock", style: .default, action: { () in
                //entblockieren
                MainMenuTab.currentUser!.unblockUser(playerid: ((FotoDetailsTab.currentPost!.id!)))
                let presentvc = self.presentingViewController as? MainMenuTab
                presentvc?.loadPosts()
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Unblocked!", description: "This post was unblocked", buttontext: "Nice", imagename: "o8"))
                self.bulletinManager.showBulletin(above: self)
            }))
        } else {
        
            alertVC.addAction(PMAlertAction(title: "Block", style: .default, action: { () in
                //blockieren
                MainMenuTab.currentUser!.blockUser(playerid: ((FotoDetailsTab.currentPost!.id!)))
                let presentvc = self.presentingViewController as? MainMenuTab
                presentvc?.loadPosts()
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Blocked", description: "This post was blocked", buttontext: "Nice", imagename: "o2"))
                self.bulletinManager.showBulletin(above: self)
            }))
        }
        
        alertVC.addAction(PMAlertAction(title: "Report", style: .default, action: { () in
            //melden
            self.fbhandler.meldeUser(playerid: ((FotoDetailsTab.currentPost!.id!)))
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Reported!", description: "This post was reported!", buttontext: "Nice", imagename: "o10"))
            self.bulletinManager.showBulletin(above: self)
        }))
        

        self.present(alertVC, animated: true, completion: nil)
        

        
    }

    func loadComments() {
        
        switch currentselectedview {
        case .world:
            
            fbhandler.loadCommentsFromDB(currentFP: FotoDetailsTab.currentPost!) { commentslist in
                    guard let commentslist = commentslist else { return }
                       
                   self.commentslis = commentslist
                   self.comments_cv.reloadData()
                   
               }
        case .ingruppe:
            
            fbhandler.loadCommentsFromDBForGroup(group: MainMenuTab.selectedgroup!, currentFP: FotoDetailsTab.currentPost!) { commentslist in
                    guard let commentslist = commentslist else { return }
                       
                   self.commentslis = commentslist
                   self.comments_cv.reloadData()
                   
               }
        default:
            print("ERROR")
        }
           
        
       }

    
    @IBAction func kommentarposten(_ sender: Any) {
        vibratePhone()
        if MainMenuTab.currentUser?.username == "notloggedin" {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
        } else if (commenttext.text!.isEmpty) {
        
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "No message yet!", description: "Please write a message first!", buttontext: "Okayy", imagename: "o1"))
            self.bulletinManager.showBulletin(above: self)
        }
        else {
            
            switch currentselectedview {
            case .world:
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let newid = ref.child("Posts").child((FotoDetailsTab.currentPost?.id)!).child("Kommentare").childByAutoId().key
                
                let newKommentar = Kommentar(id: newid!, user: (MainMenuTab.currentUser?.username)!, kommentar: commenttext.text!)
                ref.child("Posts").child((FotoDetailsTab.currentPost?.id)!).child("Kommentare").child(newid!).setValue(["id": newKommentar.id, "user": newKommentar.user, "kommentar": newKommentar.kommentar])
                FBHandler.sendNotification(user: (FotoDetailsTab.currentPost?.User!)!, message: commenttext.text!)
                commenttext.text = ""

            case .ingruppe:
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let newid = ref.child("Gruppen").child((MainMenuTab.selectedgroup?.id!)!).child("Posts").child((FotoDetailsTab.currentPost?.id)!).child("Kommentare").childByAutoId().key
                               
                let newKommentar = Kommentar(id: newid!, user: (MainMenuTab.currentUser?.username)!, kommentar: commenttext.text!)
                ref.child("Gruppen").child((MainMenuTab.selectedgroup?.id!)!).child("Posts").child((FotoDetailsTab.currentPost?.id)!).child("Kommentare").child(newid!).setValue(["id": newKommentar.id, "user": newKommentar.user, "kommentar": newKommentar.kommentar])
                FBHandler.sendNotification(user: (FotoDetailsTab.currentPost?.User!)!, message: "New comment: " + commenttext.text!)
                commenttext.text = ""
                               
            default:
                print("ERROR")
            }
            
            
        }
        
    }
    
    func generateHeightForCell(nachricht: String) -> Float{
        
        let anzahlZeichen = Float(nachricht.count)
        let anzahlWomöglicherZeilen = (anzahlZeichen/45.0).rounded(.up)
        //print("Anzahl möglicher Zeilen: " + anzahlWomöglicherZeilen.description)
        //print("Anzahl Zeichen: " + anzahlZeichen.description)
        let hoehenFaktor = 0.08*anzahlWomöglicherZeilen
        
        return hoehenFaktor
        
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch currentselectedview {
        case .world, .ingruppe:
            
            switch FotoDetailsTab.currentPost {
            case is FotoPost, is VideoPost:
                return CGSize(width: collectionView.frame.width, height: 600)
            case is Spotting:
                return generateEstimatedHeightForSpotting((FotoDetailsTab.currentPost as? Spotting)!)
            default:
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*1.08)
            }
            
            return CGSize(width: collectionView.frame.width, height: 800)
        default:
            return CGSize(width: 0, height: 0 )

        }
    }
 */
    
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "detailsheader", for: indexPath) as? DetailsHeader
       
        switch currentselectedview {
        case .world, .ingruppe:
            
            
            
            if (FotoDetailsTab.currentPost is FotoPost) {
                
                headerView?.videoview.isHidden = true
                headerView?.text.isHidden = true

                let currentfotopost = FotoDetailsTab.currentPost as? FotoPost
                let url = URL(string: currentfotopost!.bildurl!)
                let urlprofilbild = URL(string: (currentfotopost!.User?.profilbildurl)!)

            
                
                headerView?.username.text = currentfotopost!.username
                //cell.profilbild.image = currentPost.User?.profilbild
                headerView?.profilpic.layer.cornerRadius = (headerView?.profilpic.bounds.width)!/2
                headerView?.profilpic.clipsToBounds = true
                headerView?.profilpic.kf.setImage(with: urlprofilbild)
                headerView?.bild.kf.setImage(with: url)
                currentfotopost!.User?.profilbild = headerView!.profilpic.image
                //headerView?.layout.layer.cornerRadius = 15
               // headerView?.layout.clipsToBounds = true
                //headerView?.likes.text = currentfotopost!.likes?.description
                //headerView?.comments.text = currentfotopost?.kommentare.count.description
                
                /*if(MainMenuTab.currentUser!.hasLikedPost(postid: currentfotopost!.id!)) {
                    headerView.likebtn.setImage(#imageLiteral(resourceName: "heartlogo"), for: .normal)
                } else {
                    headerView.likebtn.setImage(#imageLiteral(resourceName: "noherzbtn"), for: .normal)
                }
                */
        
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
                headerView?.profilpic.isUserInteractionEnabled = true
                headerView?.profilpic.tag = indexPath.row
                headerView?.profilpic.addGestureRecognizer(tapGestureRecognizer)
                
                
                
                /*let liketap = UITapGestureRecognizer(target: self, action: #selector(likednormalTab(_:)))
                liketap.numberOfTapsRequired = 1
                headerView.likebtn.isUserInteractionEnabled = true
                headerView.likebtn.tag = indexPath.row
                headerView.likebtn.addGestureRecognizer(liketap)
                
                */
           
            
            
                return headerView!
                
            } else if FotoDetailsTab.currentPost is VideoPost {
                //VideoCell:
                headerView?.bild.isHidden = true
                headerView?.text.isHidden = true
                
                let currentvideopost = FotoDetailsTab.currentPost as? VideoPost
                var urlvideo = URL(string: currentvideopost!.videourl!)
                //cached URL of video:
                
                CacheManager.shared.getFileWith(stringUrl: (currentvideopost?.videourl!)!) { result in

                        switch result {
                        case .success(let url):
                             urlvideo = url
                            //print("Cached Video laden erfolgreich!")
                        case .failure(let error):
                            // handle errror
                            print("Fehler beim Laden des Cached Videos")
                        }
                    }
                
                
                let urlprofilbild = URL(string: (currentvideopost!.User?.profilbildurl)!)


                headerView?.username.text = currentvideopost!.username
                //cell.profilbild.image = currentPost.User?.profilbild
                headerView?.profilpic.layer.cornerRadius = (headerView?.profilpic.bounds.width)!/2
                headerView?.profilpic.clipsToBounds = true
                headerView?.profilpic.kf.setImage(with: urlprofilbild)


                var urls = [URL]()
                urls.append(urlvideo!)
                headerView?.videoview.videoURLs = urls
                headerView?.videoview.videoPlayerControls.videoPlayer?.stopVideo()
                
                
                currentvideopost!.User?.profilbild = headerView?.profilpic.image
               // headerView?.layout.layer.cornerRadius = 15
                //headerView?.layout.clipsToBounds = true
                //headerView.likes.text = currentvideopost!.likes?.description
                    
                /*if(MainMenuTab.currentUser!.hasLikedPost(postid: currentvideopost!.id!)) {
                    headerView?.likebtn.setImage(#imageLiteral(resourceName: "heartlogo"), for: .normal)
                } else {
                    headerView?.likebtn.setImage(#imageLiteral(resourceName: "noherzbtn"), for: .normal)
                }
 */
                
        
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
                headerView?.profilpic.isUserInteractionEnabled = true
                headerView?.profilpic.tag = indexPath.row
                headerView?.profilpic.addGestureRecognizer(tapGestureRecognizer)
                
                
                /*let liketap = UITapGestureRecognizer(target: self, action: #selector(likednormalTab(_:)))
                liketap.numberOfTapsRequired = 1
                cell.likebtn.isUserInteractionEnabled = true
                cell.likebtn.tag = indexPath.row
                cell.likebtn.addGestureRecognizer(liketap)
           */
            
            
                return headerView!
            } else {
                
                headerView?.videoview.isHidden = true
                headerView?.bild.isHidden = true

                let currentspotting = FotoDetailsTab.currentPost as? Spotting
                
                let urlprofilbild = URL(string: (currentspotting!.User?.profilbildurl)!)

            
                
                headerView?.username.text = currentspotting!.username
                //cell.profilbild.image = currentPost.User?.profilbild
                headerView?.profilpic.layer.cornerRadius = (headerView?.profilpic.bounds.width)!/2
                headerView?.profilpic.clipsToBounds = true
                headerView?.profilpic.kf.setImage(with: urlprofilbild)
                headerView?.text.text = currentspotting?.spottingtext!
                currentspotting!.User?.profilbild = headerView!.profilpic.image
                headerView?.layout.layer.cornerRadius = 15
                headerView?.layout.clipsToBounds = true
                //headerView?.likes.text = currentfotopost!.likes?.description
                //headerView?.comments.text = currentfotopost?.kommentare.count.description
                
                /*if(MainMenuTab.currentUser!.hasLikedPost(postid: currentfotopost!.id!)) {
                    headerView.likebtn.setImage(#imageLiteral(resourceName: "heartlogo"), for: .normal)
                } else {
                    headerView.likebtn.setImage(#imageLiteral(resourceName: "noherzbtn"), for: .normal)
                }
                */
        
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
                headerView?.profilpic.isUserInteractionEnabled = true
                headerView?.profilpic.tag = indexPath.row
                headerView?.profilpic.addGestureRecognizer(tapGestureRecognizer)
                
                
                
                /*let liketap = UITapGestureRecognizer(target: self, action: #selector(likednormalTab(_:)))
                liketap.numberOfTapsRequired = 1
                headerView.likebtn.isUserInteractionEnabled = true
                headerView.likebtn.tag = indexPath.row
                headerView.likebtn.addGestureRecognizer(liketap)
                
                */
           
            
            
                return headerView!
                
            }

        default:
            print("ERROR")
            return headerView!
        }
        
    }
    */
    
    func getImageViewFromView(view: UIView) -> UIImageView
    {
        
        let iv = view as! UIImageView
        return iv
        
    }
    
    @objc func openProfileComment(_ sender: AnyObject)
    {
        vibratePhone()
        let currentcomment = commentslis[sender.view.tag]
        let iv = getImageViewFromView(view: sender.view)
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations:  {
            
            iv.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            
        }) { (_) in
            
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations:  {
                
                iv.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }) { (_) in
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "profiltab") as! profileTab
                
                newViewController.currentPlayer = currentcomment.nutzer
                
                FBHandler.sendNotification(user: currentcomment.nutzer!, message: "has visited your profile!")
            
               self.present(newViewController, animated: true, completion: nil)
                
                
                
            }
            
            
        }
    }
    
    @objc func openProfile(_ sender: AnyObject)
    {
        
        vibratePhone()
        let iv = getImageViewFromView(view: sender.view)
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations:  {
            
            iv.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            
        }) { (_) in
            
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations:  {
                
                iv.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }) { (_) in
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "profiltab") as! profileTab
                
                newViewController.currentPlayer = FotoDetailsTab.currentPost!.User
                FBHandler.sendNotification(user: FotoDetailsTab.currentPost!.User!, message: "has visited your profile!")
                
            
               self.present(newViewController, animated: true, completion: nil)
                
                
                
            }
            
            
        }
    }
    
    @objc func showMore(_ sender: AnyObject)
    {
        vibratePhone()
        let currentcomment = commentslis[sender.view.tag]
        
        if MainMenuTab.currentUser?.username == "notloggedin" {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            showMoreComment(commentid: currentcomment.id!)
        }
        

    }
    
    
    
    
    fileprivate func generateEstimatedHeightForSpotting(_ currentfotopost: Spotting) -> CGSize {
        let approximateWidthOfContent = view.frame.width - 20
        // x is the width of the logo in the left
        
        let size = CGSize(width: approximateWidthOfContent, height: 1000)
        
        //1000 is the large arbitrary values which should be taken in case of very high amount of content
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        let estimatedFrame = NSString(string: currentfotopost.spottingtext!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 100)
    }
    
    
    fileprivate func generateEstimatedHeight(_ currentfotopost: Kommentar) -> CGSize {
        let approximateWidthOfContent = view.frame.width - 20
        // x is the width of the logo in the left
        
        let size = CGSize(width: approximateWidthOfContent, height: 1000)
        
        //1000 is the large arbitrary values which should be taken in case of very high amount of content
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        let estimatedFrame = NSString(string: currentfotopost.kommentar!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: view.bounds.width, height: view.bounds.height * CGFloat(generateHeightForCell(nachricht: commentslis[indexPath.item].kommentar!)) )
        let currentfotopost = commentslis[indexPath.item]

        
        return generateEstimatedHeight(currentfotopost)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentslis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentcomment = commentslis[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentcell", for: indexPath) as! commentCell
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.clipsToBounds = true
        cell.commentext.text = currentcomment.kommentar

        cell.nametext.text = currentcomment.nutzer?.username
        cell.profilbild.layer.cornerRadius = cell.profilbild.bounds.width/2
        cell.profilbild.clipsToBounds = true
        let url = URL(string: (currentcomment.nutzer?.profilbildurl)!)
        cell.profilbild.kf.setImage(with: url)
        cell.bgview.layer.cornerRadius = 15
        cell.bgview.clipsToBounds = true
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfileComment(_:)))
        cell.profilbild.isUserInteractionEnabled = true
        cell.profilbild.tag = indexPath.row
        cell.profilbild.addGestureRecognizer(tapGestureRecognizer)
        
        let opentabrecognizer = UITapGestureRecognizer(target: self, action: #selector(showMore(_:)))
        opentabrecognizer.numberOfTapsRequired = 1
        cell.bgview.isUserInteractionEnabled = true
        cell.bgview.tag = indexPath.row
        cell.bgview.addGestureRecognizer(opentabrecognizer)
        
        opentabrecognizer.require(toFail: tapGestureRecognizer)
        
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vibratePhone()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 0
   }

    
}


