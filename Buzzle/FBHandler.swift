//
//  FBHandler.swift
//  TheTest
//
//  Created by Alpay Kücük on 15.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


class FBHandler {
    
    
    init() {
        
    }
    
    
    func uploadMedia(image: UIImage, currentUser: Player, completion: @escaping (_ url: String?) -> Void) {

        let storageRef = Storage.storage().reference().child("User").child(currentUser.id!).child(currentUser.id! + ".png")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {

                    storageRef.downloadURL(completion: { (url, error) in

                        print(url?.absoluteString)
                        completion(url?.absoluteString)
                    })

                  //  completion((metadata?.downloadURL()?.absoluteString)!))
                    // your uploaded photo url.


                }
            }
        }
    }
    
    
    func getDataFromUrl(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, imageview: UIImageView) {
        print("Download Started")
        getDataFromUrl(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                imageview.image = UIImage(data: data)
            }
        }
    }
    
    
    func checkUserCredentials(username: String, password: String, completion: @escaping (_ authentificated: Bool?, _ foundUser: Player?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("User").observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                        let loadedUser = Player(snapshot: child)
                    if (loadedUser.username == username && loadedUser.password == password) {
                            completion(true, loadedUser)
                            return
                                
                    }
                }
                completion(false, Player())
            }
            else {
                completion(false, Player())
            }
        })
    }
    
    func checkIfUsernameExists(username: String, completion: @escaping (_ authentificated: Bool?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("User").observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                        let loadedUser = Player(snapshotonlyusername: child)
                    if (loadedUser.username?.lowercased() == username) {
                            completion(true)
                            return
                                
                    }
                }
                completion(false)
            }
            else {
                completion(false)
            }
        })
    }
    
    func getUsersToken(user: Player, completion: @escaping (_ fertig: Bool?, _ token: String?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("User").child(user.id!).child("token").observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            let value = snapshot.value as? [String : AnyObject]
            let tokenString = value!["token"] as? String
            completion(true, tokenString)
        })
    }
    
    func getUserByID(id: String, completion: @escaping (_ fertig: Bool?, _ foundUser: Player?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("User").child(id).observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            let loadedUser = Player(snapshot: snapshot)
            completion(true, loadedUser)
        })
    }
    
    
    func meldeUser(playerid: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Reported").child(playerid).setValue([
            "id" : playerid
        ])
    }
    
    
    func getUserByUsername(username: String, completion: @escaping (_ fertig: Bool?, _ foundUser: Player?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("User").observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let loadedUser = Player(snapshot: child)
                    if (loadedUser.username == username) {
                        completion(true, loadedUser)
                        return
                    }
                }

                completion(false, Player())
            }
            else {
                completion(false, Player())
            }
        })
    }
    
    func loadGruppenFromDB(completion: @escaping (_ gruppelist: [Gruppe]?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("Gruppen").observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            var newgruppelist = [Gruppe]()
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let loadedgame = Gruppe(snapshot: child)
                    newgruppelist.append(loadedgame!)
                }
                
                completion(newgruppelist)
            }
        })
    }
    
    
        func loadCommentsFromDB(currentFP: Post, completion: @escaping (_ commentslist: [Kommentar]?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("Posts").child(currentFP.id!).child("Kommentare").observe(.value, with: { snapshot in

            if !snapshot.exists() { return }

            var kommentarelist = [Kommentar]()
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                var counter = result.count
                for child in result {
                    
                    let loadedKommentar = Kommentar(snapshot: child)
                        self.getUserByUsername(username: (loadedKommentar?.user!)!) { fertig, opponment  in
                                 guard let opponment = opponment else { return }
                                guard let fertig = fertig else { return }
                                
                                if (fertig) {
                                   loadedKommentar?.nutzer = opponment
                                    if (MainMenuTab.currentUser!.hasBlockedUser(playerid: (loadedKommentar?.nutzer?.id)!) || MainMenuTab.currentUser!.hasBlockedUser(playerid: (loadedKommentar!.id)!)) {
                                       //Fotopost wurde blockiert!
                                   } else {
                                       kommentarelist.append(loadedKommentar!)
                                   }
                                   counter-=1
                                   
                                   if (counter == 0) {
                                       completion(kommentarelist)
                                   }
                                }
                        }
                    
                }
            }
        })
    }

    func loadCommentsFromDBForGroup(group: Gruppe, currentFP: Post, completion: @escaping (_ commentslist: [Kommentar]?) -> Void){

    var ref: DatabaseReference!
    ref = Database.database().reference()
    
        ref?.child("Gruppen").child(group.id!).child("Posts").child(currentFP.id!).child("Kommentare").observe(.value, with: { snapshot in

        if !snapshot.exists() { return }

        var kommentarelist = [Kommentar]()
        if let result = snapshot.children.allObjects as? [DataSnapshot] {
            var counter = result.count
            for child in result {
                
                let loadedKommentar = Kommentar(snapshot: child)
                    self.getUserByUsername(username: (loadedKommentar?.user!)!) { fertig, opponment  in
                             guard let opponment = opponment else { return }
                            guard let fertig = fertig else { return }
                            
                            if (fertig) {
                               loadedKommentar?.nutzer = opponment
                                if (MainMenuTab.currentUser!.hasBlockedUser(playerid: (loadedKommentar?.nutzer?.id)!) || MainMenuTab.currentUser!.hasBlockedUser(playerid: (loadedKommentar!.id)!)) {
                                   //Fotopost wurde blockiert!
                               } else {
                                   kommentarelist.append(loadedKommentar!)
                               }
                               counter-=1
                               
                               if (counter == 0) {
                                   completion(kommentarelist)
                               }
                            }
                    }
                
            }
        }
    })
}
    
    func loadsperre(completion: @escaping (_ sperre: Bool?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("Sperre").observe(.value, with: { snapshot in

            if !snapshot.exists() { return }

            let currentSperre = Sperre(snapshot: snapshot)
            completion(currentSperre?.sperre)
        })
    }
    
    func deleteAll(completion: @escaping (_ sperre: Bool?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("Sperre").child("sperre").setValue(true)
        ref.child("Posts").removeValue()
        completion(true)
        
    }
    
    
    func loadPostsFromDBForGroup(group: Gruppe, completion: @escaping (_ postlist: [Post]?) -> Void){

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref?.child("Gruppen").child(group.id!).child("Posts").queryLimited(toLast: 70).observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            var newgameslist = [Post]()
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                var counter = result.count
                
                for child in result {
                    var loadedGame = Post(snapshot: child)
                    
                    switch loadedGame.type {
                    case "photo":
                        loadedGame = FotoPost(snapshot: child)
                    case "video":
                        loadedGame = VideoPost(snapshot: child)
                    case "text":
                        loadedGame = Spotting(snapshot: child)
                    default:
                        //print("No Post recognizable")
                        loadedGame = FotoPost(snapshot: child)
                    }
                    
                    if MainMenuTab.currentUser!.hasLikedPost(postid: (loadedGame.id)!) {
                        loadedGame.liked = true
                    }
                    self.getUserByID(id: loadedGame.userid!) { fertig, opponment  in
                              guard let opponment = opponment else { return }
                             guard let fertig = fertig else { return }
                             
                             if (fertig) {
                                loadedGame.User = opponment
                                if (MainMenuTab.currentUser!.hasBlockedUser(playerid: (loadedGame.userid)!) || MainMenuTab.currentUser!.hasBlockedUser(playerid: (loadedGame.id)!)) {
                                    //Fotopost wurde blockiert!
                                } else {
                                    newgameslist.append(loadedGame)
                                }
                                counter-=1
                                
                                if (counter == 0) {
                                    completion(newgameslist)
                                }
                             }
                     }
                }
                
                
            }
        })
    }

    
    func loadPostsFromDBWithUser(completion: @escaping (_ postlist: [Post]?) -> Void){

        var ref: DatabaseReference!
               ref = Database.database().reference()
               
               ref?.child("Posts").queryLimited(toLast: 70).observeSingleEvent(of: .value, with: { snapshot in

                   if !snapshot.exists() { return }

                   var newgameslist = [Post]()
                   if let result = snapshot.children.allObjects as? [DataSnapshot] {
                       var counter = result.count
                       
                       for child in result {
                           var loadedGame = Post(snapshot: child)
                           
                           switch loadedGame.type {
                           case "photo":
                               loadedGame = FotoPost(snapshot: child)
                           case "video":
                               loadedGame = VideoPost(snapshot: child)
                           case "text":
                               loadedGame = Spotting(snapshot: child)
                           default:
                               //print("No Post recognizable")
                               loadedGame = FotoPost(snapshot: child)
                           }
                           
                           if MainMenuTab.currentUser!.hasLikedPost(postid: (loadedGame.id)!) {
                               loadedGame.liked = true
                           }
                           self.getUserByID(id: loadedGame.userid!) { fertig, opponment  in
                                     guard let opponment = opponment else { return }
                                    guard let fertig = fertig else { return }
                                    
                                    if (fertig) {
                                       loadedGame.User = opponment
                                       if (MainMenuTab.currentUser!.hasBlockedUser(playerid: (loadedGame.userid)!) || MainMenuTab.currentUser!.hasBlockedUser(playerid: (loadedGame.id)!)) {
                                           //Fotopost wurde blockiert!
                                       } else {
                                           newgameslist.append(loadedGame)
                                       }
                                       counter-=1
                                       
                                       if (counter == 0) {
                                           completion(newgameslist)
                                       }
                                    }
                            }
                       }
                       
                       
                   }
               })
    }
    
    func loadRandomUsers(completion: @escaping (_ userlist: [Player]?) -> Void){

        var ref: DatabaseReference!
               ref = Database.database().reference()
               
               ref?.child("User").queryLimited(toLast: 15).observeSingleEvent(of: .value, with: { snapshot in

                   if !snapshot.exists() { return }

                var userslist = [Player]()

                   if let result = snapshot.children.allObjects as? [DataSnapshot] {
                       var counter = result.count
                       
                       for child in result {
                        var loadedUser = Player(snapshot: child)
                        userslist.append(loadedUser)
                        completion(userslist)

                       }
                       
                       
                   }
                completion(userslist)

               })
    }
    
    func uploadFotoPostForGameMedia(image: UIImage, currentfotopost: FotoPost, completion: @escaping (_ url: String?) -> Void) {

        let storageRef = Storage.storage().reference().child("Posts").child(currentfotopost.id!).child(currentfotopost.id! + ".png")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {

                    storageRef.downloadURL(completion: { (url, error) in

                        print(url?.absoluteString)
                        completion(url?.absoluteString)
                    })

                  //  completion((metadata?.downloadURL()?.absoluteString)!))
                    // your uploaded photo url.


                }
            }
        }
    }
    
    
    func uploadVideoPostForGameMedia(currentvideopost: VideoPost, completion: @escaping (_ url: String?) -> Void) {

        let storageRef = Storage.storage().reference().child("Posts").child(currentvideopost.id!).child(currentvideopost.id! + ".mp4")
        let urlvideo = URL(string: currentvideopost.videourl!)
        storageRef.putFile(from: urlvideo!, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print("Failed upload of video:", error)
                return
            } else {
                storageRef.downloadURL(completion: { (url, error) in

                    print(url?.absoluteString)
                    completion(url?.absoluteString)
                })
            }
            
            
            
        })
    }
    
    static func sendNotification(user: Player, message: String) {
        
        let sender = PushSender()
        if (user.token == nil) {
            user.token = "//"
        }
        sender.sendPushNotification(to: user.token!, title: MainMenuTab.currentUser!.username!, body: message)
    }
        
    func saveUserToDefaults(user: Player) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "LoggedIn")
        defaults.set(user.id, forKey: "id")
        defaults.set(user.username, forKey: "username")
        defaults.set(user.password, forKey: "password")
        defaults.set(user.level, forKey: "level")
        defaults.set(user.profilbildurl, forKey: "profilbildurl")
        defaults.set(user.psn, forKey: "psn")
        defaults.set(user.xbox, forKey: "xbox")
        defaults.set(user.pc, forKey: "pc")
        defaults.set(user.token, forKey: "token")

    }
    
    
    func getUserFromDefaults() -> Player {
        
        let defaults = UserDefaults.standard
        let loggeduser = defaults.object(forKey: "loggeduser") as? Player
        return loggeduser!
        
    }
    
    
    
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

