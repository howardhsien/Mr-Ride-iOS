//
//  TrackingPageViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit

class TrackingPageViewController: UIViewController {
    let classDebugInfo = "TrackingPageViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapViewStyle()
        setupNavigationBar()

    }
    func setupNavigationBar(){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        self.navigationItem.title = dateFormatter.stringFromDate(NSDate())
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
    }
    
    func setupMapViewStyle() {
        mapView.layer.cornerRadius = 10
    }


    @IBAction func cancelTrackingAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func finishTrackingAction(sender: UIBarButtonItem) {
        let recordPageViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordPageViewController") as! RecordPageViewController
        navigationController?.pushViewController(recordPageViewController, animated: true)
    }



}
