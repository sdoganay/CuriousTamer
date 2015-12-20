//
//  CameraRollController.swift
//  CuriousTamer
//
//  Created by Seda Nur Doganay on 19/12/15.
//  Copyright © 2015 Seda Nur Doganay. All rights reserved.
//

import UIKit

class CameraRollController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
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
        if(imageView.image != nil){
        if(sender.direction == .Left){
            print("left")
        } else  if(sender.direction == .Right){
            print("right")
        }
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
        view.backgroundColor = UIColor.blackColor()
        chooseButton.hidden = true
    }
    
    @IBAction func pinchResponder(sender: AnyObject) {
        //zoom here!
        print("zoom zOOm")
    }
    
    
    
}