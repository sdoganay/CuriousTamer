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
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    
    var audioPlayer = AVAudioPlayer()
    var leftSwipe : UISwipeGestureRecognizer!
    var rightSwipe : UISwipeGestureRecognizer!
    
    
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var webViewBG: UIWebView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftSwipe = UISwipeGestureRecognizer(target:self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        
        rightSwipe = UISwipeGestureRecognizer(target:self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer){
        imageView.hidden = true
        prepareScaryGif()
        prepareScarySound("scaryScream")
        
        //Gif to be seen.
        self.view.addSubview(webViewBG)
        audioPlayer.play()
        //Sound to be heard.
        
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            //put your code which should be executed with a delay here
            self.captureImage()
            
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.webViewBG.hidden = true
                self.imageView.hidden = false
                self.prepareScarySound("evilLaugh")
                self.audioPlayer.play()
                self.popUpBustedMessage()
                print("BUSTED")
            }
        }
    }
    
    
    func popUpBustedMessage(){
        let alert = UIAlertController(title: "YOU ARE BUSTED!", message: "What a shame! You were peeping some photos...", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK, you got me!", style: UIAlertActionStyle.Default, handler: {
            action in
            switch action.style{
            case .Default:
                print("default")
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    //ekran karart
                    self.imageView.image = UIImage(named: "youFinger.png")
                    
                    //swipePassword
                    print("swipePassword yerindeyim!")
                    
                }
                
            case .Cancel:
                print("cancel")
            case .Destructive:
                print("destructive")
            }
        }))

        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetMedium
        
        let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        var captureDevice : AVCaptureDevice?
        
        for device in videoDevices{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.Front {
                captureDevice = device
                break
            }
        }
        
        var input : AVCaptureDeviceInput?
        do{
            input = try AVCaptureDeviceInput(device: captureDevice)}catch{}
        
        if((captureSession?.canAddInput(input)) != nil){
            captureSession?.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            if((captureSession?.canAddOutput(stillImageOutput)) != nil){
                captureSession?.addOutput(stillImageOutput)
                captureSession?.startRunning()
                print("captureSession running..")
            }
            
        }
        
    }
    
    
    
    func captureImage(){
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                if(sampleBuffer != nil ){
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true,CGColorRenderingIntent.RenderingIntentDefault)
                    let image = UIImage(CGImage: cgImageRef!,scale: 1.0, orientation: UIImageOrientation.Right)
                    print("snaap! :) ")
                    
                    self.imageView.image = image
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    print("DONE!")
                }
            })
        }
        
        
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        print("documents path given..")
        return documentsDirectory
    }
    
    func prepareScaryGif(){
        let filePath = NSBundle.mainBundle().pathForResource("scarryClown", ofType: ".gif")
        let scarryGif = NSData(contentsOfFile: filePath!)
        webViewBG.loadData(scarryGif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false;
    }
    
    func prepareScarySound(soundName: String){
        let scarySound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!)
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOfURL: scarySound, fileTypeHint: nil)
            audioPlayer.prepareToPlay()
        }catch{
            print("AVAudioSession problem occured.")
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
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        chooseButton.hidden = true
        imageView.image = image
        imageView.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func pinchResponder(sender: AnyObject) {
        //zoom here!
        print("zoom zOOm")
        
    }
    
    
    
}