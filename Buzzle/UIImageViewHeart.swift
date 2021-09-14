//
//  UIImageViewHeart.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 15.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit


class UIImageViewWithHeart: UIImageView {
    
    var heart: UIImageView?
    
    override init(image: UIImage?) {
            super.init(image: image)
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

    
    
    
}
