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
    let classDebugInfo = "RecordPageViewController"

    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    let rideModel = RideModel()
    var mapViewController :MapViewController?
    
    //MARK: UI properties
    @IBOutlet weak var distancLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavigationBar()
        fetchFromCoreDate()
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
    
    
    //MARK: feed data to mapViewController
    func setupMap(){
        addPolylineInMap()
        mapViewController?.invalidateUserLocation()
    }
    
    func addPolylineInMap(){
        var coords = [CLLocationCoordinate2D]()
        for location in rideModel.locations
        {
            coords.append(location.coordinate)
        }
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

//MARK: FetchedResultsControllerDelegate
extension RecordPageViewController :  NSFetchedResultsControllerDelegate{
  
    
    func fetchFromCoreDate(){
        let fetchRequest = NSFetchRequest(entityName: "RideEntity")
        let sortDesriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDesriptor]
        
        if let managedObjectContext = managedObjectContext{
            let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                if let rideEntities = fetchResultController.fetchedObjects as? [RideEntity]
                {
                    guard let rideEntity = rideEntities.last else{
                        print(classDebugInfo+"rideEntity can't be initialized")
                        return
                    }
                    guard let spentTime = rideEntity.spentTime as? Double else{
                        print(classDebugInfo+"rideEntity spentTime can't be cast to double")
                        return
                    }
                    guard let distance = rideEntity.distance as? Double else{
                        print(classDebugInfo+"rideEntity distance can't be cast to double")
                        return
                    }
                    guard let routeEntities = rideEntity.routes?.array as? [RouteEntity] else{
                        print(classDebugInfo+"rideEntity routes can't be cast to [RouteEntity]")
                        return
                    }
                    rideModel.setSpentTime(spentTime)
                    rideModel.setDistance(distance)
                    for routeEntity in routeEntities{
                        guard let latitude = routeEntity.latitude as? Double else{ return }
                        guard let longitude = routeEntity.longitude as? Double else{ return }
                        
                        rideModel.addLocation(CLLocation(latitude: latitude , longitude: longitude))
                    }
                }
            }
            catch{
                print(error)
            }
            setupUIDisplay()
            setupMap()
        }
    }

}
