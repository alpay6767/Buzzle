//
//  videopostCell.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 13.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import ASPVideoPlayer

class videopostCell: UICollectionViewCell {
    
    @IBOutlet weak var profilbild: UIImageView!
    @IBOutlet weak var videoview: ASPVideoPlayer!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var layout: UIView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var commentsbtn: UIButton!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var heartview: UIImageViewWithHeart!
    
    
}
