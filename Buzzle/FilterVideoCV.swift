//
//  FilterCV.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 15.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import YPImagePicker
import ASPVideoPlayer



class FilterVideoCV: UIViewController {
    
    @IBOutlet weak var videoview: ASPVideoPlayer!
    
    static var videourl = URL(string: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let YPmphoto = YPMediaVideo(thumbnail: UIImage(named: "camllogo")!, videoURL: FilterVideoCV.videourl!)
        
        //cached URL of video:
        
        videoview.videoPlayerControls.videoPlayer?.volume = 1.0


        var urls = [URL]()
        urls.append(FilterVideoCV.videourl!)
        videoview.videoURLs = urls
        videoview.videoPlayerControls.videoPlayer?.stopVideo()
        videoview.videoPlayerControls.play()
        
        
    
        
        
        
    }
    
    @IBAction func posten(_ sender: Any) {
        vibratePhone()
        
        var currentvideopost = VideoPost(id: "", userid: (MainMenuTab.currentUser?.id!)!, username: (MainMenuTab.currentUser?.username!)!, likes: 0, videourl: FilterVideoCV.videourl!.absoluteString, type: "video")
        
        let originalSize = NSData(contentsOf: FilterVideoCV.videourl!)
        let sizeinMB = ByteCountFormatter.string(fromByteCount: Int64((originalSize?.length)!), countStyle: .file)
        
        print("Original: " + sizeinMB)
        
        
        let vc = presentingViewController?.presentingViewController as? MainMenuTab
        vc?.exportVideo(FilterVideoCV.videourl!)
        
            self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: {
                
            })
        
        
    }
    
    @IBAction func abbrechen(_ sender: Any) {
        vibratePhone()
        self.dismiss(animated: true) {
            
        }
    }
}

