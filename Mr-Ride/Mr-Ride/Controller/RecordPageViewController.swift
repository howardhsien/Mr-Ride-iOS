//
//  RecordPageViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class RecordPageViewController: UIViewController {
    let classDebugInfo = "[RecordPageViewController]"
  
    var objectID :NSManagedObjectID?
    let rideModel = RideModel()
    var mapViewController :MapViewController?
    var dataManager = DataManager.instance()
    var rideEntities :[RideEntity] { return dataManager.rideEntities }
    
    //MARK: UI properties
    @IBOutlet weak var distancLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        if objectID != nil {
            dataManager.fetchFromCoreData(){
                [unowned self] in
                self.prepareForData()
                self.setupUIDisplay()
                self.setupMap()
            }
        }
    }
    
    
    //MARK: customize from different pages
    func setFromTrackingPage(){
        setupNavigationBar()
    }
    // called from tracking page
    func setRecordObjectID(objectID: NSManagedObjectID){
        self.objectID = objectID
    }
    
    func setFromHistoryPage(){
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    //MARK: UI setup
    func setupNavigationBar() {
        let closeButton = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(closeAction(_:)))
        closeButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    func setupBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.mrBlack60Color().CGColor, UIColor.mrBlack40Color().CGColor]
        gradientLayer.locations = [0.2, 0.6]
        gradientLayer.frame = view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0 )
    }
    
    func setupUIDisplay() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        navigationItem.title = dateFormatter.stringFromDate(rideModel.date)
        distancLabel.text = String(format: "%0.0f m",rideModel.distance)
        totalTimeLabel.text = String(format: "%02d:%02d:%02d", rideModel.spentTimeHourDisplay, rideModel.spentTimeMinDisplay, rideModel.spentTimeSecDisplay)
        speedLabel.text = String(format: "%.2f km / h", rideModel.speed)
        calorieLabel.text = String(format:"%.2f kcal",rideModel.kCalBurned)
    }
    
    private func prepareForData(){
        //get all the data needed to be display
        guard let index = rideEntities.indexOf({$0.objectID == objectID})else{
            print(classDebugInfo+"(fetchFromCoreDate) can't find objectID to set index")
            return
        }
        let rideEntity = rideEntities[index]
        
        guard let spentTime = rideEntity.spentTime as? Double else{
            print(classDebugInfo+"rideEntity spentTime can't be cast to double")
            return
        }
        guard let distance = rideEntity.distance as? Double else{
            print(classDebugInfo+"rideEntity distance can't be cast to double")
            return
        }
        guard let date = rideEntity.date else{
            print(classDebugInfo+"getting rideEntity date has some problem")
            return
        }
        guard let routeEntities = rideEntity.routes?.array as? [RouteEntity] else{
            print(classDebugInfo+"rideEntity routes can't be cast to [RouteEntity]")
            return
        }
        rideModel.setSpentTime(spentTime)
        rideModel.setDistance(distance)
        rideModel.setDate(date)
        for routeEntity in routeEntities{
            guard let latitude = routeEntity.latitude as? Double else{ return }
            guard let longitude = routeEntity.longitude as? Double else{ return }
            let pathCounter = routeEntity.path == nil ? 0 : routeEntity.path as! Int
            rideModel.addLocation(CLLocation(latitude: latitude , longitude: longitude), pathCounter: pathCounter)
        }
    }
    
    
    //MARK: feed data to mapViewController
    func setupMap(){
        addPolylineInMap()
        mapViewController?.invalidateUserLocation()
    }
    
    func addPolylineInMap(){
        var coords = [CLLocationCoordinate2D]()         //this is for current polyline
        var coordsForRect = [CLLocationCoordinate2D]()  //this records the whole route polyline but not added to map overlay
        

        var pathCount = -1
        for rideLocation in rideModel.rideLocations{
            if pathCount != rideLocation.pathCount {
                mapViewController?.addMapPolyline(coordinates: &coords,count:coords.count)
                coords.removeAll()
                pathCount += 1
            }

            coords.append(rideLocation.location.coordinate)
            coordsForRect.append(rideLocation.location.coordinate)
            
        }

        mapViewController?.setMapRect(coordinates: &coordsForRect,count:coordsForRect.count)
        mapViewController?.addMapPolyline(coordinates: &coords,count:coords.count)
        mapViewController?.showMapPolyline()
    }

    //MARK: Switch between pages
    func closeAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        mapViewController = segue.destinationViewController as? MapViewController
    }
    


}

  
   

