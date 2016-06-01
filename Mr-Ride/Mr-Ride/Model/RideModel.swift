//
//  RideModel.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/31.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import CoreLocation

struct Ride {
    var spentTime:Double = 0.0
    var distance_m:Double = 0.0
    var weight:Double = 70.0
    var routes:[CLLocation] = []
    var date:NSDate = NSDate()
}


class RideModel {
    let classDebugInfo = "[RideModel]"
    
    let calorieCalculator = CalorieCalculator()
    private var _ride = Ride()
    var ride :Ride {
        return _ride
    }
    
    
    // unit: km/h
    var speed: Double{
        return (_ride.distance_m/_ride.spentTime)*3.6
    }
    // unit: s
    var spentTime: Double{
        return _ride.spentTime
    }
    // unit: m
    var distance: Double{
        return _ride.distance_m
    }
    // unit: kg
    var weight: Double{
        return _ride.weight
    }
    // unit: kcal
    var kCalBurned: Double{
        return calorieCalculator.kiloCalorieBurned(.Bike, speed: speed, weight: _ride.weight, time: spentTime/3600)
    }
    
    var date : NSDate{
        return _ride.date
    }
    var locations : [CLLocation]{
        return _ride.routes
    }
    
    // time to display on timer
    var spentTimeSecDisplay :Int{ return Int(spentTime % 60) }
    var spentTimeMinDisplay :Int{ return Int(spentTime / 60) % 60 }
    var spentTimeHourDisplay :Int{ return Int(spentTime / 3600) % 24}
    

    
    func addLocation(location:CLLocation){
        if (location.coordinate.latitude != _ride.routes.last?.coordinate.latitude && location.coordinate.longitude != _ride.routes.last?.coordinate.longitude){
            _ride.routes.append(location)
        }
    }
    
    func setSpentTime(time : Double) {
        _ride.spentTime = time
    }
    
    func setDistance(distance : Double) {
        _ride.distance_m = distance
    }
    
    func setRoutes(routes : [CLLocation]) {
        _ride.routes = routes
    }
    
    func addDistance(distance : Double) {
        _ride.distance_m += distance
    }


}