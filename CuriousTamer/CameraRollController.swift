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
        prepareScarySound()
        
        //Gif to be seen.
        self.view.addSubview(webViewBG)
        
        //Sound to be heard.
        audioPlayer.play()
        captureImage()
        
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
        //        let imagePickerFromCamera = UIImagePickerController()
        //        imagePickerFromCamera.delegate = self
        //
        //        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
        //            imagePickerFromCamera.sourceType = UIImagePickerControllerSourceType.Camera
        //        }else{
        //            print("No camera available!")
        //        }
        //        presentViewController(imagePickerFromCamera, animated: true, completion: nil)
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                if(sampleBuffer != nil ){
                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    var dataProvider = CGDataProviderCreateWithCFData(imageData)
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true,CGColorRenderingIntent.RenderingIntentDefault)
                    var image = UIImage(CGImage: cgImageRef!,scale: 1.0, orientation: UIImageOrientation.Right)
                    print("snaap! :) ")
                    self.imageView.image = image
                    self.imageView.hidden = false
                    
                    let date = NSDate()
                    let calendar = NSCalendar.currentCalendar()
                   let components = calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Minute), fromDate: date)
                    let hour = components.hour
                    let minutes = components.minute
                    let day = date.description
                   print("Scared_\(day)-\(hour):\(minutes).jpeg is writing..")
//                    if let data = UIImagePNGRepresentation(image) {
//                        let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("Scared_\(day)-\(hour):\(minutes).png")
//                        data.writeToFile(filename, atomically: true)
//                    }
                    
//                    if let data = UIImageJPEGRepresentation(image, 0.8) {
//                            let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("Scared_\(day)-\(hour):\(minutes).jpeg")
//                        data.writeToFile(filename, atomically: true)
//                        print("file is done!")
//                    }
                    
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
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismissViewControllerAnimated(true, completion: nil)
    //    }
    
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
        chooseButton.hidden = true
        imageView.image = image
        imageView.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
        //        view.backgroundColor = UIColor.blackColor()
        
    }
    
    @IBAction func pinchResponder(sender: AnyObject) {
        //zoom here!
        print("zoom zOOm")
    }
    
    
    
}