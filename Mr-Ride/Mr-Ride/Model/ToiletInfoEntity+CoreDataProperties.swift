//
//  ToiletInfoEntity+CoreDataProperties.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/22.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ToiletInfoEntity {

    @NSManaged var category: String?
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?

}
