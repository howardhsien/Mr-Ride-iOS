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
    
    //MARK: controllers which embedded in the baseViewController
    private var sideMenuNavigationController: UISideMenuNavigationController?
    private lazy var homeViewController: HomeViewController = { [unowned self] in
        
        let controller = HomeViewController.controller()
        //delegate not needed yet
        //when I need the delegate, implement the protocol and uncomment the following line
        //        controller.delegate = self
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        return controller
        }()
    
    private lazy var historyViewController: HistoryViewController = { [unowned self] in
        
        let controller = HistoryViewController.controller()
        //delegate not needed yet
        //when I need the delegate, implement the protocol and uncomment the following line
        //        controller.delegate = self
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        return controller
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenuController()
        setupSideMenuAttritibute()
    }
    
    //MARK: setup SideMenu
    private func setupSideMenuController(){
        sideMenuNavigationController = storyboard?.instantiateViewControllerWithIdentifier("UISideMenuNavigationController") as? UISideMenuNavigationController
        sideMenuNavigationController?.leftSide = true
        SideMenuManager.menuLeftNavigationController = sideMenuNavigationController
        
    }
    
    private func setupSideMenuAttritibute(){
        SideMenuManager.menuFadeStatusBar = false
    }
    
    @IBAction func openSideMenu(sender: UIBarButtonItem) {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion:nil)
    }
    
    func switchPages(page: Page) {
        
    }



}

