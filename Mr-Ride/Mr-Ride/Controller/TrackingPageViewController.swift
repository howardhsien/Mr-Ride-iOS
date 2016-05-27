//
//  TrackingPageViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TrackingPageViewController: UIViewController {
    let classDebugInfo = "TrackingPageViewController"

    //MARK: Location and route properties
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    var seconds = 0.0
    var distance = 0.0

    //MARK: UI properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
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

// MARK: - CLLocationManagerDelegate
extension TrackingPageViewController: CLLocationManagerDelegate {
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate locations")
        for location in locations {
            if location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last!)
                }
                
                //save location
                self.locations.append(location)
            }
        }
        
    }
    
    
}

