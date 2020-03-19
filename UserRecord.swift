//
//  UserRecord.swift
//  GlucoGenius
//
//  Created by i mark on 13/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import CoreData

class UserRecord: NSManagedObject {
    
    @NSManaged var date: String
    @NSManaged var user_id: String
    @NSManaged var speed: String
    @NSManaged var hb: String
    @NSManaged var gluc: String
    @NSManaged var pulse: String
    @NSManaged var oxSat: String
    @NSManaged var record_id: String
    @NSManaged var diet: String
    @NSManaged var medicine: String
    @NSManaged var time: String
    @NSManaged var envrHumi: String
    @NSManaged var envrTemp: String
    @NSManaged var surfHumi: String
    @NSManaged var surfTemp: String
    
    @NSManaged var battery: String

}
