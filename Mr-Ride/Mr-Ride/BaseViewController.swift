//
//  ViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import SideMenu

enum Page: Int {
    case Home
    case History
}

class BaseViewController: UIViewController,SideMenuDelegate {
    let classDebugInfo = "[BaseViewController]"
    
    class func controller() ->BaseViewController{
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BaseViewController") as! BaseViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuAttritibute()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setSideMenuAttritibute(){
        SideMenuManager.menuFadeStatusBar = false
    }
    
    func switchPages() {
        
    }



}

