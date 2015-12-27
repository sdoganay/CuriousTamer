//
//  CameraRollController.swift
//  CuriousTamer
//
//  Created by Seda Nur Doganay on 19/12/15.
//  Copyright © 2015 Seda Nur Doganay. All rights reserved.
//

import UIKit
import AVFoundation

class CameraRollController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    
    var tune = AVAudioPlayer()
    var leftSwipe : UISwipeGestureRecognizer!
    var rightSwipe : UISwipeGestureRecognizer!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        leftSwipe = UISwipeGestureRecognizer(target:self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        
        rightSwipe = UISwipeGestureRecognizer(target:self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer){
//        if(imageView.image != nil){
//            imageView.image = UIImage(named: "tentUp")
//            
//        }
        imageView = nil
        let filePath = NSBundle.mainBundle().pathForResource("scarryClown", ofType: ".gif")
        let scarryGif = NSData(contentsOfFile: filePath!)
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.loadData(scarryGif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false;
        //
//        let screamSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ScaryScream", ofType: "wav")!)
//        var audioPlayer = AVAudioPlayer()
//        do {
//            try audioPlayer = AVAudioPlayer(contentsOfURL: screamSound, fileTypeHint: nil)
//            audioPlayer.prepareToPlay()
//        } catch {
//            print("Something went wrong!")
//        }
        
        //
//        audioPlayer.play()
        /////---------
        let tuneURL : NSURL = NSBundle.mainBundle().URLForResource("ScaryScream", withExtension: "wav")!
        do { tune = try AVAudioPlayer(contentsOfURL: tuneURL, fileTypeHint: nil) } catch { print("file not found"); return }
        tune.numberOfLoops = 1
        tune.prepareToPlay()
        tune.play()
        //////////------------- //TODO doesnt working
     
        self.view.addSubview(webViewBG)
        
}

    @IBAction func choosePhoto(sender: AnyObject) {
        let imagePickerFromLibrary = UIImagePickerController()
        imagePickerFromLibrary.delegate = self
        imagePickerFromLibrary.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickerFromLibrary, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        imageView.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
        view.backgroundColor = UIColor.blackColor()
        chooseButton.hidden = true
    }
    
    @IBAction func pinchResponder(sender: AnyObject) {
        //zoom here!
        print("zoom zOOm")
    }
    
    
    
}