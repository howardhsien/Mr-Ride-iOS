//
//  SideMenuTableViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

protocol SideMenuDelegate :class{
    func switchPages(page:Page)
}
class SideMenuTableViewController: UITableViewController {
    
    let classDebugInfo = "[SideMenuTableViewController]"
    
    // MARK: properties
    let pages: [Page:String] = [
        .Home: "Home",
        .History: "History"]
    let sideMenuCellIdentifier = "SideMenuCell"
    var delegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SideMenuViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: sideMenuCellIdentifier)

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pages.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sideMenuCellIdentifier, forIndexPath: indexPath) as! SideMenuViewCell
        
        switch Page(rawValue:indexPath.row)!{
        case .Home: cell.setPageLabelText(pages[.Home]!)
        case .History: cell.setPageLabelText(pages[.History]!)
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch Page(rawValue: indexPath.row)! {
        case .Home:
            delegate?.switchPages(.Home)
        case .History:
            delegate?.switchPages(.History)

        }
    }
 



}
