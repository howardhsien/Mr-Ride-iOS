//
//  ViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import SideMenu
import PureLayout

enum Page: Int {
    case Home
    case History
    case Map
}
extension UIViewController {
    var classDebugInfo :String { return "[\(self.dynamicType)]" }
}

class BaseViewController: UIViewController,SideMenuDelegate {

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
    
    private lazy var infoMapViewController: InfoMapViewController = { [unowned self] in
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InfoMapViewController") as! InfoMapViewController

        //delegate not needed yet
        //when I need the delegate, implement the protocol and uncomment the following line
        //        controller.delegate = self
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        return controller
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchPages(.Home)
        setupSideMenuController()
        
        //navigationBorderHidden
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)

    }
    
    //MARK: setup SideMenu
    private func setupSideMenuController(){
        sideMenuNavigationController = storyboard?.instantiateViewControllerWithIdentifier("UISideMenuNavigationController") as? UISideMenuNavigationController
        sideMenuNavigationController?.leftSide = true
        SideMenuManager.menuLeftNavigationController = sideMenuNavigationController
        //make the delegate from SideMenuTableViewController point to self
        (sideMenuNavigationController?.viewControllers[0] as? SideMenuTableViewController)?.delegate = self
        
    }
    
    @IBAction func openSideMenu(sender: UIBarButtonItem) {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion:nil)
    }
    
    //MARK: switchPages
    func switchPages(page: Page) {
        
        homeViewController.view.removeFromSuperview()
        historyViewController.view.removeFromSuperview()
        infoMapViewController.view.removeFromSuperview()
        sideMenuNavigationController?.dismissViewControllerAnimated(true, completion: nil)
        switch page {
        case .Home:
            view.addSubview(homeViewController.view)
            homeViewController.view.autoPinEdgesToSuperviewEdges()
        
        case .History:
            view.addSubview(historyViewController.view)
            historyViewController.view.autoPinEdgesToSuperviewEdges()
            
        case .Map:
            view.addSubview(infoMapViewController.view)
            infoMapViewController.view.autoPinEdgesToSuperviewEdges()
 
        }
    }

}

