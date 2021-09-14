//
//  FotoPost.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 28.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class FotoPost: Post {

    var bildurl: String?
    var bild: UIImage?

    
    init(id: String, userid: String, username: String, likes: Int, bildurl: String, type: String) {
        super.init(id: id, userid: userid, username: username, likes: likes, type: type)
        self.bildurl = bildurl
    }
    
    
    override init(snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
        let value = snapshot.value as? [String : AnyObject]
        self.bildurl = value!["bildurl"] as? String
    }
    
    
}
