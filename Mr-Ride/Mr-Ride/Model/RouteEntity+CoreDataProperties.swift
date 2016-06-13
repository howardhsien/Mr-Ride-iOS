//
//  RouteEntity+CoreDataProperties.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/1.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RouteEntity {

    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var path: NSNumber?
    @NSManaged var ride: RideEntity?

}
