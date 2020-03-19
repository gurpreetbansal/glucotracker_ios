//
//  UserMeasurementSettings.swift
//  Vigori Diary
//
//  Created by i mark on 19/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import CoreData

class UserMeasurementSettings: NSManagedObject {

    @NSManaged var twoHrFastGlucoseMin: Double
    @NSManaged var twoHrFastGlucoseMax: Double
    @NSManaged var mrngFastGlucoseMin: Double
    @NSManaged var mrngFastGlucoseMax: Double
    @NSManaged var pulseMin: Double
    @NSManaged var pulseMax: Double
    @NSManaged var oxSatMin: Double
    @NSManaged var oxSatMax: Double
    @NSManaged var hbMin: Double
    @NSManaged var hbMax: Double
    @NSManaged var bloodFlowMin: Double
    @NSManaged var bloodFlowMax: Double
    @NSManaged var user_id: String
    @NSManaged var measurementSetting_id: String
    @NSManaged var email: String
    @NSManaged var email2: String
    @NSManaged var email3: String

}
