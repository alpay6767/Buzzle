//
//  ActivityPost.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 28.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class ActivityPost: Post {

    var bildurl: String?
    var bild: UIImage?
    var text: String?
    
    init(id: String, userid: String, username: String, likes: Int, bildurl: String, text: String) {
        super.init(id: id, userid: userid, username: username, likes: likes, type: "activity")
        self.bildurl = bildurl
        self.text = text
    }
    
    override init(snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
        let value = snapshot.value as? [String : AnyObject]
        self.bildurl = value!["bildurl"] as? String
        self.text = value!["text"] as? String
    }
    
}
