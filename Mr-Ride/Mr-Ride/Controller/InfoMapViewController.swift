//
//  InfoMapViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/16.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class InfoMapViewController: UIViewController {

    class func controller() ->InfoMapViewController{
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InfoMapViewController") as! InfoMapViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
