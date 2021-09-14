//
//  VideoCamViewController.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 15.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import SwiftyCam
import YPImagePicker

class VideoCamViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 30.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        flashMode = .auto
        flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        captureButton.buttonEnabled = false
        swipeToZoomInverted = true
        videoQuality = .medium
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureButton.delegate = self
    }
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
        
        
        let newViewController = presentingViewController?.storyboard!.instantiateViewController(withIdentifier: "filtercv") as! FilterCV
        FilterCV.image = photo
         newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
        
        //self.present(newVC, animated: true, completion: nil)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        
        if (swiftyCam.currentCamera == .front) {
            
        } else {
            /*print("Did Begin Recording")
            captureButton.growButton()
            hideButtons()
 */
        }
        
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        if (swiftyCam.currentCamera == .front) {
            
        } else {
            /*print("Did finish Recording")
            captureButton.shrinkButton()
            showButtons()
 */
        }
        
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        //let newVC = VideoViewController(videoURL: url)
        //self.present(newVC, animated: true, completion: nil)
        
        if (swiftyCam.currentCamera == .front) {
            
        } else {
            /*let newViewController = presentingViewController?.storyboard!.instantiateViewController(withIdentifier: "filtervideocv") as! FilterVideoCV
            FilterVideoCV.videourl = url
             newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
 */
        }
        
        
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        //print("Camera did change to \(camera.rawValue)")
        //print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }

    @IBAction func cameraSwitchTapped(_ sender: Any) {
        vibratePhone()
        switchCamera()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        vibratePhone()
        //flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
    
    @IBAction func canclerecording(_ sender: Any) {
        vibratePhone()
        self.dismiss(animated: true) {
            
        }
    }
    
    
}


// UI Animations
extension VideoCamViewController {
    
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        }
    }
    
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        }
    }
    
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func toggleFlashAnimation() {
        //flashEnabled = !flashEnabled
        if flashMode == .auto{
            flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
        }else if flashMode == .on{
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
        }else if flashMode == .off{
            flashMode = .auto
            flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        }
    }
}
