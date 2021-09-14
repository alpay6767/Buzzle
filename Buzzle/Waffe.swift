//
//  Waffe.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 28.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit

class Waffe {
    
    var id: String?
    var name: String?
    var bild: UIImage?
    var genauigkeit: Int?
    var schaden: Int?
    var reichweite: Int?
    var feuerrate: Int?
    var mobilität: Int?
    var kontrolle: Int?
    
    var fotosDerCommunity = [FotoPost]()
    
    var blueprints = [Waffe]()
    
    init(id: String, name: String, bild: UIImage, genauigkeit: Int, schaden: Int, reichweite: Int, feuerrate: Int, mobilität: Int, kontrolle: Int) {
        self.id = id
        self.name = name
        self.bild = bild
        self.genauigkeit = genauigkeit
        self.schaden = schaden
        self.reichweite = reichweite
        self.feuerrate = feuerrate
        self.mobilität = mobilität
        self.kontrolle = kontrolle
    }
    
    init() {
        
    }
    
    
}
