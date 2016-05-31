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
    var rideModel = RideModel()
    var currentLocation : CLLocation?

    var startTime = 0.0

    let timeInterval = 1.0
    
    //MARK: UI properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var trackControlButton: UIButton!
    @IBOutlet weak var kcalBurnedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapViewStyle()
        setupNavigationBar()
        setupBackground()
        startLocationUpdates()
        // map testing (map logic needs to be moved to a mapviewcontroller)
        mapTest()
       
        //

        trackControlButton.addTarget(self, action: #selector(trackControlButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    

    
    func trackControlButtonPressed(sender: UIButton){
//        print(classDebugInfo+"sender:"+String(sender.description))
        if !timer.valid{
            startTime = NSDate.timeIntervalSinceReferenceDate() - rideModel.spentTime
            timer = NSTimer.scheduledTimerWithTimeInterval(
                timeInterval,
                target: self,
                selector: #selector(timerEachCount),
                userInfo: nil,
                repeats: true)
            
            //distance part
            currentLocation = locationManager.location
        }
        else{
            timer.invalidate()
        }
    }
    
    func timerEachCount(){
        //distance passed
        // location.timestamp can help not get the wrong location (last location)
        if let location = currentLocation{
            if let distance = locationManager.location?.distanceFromLocation(location){
                rideModel.addDistance(distance)
            }
            distanceLabel.text = String(format:"%0.2f m",rideModel.distance)
            rideModel.addLocation(location)
            
            var coords = [CLLocationCoordinate2D]()
            coords.append(location.coordinate)
            coords.append(locationManager.location!.coordinate)
            let polyline = MKPolyline(coordinates: &coords, count: 2)
            mapView.addOverlay(polyline)
            
            currentLocation = locationManager.location
        }
        
        //time passed
        rideModel.setSpentTime(NSDate.timeIntervalSinceReferenceDate() - startTime)

        timeSpentLabel.text = String(format: "%02d:%02d:%02d", rideModel.spentTimeHourDisplay, rideModel.spentTimeMinDisplay, rideModel.spentTimeSecDisplay)
        
        //current speed
        speedLabel.text = String(format: "%.2f km / h", rideModel.speed)
        
        //calorie burned
        kcalBurnedLabel.text = String(format:"%.2f kcal",rideModel.kCalBurned)
        
    }
    //MARK: UI Setting
    func setupBackground(){
        let backgroundLayer = CALayer()
        backgroundLayer.backgroundColor = UIColor.mrBlack60Color().CGColor
        backgroundLayer.frame = view.frame
        self.view.layer.insertSublayer(backgroundLayer, atIndex: 0 )
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

    //MARK: button action to switch between views
    @IBAction func cancelTrackingAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        timer.invalidate()

    }
    
    @IBAction func finishTrackingAction(sender: UIBarButtonItem) {
        let recordPageViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordPageViewController") as! RecordPageViewController
        navigationController?.pushViewController(recordPageViewController, animated: true)
        timer.invalidate()

    }
}

// MARK: - CLLocationManagerDelegate
extension TrackingPageViewController: CLLocationManagerDelegate {
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("didupdate locations")
        mapView.showAnnotations(mapView.annotations, animated: false)

        
    }
}

//MARK: MapViewDelegate
extension TrackingPageViewController : MKMapViewDelegate{
    func mapTest(){
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
            
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return polylineRenderer
        
    }
    
}

