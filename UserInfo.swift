//
//  UserInfo.swift
//  CoreDataDemo
//
//  Created by i mark on 09/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import CoreData

class UserInfo: NSManagedObject {
    
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var gender: String
    @NSManaged var age: String
    @NSManaged var height: String
    @NSManaged var weight: String
    @NSManaged var diabetes: String
    @NSManaged var glucose: String
    @NSManaged var user_id: String
    @NSManaged var imagePath: String
    @NSManaged var biguanide: String
    @NSManaged var no_medication: String
    @NSManaged var sulphonyl: String
    @NSManaged var a_gluc: String
}
