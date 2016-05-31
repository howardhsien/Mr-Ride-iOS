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
    var currentLocation : CLLocation?
    var spentTime_s = 0.0
    var startTime = 0.0
    var distance_m = 0.0
    var speed_km_per_hr = 0.0
    let timeInterval = 1.0
    let weight = 70.0

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
            startTime = NSDate.timeIntervalSinceReferenceDate() - spentTime_s
            timer = NSTimer.scheduledTimerWithTimeInterval(
                timeInterval,
                target: self,
                selector: #selector(TrackingPageViewController.timerEachCount),
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
                self.distance_m += distance
            }
            distanceLabel.text = String(format:"%0.2f m",self.distance_m)
            locations.append(location)
            
            var coords = [CLLocationCoordinate2D]()
            coords.append(location.coordinate)
            coords.append(locationManager.location!.coordinate)
            let polyline = MKPolyline(coordinates: &coords, count: 2)
            mapView.addOverlay(polyline)
            
            currentLocation = locationManager.location

        }
        //time passed
        spentTime_s = NSDate.timeIntervalSinceReferenceDate() - startTime
        let spentTimeSec = Int(spentTime_s % 60)
        let spentTimeMin = Int(spentTime_s / 60)
        let spentTimeHour = Int(spentTimeMin/60)
        timeSpentLabel.text = String(format: "%02d:%02d:%02d", spentTimeHour % 60,spentTimeMin % 60,spentTimeSec)
        
        //current speed
        let speed_m_per_s = self.distance_m/spentTime_s
        speed_km_per_hr = speed_m_per_s * 3.6
        speedLabel.text = String(format: "%.2f km / h", speed_km_per_hr)
        
        //calorie burned
        let calorieCalculator = CalorieCalculator()
        let kCalBurned = calorieCalculator.kiloCalorieBurned(.Bike, speed: speed_km_per_hr, weight: weight, time: spentTime_s/3600)
        kcalBurnedLabel.text = String(format:"%.2f kcal",kCalBurned)
        
    }
    
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

