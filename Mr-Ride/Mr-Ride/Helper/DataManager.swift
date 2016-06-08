//
//  DataManager.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/8.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import CoreData

class DataManager :NSObject, NSFetchedResultsControllerDelegate{
    private static var _instance = DataManager()
    class func instance() -> DataManager{
        return _instance
    }
    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var rideEntities : [RideEntity] = []
    var sortedKeys : [NSDateComponents]{  return Array(dateRideDictionary.keys).sort{$0.month > $1.month} ?? [] }
    var dateRideDictionary : [NSDateComponents: [RideEntity]] = [:]
    var totalDistance : Double {  //unit: m
        return rideEntities.reduce(0.0, combine: {
            guard let distance = $1.distance else{ return 0.0}
            return  Double(distance)+$0})
    }
    var totalTime : Double {
        return rideEntities.reduce(0.0, combine: {
            guard let time = $1.spentTime else{ return 0.0}
            return  Double(time)+$0})
    }
    var totalCount : Int {
        return rideEntities.count
    }
    var averageSpeed : Double { // unit: m/s
        if totalTime == 0.0{
            return 0.0
        }
        return totalDistance/totalTime
    }
    
    
    typealias VoidFunc = ()->()
    func fetchFromCoreData(completion:VoidFunc){
        let fetchRequest = NSFetchRequest(entityName: "RideEntity")
        let sortDesriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDesriptor]
        
        if let managedObjectContext = managedObjectContext{
            let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                if let rideEntities = fetchResultController.fetchedObjects as? [RideEntity]
                {
                    self.rideEntities = rideEntities
                }
            }
            catch{
                print(error)
            }
            //categorize the data every fetch
            dateRideDictionary = self.categorizeByMonth(rideEntities)
            completion()
            
        }
    }
    
    //Mark: categorize data by month
    func categorizeByMonth(rideEntities: [RideEntity]) ->[NSDateComponents: [RideEntity]] {
        let calendar = NSCalendar.currentCalendar()
        
        var myDictionary = [NSDateComponents: [RideEntity]]()
        
        for rideEntity in rideEntities{
            if let date = rideEntity.date{
                let components = calendar.components([.Month,.Year], fromDate: date)
                if myDictionary[components] != nil{
                    myDictionary[components]!.append(rideEntity)
                }
                else{
                    myDictionary[components] = [rideEntity]
                }
            }
        }
        return myDictionary
    }

    
    
    
}