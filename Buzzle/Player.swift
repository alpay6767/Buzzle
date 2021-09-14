//
//  Player.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 29.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Player {
    
    var id: String?
    var username: String?
    var level: Int?
    var password: String?
    var profilbildurl: String?
    var profilbild: UIImage?
    
    var psn: String?
    var xbox: String?
    var pc: String?
    var token: String?

    var blockedList = [String]()
    var likedList = [String]()
    var postslist = [Post]()
    
    
    init(id: String, username: String, password: String, level: Int, profilbildurl: String, psn: String, xbox: String, pc: String, token: String) {
        self.id = id
        self.username = username
        self.password = password
        self.level = level
        self.profilbildurl = profilbildurl
        self.psn = psn
        self.xbox = xbox
        self.pc = pc
        self.token = token
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : AnyObject]
        self.id = value!["id"] as? String
        self.username = value!["username"] as? String
        self.password = value!["password"] as? String
        self.level = value!["level"] as? Int
        self.profilbildurl = value!["profilbildurl"] as? String
        self.token = value!["token"] as? String

        self.psn = value!["psn"] as? String
        self.xbox = value!["xbox"] as? String
        self.pc = value!["pc"] as? String
    }
    
    init(snapshotonlyusername: DataSnapshot) {
        let value = snapshotonlyusername.value as? [String : AnyObject]
        self.username = value!["username"] as? String
    }
    
    
    init() {
        
    }
    
    init(username: String) {
        self.username = username
    }
    
    func loadBlockedUser() {
        let defaults = UserDefaults.standard
        blockedList = defaults.object(forKey:(id! + "blockarray")) as? [String] ?? [String]()
    }
    
    func loadLickedPosts() {
        let defaults = UserDefaults.standard
        likedList = defaults.object(forKey:(id! + "likedarray")) as? [String] ?? [String]()
    }
    
    
    func hasBlockedUser(playerid: String) -> Bool {
        
        for userid in blockedList {
            if userid == playerid {
                return true
            }
        }
        return false
    }
    
    func hasLikedPost(postid: String) -> Bool {
        
        for currentpostid in likedList {
            if currentpostid == postid {
                return true
            }
        }
        return false
    }
    
    func blockUser(playerid: String) {
        blockedList.append(playerid)
        let defaults = UserDefaults.standard
        defaults.set(blockedList, forKey: (id! + "blockarray"))
    }
    
    func likeId(playerid: String) {
        likedList.append(playerid)
        let defaults = UserDefaults.standard
        defaults.set(likedList, forKey: (id! + "likedarray"))
    }
    
    func unblockUser(playerid: String) {
        var counter = 0
        for userid in blockedList {
            if userid == playerid {
                blockedList.remove(at: counter)
                break
            }
            counter+=1
        }
        let defaults = UserDefaults.standard
        defaults.set(blockedList, forKey: (id! + "blockarray"))
    }
    
    func dislikeId(postid: String) {
        var counter = 0
        for currentpostid in likedList {
            if currentpostid == postid {
                likedList.remove(at: counter)
                break
            }
            counter+=1
        }
        let defaults = UserDefaults.standard
        defaults.set(likedList, forKey: (id! + "likedarray"))
    }
    
}

struct CODPlayer: Decodable {
    
    let username: String
    let level: Int
    let kills: Int
}
