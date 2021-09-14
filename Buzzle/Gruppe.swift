//
//  Gruppe.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 20.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Gruppe {
    
    var id: String?
    var name: String?
    var farbe: Int?
    
    init(id: String, name: String, farbe: Int) {
        self.id = id
        self.name = name
        self.farbe = farbe
    }
    
    init?(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : AnyObject]
        self.id = value!["id"] as? String
        self.name = value!["name"] as? String
        self.farbe = value!["farbe"] as? Int
    }
    
    init() {
        
    }
    
}
