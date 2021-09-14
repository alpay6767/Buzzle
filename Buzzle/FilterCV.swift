//
//  FilterCV.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 15.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import YPImagePicker


class FilterCV: UIViewController {
    
    
    @IBOutlet weak var containerview: UIView!
    static var image = UIImage(named: "")
    
    var mediaFilterVC: YPPhotoFiltersVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let YPmphoto = YPMediaPhoto(image: FilterCV.image!)
        
        mediaFilterVC = YPPhotoFiltersVC(inputPhoto: YPmphoto, isFromSelectionVC: true)
        mediaFilterVC?.view.backgroundColor = #colorLiteral(red: 0.1377640814, green: 0.1377640814, blue: 0.1377640814, alpha: 1)
        //mediaFilterVC?.modalPresentationStyle = .fullScreen
        
        embed(mediaFilterVC!, inView: containerview)
        
        
        
    }
    
    @IBAction func posten(_ sender: Any) {
        vibratePhone()
        
        let vc = presentingViewController as? UINavigationController
        let containervc = vc?.viewControllers[0]
        let mainmenuvc = containervc?.children[0] as! MainMenuTab
        mainmenuvc.exportFoto((mediaFilterVC?.inputPhoto.image)!)
        
            self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: {
                
            })
        
        
    }
    
    @IBAction func abbrechen(_ sender: Any) {
        vibratePhone()
        self.dismiss(animated: true) {
            
        }
    }
}


extension UIViewController {
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
