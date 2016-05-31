//
//  HomeViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let classDebugInfo = "[HomeViewController]"
    
    @IBOutlet weak var rideButton: UIButton!
    class func controller() ->HomeViewController{
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    //    setupBackground()
        setupButtonStyle()
        setupNavigationStyle()
        // Do any additional setup after loading the view.
    }
    
    //TODO: the gradient layer needs to be modified
    func setupBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ UIColor.mrLightblueColor(),UIColor.mrWaterBlueColor().CGColor, UIColor.mrRobinsEggBlue0Color().CGColor,UIColor.mrLightblueColor()]
        gradientLayer.locations = [0.35, 0.5, 1]
        gradientLayer.frame = view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0 )
    }
    
    
    @IBAction func startTrackingPageAction(sender: UIButton) {
        let trackingPageNavController = storyboard?.instantiateViewControllerWithIdentifier("TrackingPageNavigationController")
        self.presentViewController(trackingPageNavController!, animated: true, completion: nil)
    }
    
    func setupButtonStyle(){
        rideButton.layer.cornerRadius = 30
        rideButton.layer.shadowColor = UIColor.blackColor().CGColor
        rideButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        rideButton.layer.shadowOpacity = 0.25
        rideButton.layer.shadowRadius = 2.0
    }
    
    func setupNavigationStyle(){
        let bikeIconImageView = UIImageView(image:UIImage(named: "icon-bike"))
        bikeIconImageView.image = bikeIconImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        bikeIconImageView.tintColor = .whiteColor()
        self.parentViewController?.navigationItem.titleView = bikeIconImageView
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
