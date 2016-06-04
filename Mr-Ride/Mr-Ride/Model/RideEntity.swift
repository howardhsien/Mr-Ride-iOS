//
//  RideEntity.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/1.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import CoreData


class RideEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    var spentTimeSecDisplay :Int{ return Int(spentTime as! Double % 60) }
    var spentTimeMinDisplay :Int{ return Int(spentTime as! Double / 60) % 60 }
    var spentTimeHourDisplay :Int{ return Int(spentTime as! Double / 3600) % 24}

}
