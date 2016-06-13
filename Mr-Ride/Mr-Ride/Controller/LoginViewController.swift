//
//  LoginViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/13.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    let classDebugInfo = "[LoginViewController]"

    @IBOutlet weak var heightContainerView: UIView!
    @IBOutlet weak var weightContainerView: UIView!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var fbLoginButton: UIButton! //height = 50
    @IBOutlet weak var experienceButton: UIButton! //height = 50
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    //MARK: UISetting
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFieldRoundedCorner()
        setupButtonRoundedCorner()
        setupBackground()
        experienceButton.addTarget(self, action: #selector(experienceAction), forControlEvents: .TouchUpInside)
        setFieldDelegate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setupBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.mrLightblueColor().CGColor, UIColor.mrPineGreen50().CGColor]
        gradientLayer.locations = [0.6, 1]
        gradientLayer.frame = view.frame

        self.view.layer.insertSublayer(gradientLayer, atIndex: 0 )
        view.sendSubviewToBack(backgroundImageView) // this to put background behind button and gradient filter

    }
    
    func setupFieldRoundedCorner() {
        heightContainerView.layer.cornerRadius = 4.0
        heightContainerView.layer.masksToBounds = true
        weightContainerView.layer.cornerRadius = 4.0
        weightContainerView.layer.masksToBounds = true
    }
    
    func setupButtonRoundedCorner() {
        fbLoginButton.layer.cornerRadius = 25
        experienceButton.layer.cornerRadius = 25
    }
    
    //MARK: TextField Setting
    func setFieldDelegate() {
        heightField.delegate = self
        weightField.delegate = self
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        let filtered = components.joinWithSeparator("")
        return string == filtered
  
    }
    
    //MARK: Experience
    func experienceAction(){
        checkInputOfFields(){
            [unowned self] in
            let baseNavViewController = self.storyboard?.instantiateViewControllerWithIdentifier("baseNavigationViewController") as? UINavigationController
            guard let window = UIApplication.sharedApplication().keyWindow else{ return }
            UIView.transitionWithView(window, duration: 0.5, options: .TransitionCurlUp, animations: {window.rootViewController = baseNavViewController}, completion: nil)
//            UIApplication.sharedApplication().keyWindow?.rootViewController = baseNavViewController
        }
    }
    
    func checkInputOfFields(completion: ()->()){
        guard let heightText = heightField.text else { return }
        guard let height = Double(heightText) else{
            let alertController = UIAlertController(title: "Wrong input", message:
                "Make sure the format of height is correct!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        guard let weightText = weightField.text else { return }
        guard let weight = Double(weightText) else{
            let alertController = UIAlertController(title: "Wrong input", message:
                "Make sure the format of weight is correct!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        completion()
        
    }
    


}
