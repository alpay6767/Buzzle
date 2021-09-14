import UIKit
import SideMenu
import GoogleMobileAds
import BLTNBoard

class ContainerViewController: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    lazy var bulletinManager: BLTNItemManager = {
        
        let page = BLTNPageItem(title: "Time to pay off these loans!")
        page.image = #imageLiteral(resourceName: "gunlogo")

        page.descriptionText = "Focus on your tasks while paying off loans of cool stuff!"
        page.actionButtonTitle = "Let's start"
        page.actionHandler = { (item: BLTNActionItem) in
            self.vibratePhone()
            item.manager?.dismissBulletin(animated: true)
        }
        let rootItem: BLTNItem = page
        return BLTNItemManager(rootItem: rootItem)
        }()

    
    var menu: SideMenuNavigationController?
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

       // addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-7177574010293341/4240801914"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self


        //view1.backgroundColor = UIColor.fromGradient(gradient, frame: frame)
        
        let menuview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menucv") as! Manu_ViewController
        
        menu = SideMenuNavigationController(rootViewController: menuview)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: true)
        
        SideMenuManager.default.leftMenuNavigationController = menu!
        //SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
        
        let menuviessw = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainmenutab") as! MainMenuTab
        
        menuviessw.willMove(toParent: self)
        menuviessw.view.frame = containerView.bounds
        containerView.addSubview(menuviessw.view)
        addChild(menuviessw)
        menuviessw.didMove(toParent: self)
        
        
        showOnBoarding()
        
    }
    
    /*func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
 */
    
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      bannerView.alpha = 0
      UIView.animate(withDuration: 1, animations: {
        bannerView.alpha = 1
      })
    }
    
    @IBAction func openMenu() {
        vibratePhone()
        present(menu!, animated: true) {
            
        }
        
    }
    
    func showOnBoarding() {
        let defaults = UserDefaults.standard
        let firsttime = defaults.bool(forKey: "firsttime")
        
        if firsttime {
            //defaults.setValue(false, forKey: "firsttime")
            vibratePhoneMedium()
            bulletinManager.showBulletin(above: self)

        }
        
    }
    
    
}


extension UIViewController {
    
    func vibratePhone() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
    }
    func vibratePhoneMedium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
    }
    
}
