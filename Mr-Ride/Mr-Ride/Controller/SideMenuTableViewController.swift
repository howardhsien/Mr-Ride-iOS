//
//  SideMenuTableViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import SideMenu
import FBSDKLoginKit

protocol SideMenuDelegate :class{
    func switchPages(page:Page)
}

class SideMenuTableViewController: UITableViewController {
   var selectedPage:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)

    
    //MARK: FACEBOOK TESTING!!
    var username = ""
    @IBAction func fbLogoutAction(sender: AnyObject) {
       
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            () -> Void in
            appDelegate.window?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController")
            }, completion: nil)
    }
    
    func setupFacebookUserName()  {
    
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name"]).startWithCompletionHandler({ [unowned self](connection, result, error) -> Void in
            if (error == nil){
                self.username = result["name"] as! String
            }
            else{
                self.username =  "nil"
            }
        })
    
    }
    
    
    
    
    // MARK: properties
    let pages: [Page:String] = [
        .Home: "Home",
        .History: "History",
        .Map: "Map" ]
    let sideMenuCellIdentifier = "SideMenuCell"
    weak var delegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SideMenuViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: sideMenuCellIdentifier)
        setupSideBarStyle()
        setupFacebookUserName()
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.title = username
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRowAtIndexPath(selectedPage, animated: false,scrollPosition: .None)
    }
    
    func setupSideBarStyle(){
        self.view.backgroundColor = UIColor.mrDarkSlateBlueColor()
        
        self.navigationController?.navigationBarHidden = true
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuShadowColor = UIColor.clearColor()
        SideMenuManager.menuWidth = 260
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sideMenuCellIdentifier, forIndexPath: indexPath) as! SideMenuViewCell
        
        switch Page(rawValue:indexPath.row)!{
        case .Home: cell.setPageLabelText(pages[.Home]!)
        case .History: cell.setPageLabelText(pages[.History]!)
        case .Map: cell.setPageLabelText(pages[.Map]!)
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //update the selected page
        selectedPage = indexPath
        switch Page(rawValue: indexPath.row)! {
        case .Home:
            delegate?.switchPages(.Home)
        case .History:
            delegate?.switchPages(.History)
        case .Map:
            delegate?.switchPages(.Map)
        }
    }
    
    //MARK: - header of tableView
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dummyHeaderView = UIView(frame: CGRectMake(0, 0, view.frame.width, 100))
        dummyHeaderView.backgroundColor = UIColor.clearColor()
        return dummyHeaderView
    }
 



}
