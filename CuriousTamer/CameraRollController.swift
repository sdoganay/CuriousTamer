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
    
    var audioPlayer = AVAudioPlayer()
    var leftSwipe : UISwipeGestureRecognizer!
    var rightSwipe : UISwipeGestureRecognizer!
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var webViewBG: UIWebView!
    
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
        imageView.image = nil
        prepareScaryGif()
        prepareScarySound()
        
        //Gif to be seen.
        self.view.addSubview(webViewBG)
        
        //Sound to be heard.
        audioPlayer.play()
        
        
    }
    func prepareScaryGif(){
        let filePath = NSBundle.mainBundle().pathForResource("scarryClown", ofType: ".gif")
        let scarryGif = NSData(contentsOfFile: filePath!)
//        webViewBG.backgroundColor = UIColor.blackColor()
        webViewBG.loadData(scarryGif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false;
    }
    
    func prepareScarySound(){
        let scarySound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("scaryScream", ofType: "mp3")!)
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOfURL: scarySound, fileTypeHint: nil)
            audioPlayer.prepareToPlay()
        }catch{
            print("probleeem")
        }
        
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
//        view.backgroundColor = UIColor.blackColor()
        chooseButton.hidden = true
    }
    
    @IBAction func pinchResponder(sender: AnyObject) {
        //zoom here!
        print("zoom zOOm")
    }
    
    
    
}