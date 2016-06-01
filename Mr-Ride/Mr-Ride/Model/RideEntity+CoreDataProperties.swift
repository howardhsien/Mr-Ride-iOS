//
//  RideEntity+CoreDataProperties.swift
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

extension RideEntity {

    @NSManaged var spentTime: NSNumber?
    @NSManaged var distance: NSNumber?
    @NSManaged var weight: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var routes: NSOrderedSet?

}
