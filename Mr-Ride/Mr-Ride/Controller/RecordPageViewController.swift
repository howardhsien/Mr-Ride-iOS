//
//  RecordPageViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class RecordPageViewController: UIViewController {
    let classDebugInfo = "RecordPageViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        // Do any additional setup after loading the view.
    }
    
    func setupBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.mrBlack60Color().CGColor, UIColor.mrBlack40Color().CGColor]
        gradientLayer.locations = [0.2, 0.6]
        gradientLayer.frame = view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0 )
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
