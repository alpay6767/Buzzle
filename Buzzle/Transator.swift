//
//  Transator.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 13.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import liquid_swipe

class Transator: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {
    
    var viewControllers: [UIViewController] = {
        let firstPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page1")
        let secondPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page2")
        let thirdPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page3")
        let fourthPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page4")
        var controllers: [UIViewController] = [firstPageVC, secondPageVC, thirdPageVC, fourthPageVC]
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = self
    }

    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
        return viewControllers.count
    }
    
    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }

}

