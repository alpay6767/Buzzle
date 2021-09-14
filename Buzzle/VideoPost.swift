import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class VideoPost: Post {

    var videourl: String?

    
    init(id: String, userid: String, username: String, likes: Int, videourl: String, type: String) {
        super.init(id: id, userid: userid, username: username, likes: likes, type: type)
        self.videourl = videourl
    }
    
    
    override init(snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
        let value = snapshot.value as? [String : AnyObject]
        self.videourl = value!["videourl"] as? String
    }
    
    
    
}
