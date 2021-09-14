//
//  Map.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 28.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit

class Map {
    
    var id: String?
    var name: String?
    var beschreibung: String?
    var bild: UIImage?
    var maplayout_bild: UIImage?
    var eroberung_bild: UIImage?
    var hardpoint_bild: UIImage?
    var likes = 0
    
    var kommentare = [Kommentar]()
    
    init(id: String, name: String, beschreibung: String, bild: UIImage, maplayout_bild: UIImage, eroberung_bild: UIImage, hardpoint_bild: UIImage) {
        self.id = id
        self.name = name
        self.beschreibung = beschreibung
        self.bild = bild
        self.maplayout_bild = maplayout_bild
        self.eroberung_bild = eroberung_bild
        self.hardpoint_bild = hardpoint_bild
    }
    
    init() {
    }
    
    
}
