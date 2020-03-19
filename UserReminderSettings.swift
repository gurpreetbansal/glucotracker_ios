//
//  UserReminderSettings.swift
//  Vigori Diary
//
//  Created by i mark on 30/11/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import CoreData

class UserReminderSettings: NSManagedObject {

    @NSManaged var heading: String
    @NSManaged var measure_medication: String
    @NSManaged var state: String
    @NSManaged var time: String
    @NSManaged var user_id: String
    @NSManaged var reminderSettings_id: String
    @NSManaged var row: String

}
