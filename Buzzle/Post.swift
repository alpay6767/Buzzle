//
//  Post.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 13.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Post {
    
    var id: String?
    var userid: String?
    var likes: Int?
    var username: String?
    var kommentare = [Kommentar]()
    var User: Player?
    var type: String?
    var liked = false
    var date: String?
    
    init(id: String, userid: String, username: String, likes: Int, type: String) {
        self.id = id
        self.userid = userid
        self.username = username
        self.likes = likes
        self.type = type
        self.date = Date().description

    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : AnyObject]
        self.id = value!["id"] as? String
        self.userid = value!["userid"] as? String
        self.username = value!["username"] as? String
        self.likes = (value!["likes"] as? Int)!
        self.type = value!["type"] as? String
        self.date = value!["date"] as? String
        if(self.date == nil) {
            self.date = Date().description
        }
    }
    
    func getDate() -> String{
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        
        let stringdate = day.description + "." + month.description + "." + year.description + " " + hour.description + ":" + minutes.description
        
        return stringdate
    }
    

    
    
}
