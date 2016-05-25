//
//  TrackingPageViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class TrackingPageViewController: UIViewController {
    let classDebugInfo = "TrackingPageViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func cancelTrackingAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func finishTrackingAction(sender: UIBarButtonItem) {
        let recordPageViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordPageViewController") as! RecordPageViewController
        navigationController?.pushViewController(recordPageViewController, animated: true)
    }



}
