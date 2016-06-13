//
//  TrackingPageViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class TrackingPageViewController: UIViewController {
    let classDebugInfo = "TrackingPageViewController"

    var rideModel = RideModel()
    //MARK: Controller
    var mapViewController: MapViewController?
    
    //MARK: ManagedObjectContext
    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
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
  //  lazy var locations = [CLLocation]()
    var currentLocation : CLLocation?

    //MARK: Timer properties
    lazy var timer = NSTimer()
    var startTime = 0.0
    let timeInterval = 1.0
    var pathCounter = 0
    
    //MARK: UI properties
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var kcalBurnedLabel: UILabel!
    @IBOutlet weak var trackControlButton: TrackingControlButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBackground()
        startLocationUpdates()

        trackControlButton.addTarget(self, action: #selector(trackControlButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }

    //MARK: UI Setting
    func setupBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.mrBlack60Color().CGColor, UIColor.mrBlack40Color().CGColor]
        gradientLayer.locations = [0.2, 0.6]
        gradientLayer.frame = view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0 )
    }
    
    func setupNavigationBar(){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        self.navigationItem.title = dateFormatter.stringFromDate(NSDate())
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    func trackControlButtonPressed(sender: UIButton){
//        print(classDebugInfo+"sender:"+String(sender.description))
        //activate the timer
        if !timer.valid{
            startTime = NSDate.timeIntervalSinceReferenceDate() - rideModel.spentTime
            timer = NSTimer.scheduledTimerWithTimeInterval(
                timeInterval,
                target: self,
                selector: #selector(timerEachCount),
                userInfo: nil,
                repeats: true)
            
            currentLocation = locationManager.location
            self.trackControlButton.makeMiddleIconSquare()
            
        }
        else{
            timer.invalidate()
            self.trackControlButton.makeMiddleIconRound()
            pathCounter += 1
        }
    }
    //MARK: Timer logic
    func timerEachCount(){
        //distance passed
        //location.timestamp can help not get the wrong location (last location)
        if let location = currentLocation{
            if let distance = locationManager.location?.distanceFromLocation(location){
                rideModel.addDistance(distance)
            }
            distanceLabel.text = String(format:"%0.0f m",rideModel.distance)
            rideModel.addLocation(location,pathCounter: pathCounter)
            //add polyline
            var coords = [CLLocationCoordinate2D]()
            coords.append(location.coordinate)
            coords.append(locationManager.location!.coordinate)

            mapViewController?.addMapPolyline(coordinates: &coords,count:2)
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
    //MARK: CoreData Logic
    func saveInCoreData() -> NSManagedObjectID{
        let savedRide = NSEntityDescription.insertNewObjectForEntityForName("RideEntity",inManagedObjectContext: managedObjectContext!) as! RideEntity
        savedRide.distance = rideModel.distance
        savedRide.spentTime = rideModel.spentTime
        savedRide.weight = rideModel.weight
        
        
//MARK: testing different date
        let dateString = "2016-07-02" // change to your date format
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        savedRide.date = dateFormatter.dateFromString(dateString)
        print("\(classDebugInfo) testing date now is \(savedRide.date)")
//        savedRide.date = NSDate()
        
        var savedRoutes = [RouteEntity]()
//        for location in rideModel.locations{
        for rideLocation in rideModel.rideLocations {
            let savedRoute = NSEntityDescription.insertNewObjectForEntityForName("RouteEntity", inManagedObjectContext: managedObjectContext!) as! RouteEntity
            savedRoute.timeStamp = rideLocation.location.timestamp
            savedRoute.latitude = rideLocation.location.coordinate.latitude
            savedRoute.longitude = rideLocation.location.coordinate.longitude

//testing path
            savedRoute.path = rideLocation.pathCount
            savedRoutes.append(savedRoute)
        }
        savedRide.routes = NSOrderedSet(array: savedRoutes)
        
        do{
            try managedObjectContext!.save()
        }
        catch{
            print(classDebugInfo+"Could not save the ride")
        }
        return savedRide.objectID
        
    }

    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        mapViewController = segue.destinationViewController as? MapViewController
    }

    //MARK: Button action (switch between views)
    @IBAction func cancelTrackingAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        timer.invalidate()
    }
    
    @IBAction func finishTrackingAction(sender: UIBarButtonItem) {
        
        let recordPageViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordPageViewController") as! RecordPageViewController
        navigationController?.pushViewController(recordPageViewController, animated: true)
        timer.invalidate()
        recordPageViewController.setRecordObjectID(saveInCoreData())
        recordPageViewController.setFromTrackingPage()
        
        
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
        mapViewController?.showMapAnnotations()
      
    }
}


