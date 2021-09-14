//
//  MainMenuTab.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 14.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import YPImagePicker
import FirebaseDatabase
import FirebaseStorage
import NVActivityIndicatorView
import FaveButton
import AZDialogView
import GoogleMobileAds
import ASPVideoPlayer
import PopMenu
import MobileCoreServices
import PDFReader
import ChameleonFramework
import SideMenu
import BLTNBoard


class MainMenuTab: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GADInterstitialDelegate, UINavigationControllerDelegate {
    
    
    
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
    }
    
    let modeldata = ModelData()
    let modeldataguns = ModelDataGuns()
    @IBOutlet weak var nameuni: UILabel!
    @IBOutlet weak var posts_cv: UICollectionView!
    @IBOutlet weak var titleschrift: UILabel!
    @IBOutlet weak var profile_cv: UICollectionView!
    @IBOutlet weak var bgbild: UIImageView!
    
    let fbhandler = FBHandler()
    var postslist = [Post]()
    var userslist = [Player]()
    var gruppenlist = [Gruppe]()
    
    @IBOutlet weak var postbtn: UIButton!
    @IBOutlet weak var ladebalken: NVActivityIndicatorView!
    static var currentUser: Player?
    var picker: YPImagePicker?
    
    static var backgroundcolor: UIColor?
    
    var kontext = "posts"
    
    var menuview: PopMenuViewController?
    
    static var currentselectedView = selectedViews.world
    static var selectedgroup: Gruppe?
        
        
    
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
        
        
        initializeView()
        loadPosts()
        loadUsers()
        loadGruppen()
        //loadSpottings()
        confImagepicker()
        
        interstitial = createAndLoadInterstitial()
        createSmallBannerAd()
        
        menu = SideMenuManager.default.leftMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
        
        listenToSperre()
        
        
    }
    
    
    func createSmallBannerAd() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-7177574010293341/4240801914"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        let eulaaccepted = defaults.bool(forKey: "eula")
        if (!eulaaccepted) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "eulatab") as! eulaTab
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    func listenToSperre() {
        
        fbhandler.loadsperre() { sperre in
             guard let sperre = sperre else { return }
                
            if sperre {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "wartungtab") as! WartungTab
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: true, completion: nil)
                
            } else {
                
            }
 
        }
    }
    
    
    func createAndLoadInterstitial() -> GADInterstitial {
        //TODO: ID ÄNDERN
        //real werbung: ca-app-pub-7177574010293341/9738363492
        //test werbung: ca-app-pub-3940256099942544/4411468910
      var interstitial = GADInterstitial(adUnitID: "ca-app-pub-7177574010293341/9738363492")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
    

    @IBAction func zurück(_ sender: Any) {
        vibratePhone()
        self.dismiss(animated: true) {
            
        }
    }
    
    fileprivate func confgrouppost(_ sender: UIButton) {
        
        let actionnewgroup = PopMenuDefaultAction(title: "New Group", image: UIImage(systemName: "person.circle.fill"), didSelect: { [self] action in
            self.dismiss(animated: true) {
                
            }
            let newspottab = self.storyboard!.instantiateViewController(withIdentifier: "newtexttab") as! newtextTab
            newspottab.selectedView = .gruppen
            self.present(newspottab, animated: true)
        })

        
        
        menuview = PopMenuViewController(sourceView: sender,actions:[
            actionnewgroup
        ])
        
    }
    
    fileprivate func confpost_pic(_ sender: UIButton) {
        let actionPhoto = PopMenuDefaultAction(title: "Library", image: UIImage(systemName: "photo.fill"), didSelect: { [self] action in
            // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
            self.confImagepicker()
            self.dismiss(animated: true) {
                
            }
            self.present(self.picker!, animated: true, completion: nil)
        })
        
        let actionVideo = PopMenuDefaultAction(title: "Camera", image: UIImage(systemName: "camera.circle.fill"), didSelect: { [self] action in
            // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
            //confVideopicker()
            self.dismiss(animated: true) {
                
            }
            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "videocamvc") as! VideoCamViewController
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        })
        
        let actionWalk = PopMenuDefaultAction(title: "new text", image: UIImage(systemName: "text.alignleft"), didSelect: { [self] action in
            self.dismiss(animated: true) {
                
            }
            let newspottab = self.storyboard!.instantiateViewController(withIdentifier: "newtexttab") as! newtextTab
            newspottab.selectedView = .world
            self.present(newspottab, animated: true)
        })
        let actionVacation = PopMenuDefaultAction(title: "new game party", image: #imageLiteral(resourceName: "profilebtnn"), didSelect: { [self] action in

        })
        
        
        menuview = PopMenuViewController(sourceView: sender,actions:[
            actionPhoto,
            actionVideo,
            actionWalk,
            //actionVacation
        ])
        
    }
    
    @IBAction func postbtn(_ sender: UIButton) {
        
        vibratePhone()
        
        if MainMenuTab.currentUser?.username == "notloggedin" {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
        } else {
            
            //self.menu!.setRevealed(true, animated: true)
            switch MainMenuTab.currentselectedView {
            case .world, .ingruppe:
                confpost_pic(sender)
                self.present(menuview!, animated: true) {
                    
                }
            case .gruppen:
                confgrouppost(sender)
                self.present(menuview!, animated: true) {
                    
                }
            default:
                self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "This Button does nothing here!", description: "Use this button else where, good luck :D", buttontext: "Cool", imagename: "o7"))
                self.bulletinManager.showBulletin(above: self)
            }
            
            
        }
    }
    @IBAction func opensettings(_ sender: Any) {
        vibratePhone()
        if MainMenuTab.currentUser?.username == "notloggedin" {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {

            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "settingstab") as! settingsTab
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    func exportFoto(_ photo: UIImage) {
        self.ladebalken.startAnimating()
        
        var currentnewfotopost = FotoPost(id: "", userid: (MainMenuTab.currentUser?.id!)!, username: (MainMenuTab.currentUser?.username!)!, likes: 0, bildurl: "", type: "photo")
        currentnewfotopost.bild = photo
        
        
        self.postFotoPost(post: currentnewfotopost
        )
    }
    
    func exportSpotting(currentspotting: Spotting) {

        var currentspottingpost = Spotting(id: "", userid: (MainMenuTab.currentUser?.id!)!, username: (MainMenuTab.currentUser?.username!)!, likes: 0, spottingtext: currentspotting.spottingtext!, type:  "text")
        
        
        
        self.postSpotting(post: currentspottingpost)
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
        
        config.video.fileType = .mov
        config.video.recordingTimeLimit = 60.0
        config.video.libraryTimeLimit = 60.0
        config.video.minimumTimeLimit = 3.0
        config.video.trimmerMaxDuration = 60.0
        config.video.trimmerMinDuration = 3.0
        
    
        
        
        picker = YPImagePicker(configuration: config)
        
        picker!.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                
                let imageofphoto = photo.image
                self.exportFoto(imageofphoto)
            }
            picker!.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func exportVideo(_ url: URL) {
        /*if let _ = self.video.url {
         NRVideoCompressor.compressVideoWithQuality(AVAssetExportPresetLowQuality, inputURL: originalVideoUrl!, completionHandler: { (outputUrl) in
         
         
         let originalSize = NSData(contentsOf: video.url)
         let sizeinMB = ByteCountFormatter.string(fromByteCount: Int64((originalSize?.length)!), countStyle: .file)
         
         print("Original: " + sizeinMB)
         })
         }
         
         */
        
        var currentvideopost = VideoPost(id: "", userid: (MainMenuTab.currentUser?.id!)!, username: (MainMenuTab.currentUser?.username!)!, likes: 0, videourl: url.absoluteString, type: "video")
        
        
        
        self.postFotoPost(post: currentvideopost)
    }
    
    func loadPosts() {
        
        fbhandler.loadPostsFromDBWithUser() { [self] postlist in
             guard let postlist = postlist else { return }
                
            self.postslist = self.orderPostList(currentlist: postlist)
            self.posts_cv.reloadData()
            
            
            
        }
    }
    
    func loadUsers() {
        
        fbhandler.loadRandomUsers() { [self] userlist in
             guard let userlist = userlist else { return }
                
            self.userslist = userlist.shuffled()
            self.profile_cv.reloadData()
            
            
            
        }
    }
    

    
    func orderPostList(currentlist: [Post]) -> [Post]{
        var sorted = currentlist
        sorted.sort(by: { $0.date!.compare($1.date!) == .orderedDescending })

        return sorted
        
        
    }
    
    func loadGruppenPosts(currentgruppe: Gruppe) {

        
        fbhandler.loadPostsFromDBForGroup(group: currentgruppe) { [self] postlist in
             guard let postlist = postlist else { return }
            
            self.postslist = [Post]()
            self.postslist = self.orderPostList(currentlist: postlist)
            self.posts_cv.reloadData()
            
            
            
        }
        self.posts_cv.reloadData()
    }
    
    func loadGruppen() {
        
        fbhandler.loadGruppenFromDB() { gruppenlist in
             guard let gruppenlist = gruppenlist else { return }
                
            self.gruppenlist
                = gruppenlist
            //self.gruppenlist.reverse()
            self.posts_cv.reloadData()
            
        }
    }
    
    
    func initializeView() {
        posts_cv.delegate = self
        posts_cv.dataSource = self
        
        profile_cv.delegate = self
        profile_cv.dataSource = self
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)

        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        posts_cv.refreshControl = refreshControl
    }
    
    @objc func refreshList(refreshControl: UIRefreshControl) {

        switch MainMenuTab.currentselectedView {
        case .world:
            loadPosts()
        case .gruppen:
            loadGruppen()
        case .ingruppe:
            loadGruppenPosts(currentgruppe: MainMenuTab.selectedgroup!)
        default:
            print("ERROR")
        }
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
    }
    

    @objc func openpic(_ sender: AnyObject)
    {
        vibratePhone()
        switch MainMenuTab.currentselectedView {
            case .world:
                let currentpost = postslist[sender.view.tag]
                 
                     FotoDetailsTab.currentPost = currentpost
                let newViewController = self.storyboard!.instantiateViewController(withIdentifier: "fotodetailstab") as! FotoDetailsTab
                newViewController.currentselectedview = .world
                
                
                self.present(newViewController, animated: true, completion: nil)
            case .ingruppe:
            let currentpost = postslist[sender.view.tag]
             
                 FotoDetailsTab.currentPost = currentpost
            let newViewController = self.storyboard!.instantiateViewController(withIdentifier: "fotodetailstab") as! FotoDetailsTab
            newViewController.currentselectedview = .ingruppe
            
            
            self.present(newViewController, animated: true, completion: nil)
            case .guns:
                print("Categories opened")
            default:
                print("ERROR")
            }
    }
    
    @objc func openvideo(_ sender: AnyObject)
    {
            
        vibratePhone()
            switch MainMenuTab.currentselectedView {
            case .world:
                let currentpost = postslist[sender.view.tag]
                 
                     FotoDetailsTab.currentPost = currentpost
                let newViewController = self.storyboard!.instantiateViewController(withIdentifier: "fotodetailstab") as! FotoDetailsTab
                newViewController.currentselectedview = .world
                
                
                self.present(newViewController, animated: true, completion: nil)
            case .ingruppe:
            let currentpost = postslist[sender.view.tag]
             
                 FotoDetailsTab.currentPost = currentpost
            let newViewController = self.storyboard!.instantiateViewController(withIdentifier: "fotodetailstab") as! FotoDetailsTab
            newViewController.currentselectedview = .ingruppe
            
            
            self.present(newViewController, animated: true, completion: nil)
            case .guns:
                print("Categories opened")
            default:
                print("ERROR")
            }

    }
    

    
    
    
    @objc func likednormalTab(_ sender: AnyObject)
    {
        vibratePhone()
        if MainMenuTab.currentUser?.username == "notloggedin" {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            
            switch MainMenuTab.currentselectedView {
            case .world, .ingruppe:
                if (MainMenuTab.currentUser!.hasLikedPost(postid: postslist[sender.view.tag].id!)) {
                    
                    
                    
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    
                    
                    
                    var extractedExpr: Int = postslist[sender.view.tag].likes! - 1
                    if (extractedExpr < 0) {
                        extractedExpr = 0
                    }
                    
                    switch MainMenuTab.currentselectedView {
                    case .world:
                        ref?.child("Posts").child(postslist[sender.view.tag].id!).child("likes").setValue(extractedExpr)
                        MainMenuTab.currentUser!.dislikeId(postid: postslist[sender.view.tag].id!)
                        loadPosts()
                    case .ingruppe:
                        ref?.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").child(postslist[sender.view.tag].id!).child("likes").setValue(extractedExpr)
                        MainMenuTab.currentUser!.dislikeId(postid: postslist[sender.view.tag].id!)
                        loadGruppenPosts(currentgruppe: MainMenuTab.selectedgroup!)
                    default:
                        print("ERROR")
                    }
                } else {
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                                    
                    
                    let heart = getUIButtonFromView(view: sender.view)
                    
                  

                    switch MainMenuTab.currentselectedView {
                    case .world:
                        ref?.child("Posts").child(postslist[sender.view.tag].id!).child("likes").setValue(postslist[sender.view.tag].likes! + 1)
                        MainMenuTab.currentUser!.likeId(playerid: postslist[sender.view.tag].id!)
                        loadPosts()
                    case .ingruppe:
                        ref?.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").child(postslist[sender.view.tag].id!).child("likes").setValue(postslist[sender.view.tag].likes! + 1)
                        MainMenuTab.currentUser!.likeId(playerid: postslist[sender.view.tag].id!)
                        loadGruppenPosts(currentgruppe: MainMenuTab.selectedgroup!)
                    default:
                        print("ERROR")
                    }
                    
                    FBHandler.sendNotification(user: postslist[sender.view.tag].User!, message: "Has liked your post!")
                }
            case .guns:
                print("categories")
                
            default:
                print("ERROR")
            }
            
            
            
            
        }
        
    }
    
    
    @objc func likeddoubleTab(_ sender: AnyObject)
    {
        vibratePhone()
        if MainMenuTab.currentUser?.username == "notloggedin" {
            self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "Oops .. You aren't logged in!", description: "Please login to access this function", buttontext: "Okayy", imagename: "o9"))
            self.bulletinManager.showBulletin(above: self)
            
        } else {
            if (MainMenuTab.currentUser!.hasLikedPost(postid: postslist[sender.view.tag].id!)) {
                
                
                getVies(view: sender.view).isUserInteractionEnabled = false
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                var extractedExpr: Int = postslist[sender.view.tag].likes! - 1
                if (extractedExpr < 0) {
                    extractedExpr = 0
                }
                
                switch MainMenuTab.currentselectedView {
                case .world:
                    ref?.child("Posts").child(postslist[sender.view.tag].id!).child("likes").setValue(extractedExpr)
                    MainMenuTab.currentUser!.dislikeId(postid: postslist[sender.view.tag].id!)
                    loadPosts()
                case .ingruppe:
                    ref?.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").child(postslist[sender.view.tag].id!).child("likes").setValue(extractedExpr)
                    MainMenuTab.currentUser!.dislikeId(postid: postslist[sender.view.tag].id!)
                    loadGruppenPosts(currentgruppe: MainMenuTab.selectedgroup!)
                default:
                    print("ERROR")
                }
                getVies(view: sender.view).isUserInteractionEnabled = true

            } else {
                var ref: DatabaseReference!
                ref = Database.database().reference()
                                
                getVies(view: sender.view).isUserInteractionEnabled = false

                self.getVies(view: sender.view).isUserInteractionEnabled = true

                switch MainMenuTab.currentselectedView {
                case .world:
                    ref?.child("Posts").child(postslist[sender.view.tag].id!).child("likes").setValue(postslist[sender.view.tag].likes! + 1)
                    MainMenuTab.currentUser!.likeId(playerid: postslist[sender.view.tag].id!)
                    loadPosts()
                case .ingruppe:
                    ref?.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").child(postslist[sender.view.tag].id!).child("likes").setValue(postslist[sender.view.tag].likes! + 1)
                    MainMenuTab.currentUser!.likeId(playerid: postslist[sender.view.tag].id!)
                    loadGruppenPosts(currentgruppe: MainMenuTab.selectedgroup!)
                default:
                    print("ERROR")
                }
                
                FBHandler.sendNotification(user: postslist[sender.view.tag].User!, message: "Has liked your post!")

            }
        }
        
    }
    
    func getVies(view: UIView) -> UIImageViewWithHeart
    {
        
        let iv = view as! UIImageViewWithHeart
        return iv
        
    }
    
    func getASPlayerFromView(view: UIView) -> ASPVideoPlayer
    {
        
        let iv = view as! ASPVideoPlayer
        return iv
        
    }
    
    
    func getImageViewFromView(view: UIView) -> UIImageView
    {
        
        let iv = view as! UIImageView
        return iv
        
    }
    
    func getUIButtonFromView(view: UIView) -> UIButton
    {
        
        let iv = view as! UIButton
        return iv
        
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
                
                switch MainMenuTab.currentselectedView {
                case .world, .ingruppe:
                    newViewController.currentPlayer = self.postslist[sender.view.tag].User
                    FBHandler.sendNotification(user: self.postslist[sender.view.tag].User!, message: "has visited your profile!")
                default:
                    print("ERROR")
                }
                
                
                

               self.present(newViewController, animated: true, completion: nil)
                
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == profile_cv {
            return CGSize(width: 80, height: 0)

        } else {
        
        
        switch MainMenuTab.currentselectedView {
        case .world, .ingruppe:
            let currpost = postslist[indexPath.item]
            if currpost is Spotting {
                return CGSize(width: view.bounds.width, height: 250 )
            } else {
                return CGSize(width: view.bounds.width, height: 600 )
            }
            
        case .gruppen:
            return CGSize(width: view.bounds.width, height: 90)
        case .guns:
            return CGSize(width: view.bounds.width, height: view.bounds.height*0.2)
        case .maps:
            return CGSize(width: view.bounds.width, height: view.bounds.height*0.3)
        default:
            return CGSize(width: view.bounds.width, height: view.bounds.height * 0.3 )
        }
       
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == profile_cv {
            let count: Int = userslist.count
            return count

        } else {
        
        switch MainMenuTab.currentselectedView {
        case .world, .ingruppe:
            return postslist.count
        case .gruppen:
            return gruppenlist.count
        case .guns:
            return modeldataguns.allewaffen.count
        case .maps:
            return modeldataguns.allemaps.count
        default:
            return 0
        }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == profile_cv {
            let currentuser = userslist[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilecell", for: indexPath) as! profileCell
            let urlprofilbild = URL(string: (currentuser.profilbildurl)!)
            cell.bild.layer.cornerRadius = cell.bild.bounds.width/2
            cell.bild.clipsToBounds = true
            cell.bild.kf.setImage(with: urlprofilbild)
            
            return cell
            
        } else {
        
        
        switch MainMenuTab.currentselectedView {
        case .world, .ingruppe:
            let currentpost = postslist[indexPath.item]
            
            switch currentpost {
            case is FotoPost:
                let currentfotopost = currentpost as? FotoPost
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fotopostcell", for: indexPath) as! FotoPostCell
                let burl = currentfotopost?.bildurl
                let url = URL(string: burl!)
                let urlprofilbild = URL(string: (currentfotopost!.User?.profilbildurl)!)

                cell.name.text = currentfotopost!.username
                cell.namedown.text = currentfotopost!.username
                //cell.profilbild.image = currentPost.User?.profilbild
                cell.profilbild.layer.cornerRadius = cell.profilbild.bounds.width/2
                cell.profilbild.clipsToBounds = true
                cell.profilbild.kf.setImage(with: urlprofilbild)
                cell.postpic.kf.setImage(with: url)
                currentfotopost!.User?.profilbild = cell.profilbild.image
                cell.layout.layer.cornerRadius = 15
                cell.layout.clipsToBounds = true
                let likesstring: String = currentfotopost!.likes!.description
                cell.likes.text = likesstring + " likes"
                let commentsstring: String = (currentfotopost?.kommentare.count.description)!
                cell.comments.text = "View all comments"
                let string = currentfotopost?.date
                if let range = string!.range(of: "+") {
                    let firstPart = string![string!.startIndex..<range.lowerBound]
                    cell.date.text = String(firstPart)
                }
                
                if(MainMenuTab.currentUser!.hasLikedPost(postid: postslist[indexPath.item].id!)) {
                    cell.likebtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    cell.likebtn.setImage(UIImage(systemName: "heart"), for: .normal)
                }
                
        
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
                cell.profilbild.isUserInteractionEnabled = true
                cell.profilbild.tag = indexPath.row
                cell.profilbild.addGestureRecognizer(tapGestureRecognizer)
                
                let tapDoubleTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeddoubleTab(_:)))
                tapDoubleTabRecognizer.numberOfTapsRequired = 2
                //cell.postpic.heart = cell.heart
                cell.postpic.isUserInteractionEnabled = true
                cell.postpic.tag = indexPath.row
                cell.postpic.addGestureRecognizer(tapDoubleTabRecognizer)
                
                let opentabrecognizer = UITapGestureRecognizer(target: self, action: #selector(openpic(_:)))
                opentabrecognizer.numberOfTapsRequired = 1
                cell.comments.isUserInteractionEnabled = true
                cell.comments.tag = indexPath.row
                cell.comments.addGestureRecognizer(opentabrecognizer)
                
                
                let liketap = UITapGestureRecognizer(target: self, action: #selector(likednormalTab(_:)))
                liketap.numberOfTapsRequired = 1
                cell.likebtn.isUserInteractionEnabled = true
                cell.likebtn.tag = indexPath.row
                cell.likebtn.addGestureRecognizer(liketap)
                

           
            
            
                return cell
            case is VideoPost:
                let currentvideopost = currentpost as? VideoPost
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videopostcell", for: indexPath) as! videopostCell
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


                cell.name.text = currentvideopost!.username
                //cell.profilbild.image = currentPost.User?.profilbild
                cell.profilbild.layer.cornerRadius = cell.profilbild.bounds.width/2
                cell.profilbild.clipsToBounds = true
                cell.profilbild.kf.setImage(with: urlprofilbild)


                var urls = [URL]()
                urls.append(urlvideo!)
                cell.videoview.videoURLs = urls
                cell.videoview.videoPlayerControls.videoPlayer?.stopVideo()
                
                let string = currentvideopost?.date
                if let range = string!.range(of: "+") {
                    let firstPart = string![string!.startIndex..<range.lowerBound]
                    cell.date.text = String(firstPart)
                }
                currentvideopost!.User?.profilbild = cell.profilbild.image
                cell.layout.layer.cornerRadius = 15
                cell.layout.clipsToBounds = true
                cell.likes.text = currentvideopost!.likes?.description
        
                cell.comments.text = currentvideopost?.kommentare.count.description
                
                if(MainMenuTab.currentUser!.hasLikedPost(postid: postslist[indexPath.item].id!)) {
                    cell.likebtn.setImage(#imageLiteral(resourceName: "heartlogo"), for: .normal)
                } else {
                    cell.likebtn.setImage(#imageLiteral(resourceName: "noherzbtn"), for: .normal)
                }
                
        
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
                cell.profilbild.isUserInteractionEnabled = true
                cell.profilbild.tag = indexPath.row
                cell.profilbild.addGestureRecognizer(tapGestureRecognizer)
                
                let tapDoubleTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeddoubleTab(_:)))
                tapDoubleTabRecognizer.numberOfTapsRequired = 2
                cell.heartview.heart = cell.heart
                cell.heartview.isUserInteractionEnabled = true
                cell.heartview.tag = indexPath.row
                cell.heartview.addGestureRecognizer(tapDoubleTabRecognizer)
                
                let opentabrecognizer = UITapGestureRecognizer(target: self, action: #selector(openpic(_:)))
                opentabrecognizer.numberOfTapsRequired = 1
                cell.layout.isUserInteractionEnabled = true
                cell.layout.tag = indexPath.row
                cell.layout.addGestureRecognizer(opentabrecognizer)
                
                
                
                let liketap = UITapGestureRecognizer(target: self, action: #selector(likednormalTab(_:)))
                liketap.numberOfTapsRequired = 1
                cell.likebtn.isUserInteractionEnabled = true
                cell.likebtn.tag = indexPath.row
                cell.likebtn.addGestureRecognizer(liketap)
                
                let commenttap = UITapGestureRecognizer(target: self, action: #selector(openpic(_:)))
                commenttap.numberOfTapsRequired = 1
                cell.commentsbtn.isUserInteractionEnabled = true
                cell.commentsbtn.tag = indexPath.row
                cell.commentsbtn.addGestureRecognizer(commenttap)
           
                opentabrecognizer.require(toFail: tapGestureRecognizer)
                opentabrecognizer.require(toFail: commenttap)
                opentabrecognizer.require(toFail: tapDoubleTabRecognizer)
            
            
                return cell
            case is Spotting:
                let currenttextpost = currentpost as? Spotting
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spottcell", for: indexPath) as! spottCell
                let urlprofilbild = URL(string: (currenttextpost!.User?.profilbildurl)!)

                cell.name.text = currenttextpost!.username
                //cell.profilbild.image = currentPost.User?.profilbild
                cell.profilbild.layer.cornerRadius = cell.profilbild.bounds.width/2
                cell.profilbild.clipsToBounds = true
                cell.profilbild.kf.setImage(with: urlprofilbild)
                cell.spotttext.text = currenttextpost?.spottingtext
                currenttextpost!.User?.profilbild = cell.profilbild.image
                let likesstring: String = currenttextpost!.likes!.description
                cell.likes.text = likesstring + " likes"
                let commentsstring: String = (currenttextpost?.kommentare.count.description)!
                cell.comments.text = "View all comments"
                
                
                if(MainMenuTab.currentUser!.hasLikedPost(postid: postslist[indexPath.item].id!)) {
                    cell.likebtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    cell.likebtn.setImage(UIImage(systemName: "heart"), for: .normal)
                }
                
        
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
                cell.profilbild.isUserInteractionEnabled = true
                cell.profilbild.tag = indexPath.row
                cell.profilbild.addGestureRecognizer(tapGestureRecognizer)
                
                /*let opentabrecognizer = UITapGestureRecognizer(target: self, action: #selector(openpic(_:)))
                opentabrecognizer.numberOfTapsRequired = 1
                cell.layout.isUserInteractionEnabled = true
                cell.layout.tag = indexPath.row
                cell.layout.addGestureRecognizer(opentabrecognizer)*/
                
                
                let liketap = UITapGestureRecognizer(target: self, action: #selector(likednormalTab(_:)))
                liketap.numberOfTapsRequired = 1
                cell.likebtn.isUserInteractionEnabled = true
                cell.likebtn.tag = indexPath.row
                cell.likebtn.addGestureRecognizer(liketap)
                
                let commenttap = UITapGestureRecognizer(target: self, action: #selector(openpic(_:)))
                commenttap.numberOfTapsRequired = 1
                cell.comments.isUserInteractionEnabled = true
                cell.comments.tag = indexPath.row
                cell.comments.addGestureRecognizer(commenttap)
           
                //opentabrecognizer.require(toFail: tapGestureRecognizer)
                //opentabrecognizer.require(toFail: commenttap)

           
            
            
                return cell
            default:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "videopostcell", for: indexPath) as! videopostCell
            }
        case .guns:
            let currentcategory = modeldataguns.allewaffen[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gruppecell", for: indexPath) as! gruppeCell

            cell.bild.image = currentcategory.bild
            cell.name.text = currentcategory.name
            cell.layout.layer.cornerRadius = 15
            cell.layout.clipsToBounds = true
            return cell
        case .maps:
            let currentcategory = modeldataguns.allemaps[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gruppecell", for: indexPath) as! gruppeCell

            cell.bild.image = currentcategory.bild
            cell.name.text = currentcategory.name
            cell.layout.layer.cornerRadius = 15
            cell.layout.clipsToBounds = true
            return cell
        case .gruppen:
            let currentcategory = gruppenlist[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupcell", for: indexPath) as! groupcell
            cell.name.text = currentcategory.name
            cell.name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.layout.layer.cornerRadius = 15
            //cell.layout.backgroundColor = UIColor(rgb: currentcategory.farbe!)
            cell.layout.backgroundColor = #colorLiteral(red: 0.07619436085, green: 0.07619436085, blue: 0.07619436085, alpha: 1)
            cell.layout.clipsToBounds = true
            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "videopostcell", for: indexPath) as! videopostCell
        }
        
    }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let selectedview = MainMenuTab.currentselectedView

        if interstitial.isReady && AppDelegate.counter%22 == 0 {
            AppDelegate.counter += 1
            interstitial.present(fromRootViewController: self)
        } else {
            AppDelegate.counter += 1
            switch MainMenuTab.currentselectedView {
            case .gruppen:
                vibratePhone()
                self.postslist.removeAll()
                let selectedgroup = gruppenlist[indexPath.item]
                MainMenuTab.selectedgroup = selectedgroup
                MainMenuTab.currentselectedView = .ingruppe
                loadGruppenPosts(currentgruppe: selectedgroup)
                // titleschrift.text = selectedgroup.name
            case .guns:
                vibratePhone()
                let selectedWaffe = modeldataguns.allewaffen[indexPath.item]
                WaffenDetailsTab.currentWaffe = selectedWaffe
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "waffendetailstab") as! WaffenDetailsTab
                self.present(newViewController, animated: true, completion: nil)
            case .maps:
                vibratePhone()
                let selectedMap = modeldataguns.allemaps[indexPath.item]
                MapDetailsTab.currentMap = selectedMap
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "mapdetailstab") as! MapDetailsTab
                self.present(newViewController, animated: true, completion: nil)
            default:
                print("Hello")
            }
            
  
        }
        
    }
  
    func postFotoPost(post: Post) {
        
        switch MainMenuTab.currentselectedView {
        case .world:
            var ref: DatabaseReference!
            ref = Database.database().reference()
         let newid = ref.child("Posts").childByAutoId().key
            
            post.id = newid
         
         if (post is FotoPost) {
             let fotopost = post as? FotoPost
             fbhandler.uploadFotoPostForGameMedia(image: fotopost!.bild!, currentfotopost: fotopost!) { url in
                     guard let url = url else { return }
                 ref.child("Posts").child(post.id!).setValue([
                         "id" : post.id!,
                         "userid" : post.userid!,
                         "username" : post.username!,
                         "likes" : post.likes,
                         "type" :  post.type,
                         "date" :  post.date,
                         "bildurl" : url
                    ])
                    
                    self.ladebalken.stopAnimating()
                 
                 self.loadPosts()
                    /*let vc = Transator()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true) {
                      
                    }
         */
                    
                }
         } else {
             
             let videopost = post as? VideoPost
             fbhandler.uploadVideoPostForGameMedia(currentvideopost: videopost!) { url in
                     guard let url = url else { return }
                 ref.child("Posts").child(post.id!).setValue([
                         "id" : post.id!,
                         "userid" : post.userid!,
                         "username" : post.username!,
                         "likes" : post.likes,
                         "type" :  post.type,
                         "date" :  post.date,
                         "videourl" : url
                    ])
                    
                    self.ladebalken.stopAnimating()
                 
                 self.loadPosts()
                    /*let vc = Transator()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true) {
                      
                    }
         */
                    
                }
             
         }
        case .ingruppe:
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let newid = ref.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").childByAutoId().key
            
            post.id = newid
         
         if (post is FotoPost) {
             let fotopost = post as? FotoPost
             fbhandler.uploadFotoPostForGameMedia(image: fotopost!.bild!, currentfotopost: fotopost!) { url in
                     guard let url = url else { return }
                ref.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").child(post.id!).setValue([
                         "id" : post.id!,
                         "userid" : post.userid!,
                         "username" : post.username!,
                         "likes" : post.likes,
                         "type" :  post.type,
                         "date" :  post.date,
                         "bildurl" : url
                    ])
                    
                    self.ladebalken.stopAnimating()
                 
                self.loadGruppenPosts(currentgruppe: MainMenuTab.selectedgroup!)
                    /*let vc = Transator()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true) {
                      
                    }
         */
                    
                }
         } else {
             
             let videopost = post as? VideoPost
             fbhandler.uploadVideoPostForGameMedia(currentvideopost: videopost!) { url in
                     guard let url = url else { return }
                ref.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").child(post.id!).setValue([
                         "id" : post.id!,
                         "userid" : post.userid!,
                         "username" : post.username!,
                         "likes" : post.likes,
                         "type" :  post.type,
                         "date" :  post.date,
                         "videourl" : url
                    ])
                    
                    self.ladebalken.stopAnimating()
                 
                self.loadGruppenPosts(currentgruppe: MainMenuTab.selectedgroup!)                    /*let vc = Transator()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true) {
                      
                    }
         */
                    
                }
             
         }
        default:
            print("ERROR")
        }
    
        self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "You have posted!", description: "Can't wait for the reactions!", buttontext: "Yeyy", imagename: "o4"))
        self.bulletinManager.showBulletin(above: self)
        
       }
    
    @IBAction func openmenu(_ sender: Any) {
        menu = SideMenuManager.default.leftMenuNavigationController
        self.present(menu!, animated: true) {
            
        }
    }
    
    
    func postSpotting(post: Spotting) {

        
        switch MainMenuTab.currentselectedView {
        case .ingruppe:
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let newid = ref.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").childByAutoId().key
            
            post.id = newid
             
             let spotpost = post
            ref?.child("Gruppen").child(MainMenuTab.selectedgroup!.id!).child("Posts").child(post.id!).setValue([
                     "id" : post.id!,
                     "userid" : post.userid!,
                     "username" : post.username!,
                     "likes" : post.likes,
                     "type" :  post.type,
                     "date" :  post.date,
                     "spottingtext" : post.spottingtext
                ])
            loadGruppenPosts(currentgruppe: MainMenuTab.selectedgroup!)
        case .world:
            var ref: DatabaseReference!
            ref = Database.database().reference()
         let newid = ref.child("Posts").childByAutoId().key
            
            post.id = newid
             
             let spotpost = post
            ref?.child("Posts").child(post.id!).setValue([
                     "id" : post.id!,
                     "userid" : post.userid!,
                     "username" : post.username!,
                     "likes" : post.likes,
                     "type" :  post.type,
                     "date" :  post.date,
                     "spottingtext" : post.spottingtext
                ])
            
            loadPosts()
        default:
            print("ERROR")
        }
  
        self.bulletinManager = BLTNItemManager(rootItem: self.createNewMeldung(title: "You have posted!", description: "Can't wait for the reactions!", buttontext: "Yeyy", imagename: "o4"))
        self.bulletinManager.showBulletin(above: self)

       }

    
}



public enum Result<T> {
    case success(T)
    case failure(NSError)
}

class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {

        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()

    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {


        let file = directoryFor(stringUrl: stringUrl)

        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(Result.success(file))
            return
        }

        DispatchQueue.global().async {

            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)

                DispatchQueue.main.async {
                    completionHandler(Result.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(Result.failure(NSError()))
                }
            }
        }
    }

    private func directoryFor(stringUrl: String) -> URL {

        let fileURL = URL(string: stringUrl)!.lastPathComponent

        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)

        return file
    }
}




extension UIImage {
    
    func showImageSize() {
        
        
       
        var imgData: NSData = NSData(data: (self).jpegData(compressionQuality: 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        var imageSize: Int = imgData.count
        print("size of image in KB: %f ", Double(imageSize) / 1000.0)
        
    }
    
    
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}


public enum selectedViews {
    
    case world, gruppen, guns, maps, ingruppe

}
