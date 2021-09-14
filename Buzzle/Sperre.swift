//
//  Sperre.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 25.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Sperre {
    
    var sperre: Bool?
    
    init(sperre: Bool) {
        self.sperre = sperre
    }
    
    init?(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : AnyObject]
        self.sperre = value!["sperre"] as? Bool
    }
    
    init() {
    }
}
