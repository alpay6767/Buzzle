//
//  Kommentar.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 28.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Kommentar {
    
    var id: String?
    var user: String?
    var kommentar: String?
    var nutzer: Player?
    
    init(id: String, user: String, kommentar: String) {
        self.id = id
        self.user = user
        self.kommentar = kommentar
    }
    
    init?(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : AnyObject]
        self.id = value!["id"] as? String
        self.user = value!["user"] as? String
        self.kommentar = value!["kommentar"] as? String
    }
    
}
