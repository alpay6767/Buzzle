//
//  Spotting.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 21.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Spotting: Post{
    
    
    var spottingtext: String?
    

    
    init(id: String, userid: String, username: String, likes: Int, spottingtext: String, type: String) {
        super.init(id: id, userid: userid, username: username, likes: likes, type: type)
        self.spottingtext = spottingtext
    }
    
    
    override init(snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
        let value = snapshot.value as? [String : AnyObject]
        self.spottingtext = value!["spottingtext"] as? String
    }
    
    
}
