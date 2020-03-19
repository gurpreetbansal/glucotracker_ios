//
//  CoreData.swift
//  CoreDataDemo
//
//  Created by i mark on 09/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import CoreData

class CoreData: NSObject {
    
    //MARK:- Properties
    
    var userInfoObj = [NSManagedObject]()
    var userRecordObj = [NSManagedObject]()
    var userMeasurementSettingObj = [NSManagedObject]()
    var userReminderSettingObj = [NSManagedObject]()
    
    override init() {
        super.init()
    }
    
    //MARK:- Methods to Fetch Data
    
    func fetchRequestForUserInfo()->NSMutableDictionary
    {
        let person:NSMutableDictionary = NSMutableDictionary()
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        
        fetchRequest.predicate = NSPredicate(format: "user_id = %@", user_id)
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            userInfoObj = results as! [NSManagedObject]
            
            for res in results {
                person.setValue((res as AnyObject).value(forKey: "username"), forKey: "username")
                person.setValue((res as AnyObject).value(forKey: "password"), forKey: "password")
                person.setValue((res as AnyObject).value(forKey: "age"), forKey: "age")
                person.setValue((res as AnyObject).value(forKey: "height"), forKey: "height")
                person.setValue((res as AnyObject).value(forKey: "weight"), forKey: "weight")
                person.setValue((res as AnyObject).value(forKey: "user_id"), forKey: "user_id")
                person.setValue((res as AnyObject).value(forKey: "diabetes"), forKey: "diabetes")
                person.setValue((res as AnyObject).value(forKey: "glucose"), forKey: "glucose")
                person.setValue((res as AnyObject).value(forKey: "gender"), forKey: "gender")
                person.setValue((res as AnyObject).value(forKey: "imagePath"), forKey: "imagePath")
                
                person.setValue((res as AnyObject).value(forKey: "biguanide"), forKey: "biguanide")
                person.setValue((res as AnyObject).value(forKey: "sulphonyl"), forKey: "sulphonyl")
                person.setValue((res as AnyObject).value(forKey: "a_gluc"), forKey: "a_gluc")
                person.setValue((res as AnyObject).value(forKey: "no_medication"), forKey: "no_medication")
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return person
    }
    
    func allRegisterUsers()->[NSMutableDictionary]
    {
        var recordArr = [NSMutableDictionary]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        do {
            let results = try managedContext.fetch(fetchRequest)
            userInfoObj = results as! [NSManagedObject]
            for res in results {
                let person:NSMutableDictionary = NSMutableDictionary()
                
                person.setValue((res as AnyObject).value(forKey: "username"), forKey: "username")
                person.setValue((res as AnyObject).value(forKey: "password"), forKey: "password")
                person.setValue((res as AnyObject).value(forKey: "age"), forKey: "age")
                person.setValue((res as AnyObject).value(forKey: "height"), forKey: "height")
                person.setValue((res as AnyObject).value(forKey: "weight"), forKey: "weight")
                person.setValue((res as AnyObject).value(forKey: "user_id"), forKey: "user_id")
                person.setValue((res as AnyObject).value(forKey: "diabetes"), forKey: "diabetes")
                person.setValue((res as AnyObject).value(forKey: "glucose"), forKey: "glucose")
                person.setValue((res as AnyObject).value(forKey: "gender"), forKey: "gender")
                person.setValue((res as AnyObject).value(forKey: "imagePath"), forKey: "imagePath")
                
                person.setValue((res as AnyObject).value(forKey: "biguanide"), forKey: "biguanide")
                person.setValue((res as AnyObject).value(forKey: "sulphonyl"), forKey: "sulphonyl")
                person.setValue((res as AnyObject).value(forKey: "a_gluc"), forKey: "a_gluc")
                person.setValue((res as AnyObject).value(forKey: "no_medication"), forKey: "no_medication")
                
                recordArr.append(person)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return recordArr
    }
    
    func fetchRequestForMeasurementRecord()->[NSMutableDictionary]
    {
        var recordArr = [NSMutableDictionary]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRecord")
        
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        fetchRequest.predicate = NSPredicate(format: "user_id = %@", user_id)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            userRecordObj = results as! [NSManagedObject]
            
            for dict in results {
                let record:NSMutableDictionary = NSMutableDictionary()
                
                record.setValue((dict as AnyObject).value(forKey: "date"), forKey: "date")
                record.setValue((dict as AnyObject).value(forKey: "hb"), forKey: "hb")
                record.setValue((dict as AnyObject).value(forKey: "pulse"), forKey: "pulse")
                record.setValue((dict as AnyObject).value(forKey: "speed"), forKey: "speed")
                record.setValue((dict as AnyObject).value(forKey: "oxSat"), forKey: "oxSat")
                record.setValue((dict as AnyObject).value(forKey: "user_id"), forKey: "user_id")
                record.setValue((dict as AnyObject).value(forKey: "gluc"), forKey: "gluc")
                
                record.setValue((dict as AnyObject).value(forKey: "time"), forKey: "time")
                record.setValue((dict as AnyObject).value(forKey: "medicine"), forKey: "medicine")
                record.setValue((dict as AnyObject).value(forKey: "diet"), forKey: "diet")
                record.setValue((dict as AnyObject).value(forKey: "record_id"), forKey: "record_id")
                
                record.setValue((dict as AnyObject).value(forKey: "envrHumi"), forKey: "envrHumi")
                record.setValue((dict as AnyObject).value(forKey: "envrTemp"), forKey: "envrTemp")
                record.setValue((dict as AnyObject).value(forKey: "surfHumi"), forKey: "surfHumi")
                record.setValue((dict as AnyObject).value(forKey: "surfTemp"), forKey: "surfTemp")
                record.setValue((dict as AnyObject).value(forKey: "battery"), forKey: "battery")
                
                recordArr.append(record)
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return recordArr
    }
    
    func fetchRequestForTestDetail()->[NSMutableDictionary]
    {
        var recordArr = [NSMutableDictionary]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRecord")
        
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        fetchRequest.predicate = NSPredicate(format: "user_id = %@", user_id)
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            userRecordObj = results as! [NSManagedObject]
            
            for dict in results {
                let record:NSMutableDictionary = NSMutableDictionary()
                
                record.setValue((dict as AnyObject).value(forKey: "date"), forKey: "date")
                record.setValue((dict as AnyObject).value(forKey: "hb"), forKey: "hb")
                record.setValue((dict as AnyObject).value(forKey: "pulse"), forKey: "pulse")
                record.setValue((dict as AnyObject).value(forKey: "speed"), forKey: "speed")
                record.setValue((dict as AnyObject).value(forKey: "oxSat"), forKey: "oxSat")
                record.setValue((dict as AnyObject).value(forKey: "user_id"), forKey: "user_id")
                record.setValue((dict as AnyObject).value(forKey: "gluc"), forKey: "gluc")
                
                record.setValue((dict as AnyObject).value(forKey: "time"), forKey: "time")
                record.setValue((dict as AnyObject).value(forKey: "medicine"), forKey: "medicine")
                record.setValue((dict as AnyObject).value(forKey: "diet"), forKey: "diet")
                record.setValue((dict as AnyObject).value(forKey: "record_id"), forKey: "record_id")
                
                record.setValue((dict as AnyObject).value(forKey: "envrHumi"), forKey: "envrHumi")
                record.setValue((dict as AnyObject).value(forKey: "envrTemp"), forKey: "envrTemp")
                record.setValue((dict as AnyObject).value(forKey: "surfHumi"), forKey: "surfHumi")
                record.setValue((dict as AnyObject).value(forKey: "surfTemp"), forKey: "surfTemp")
                record.setValue((dict as AnyObject).value(forKey: "battery"), forKey: "battery")
                
                recordArr.append(record)
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return recordArr
    }
    
    
    func checkUserNotExists(_ str:String)->Bool
    {
        var returnType:Bool = Bool()
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        let username:String = str
       // let username:String = String(stringInterpolationSegment: str)
        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            userInfoObj = results as! [NSManagedObject]
            
            if results.count == 0{
                returnType = true
            }
            else{
                returnType = false
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return returnType
    }
    
    func CheckForUserNameAndPasswordMatch (_ username : String, password : String) ->Bool
    {
        var returnType:Bool = Bool()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let predicate = NSPredicate (format:"username = %@" ,username)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> ( entityName: "UserInfo")
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            userInfoObj = results as! [NSManagedObject]
            let person:NSMutableDictionary = NSMutableDictionary()
            
            if results.count>0
            {
                for res in results {
                    person.setValue((res as AnyObject).value(forKey: "username"), forKey: "username")
                    person.setValue((res as AnyObject).value(forKey: "password"), forKey: "password")
                    person.setValue((res as AnyObject).value(forKey: "age"), forKey: "age")
                    person.setValue((res as AnyObject).value(forKey: "height"), forKey: "height")
                    person.setValue((res as AnyObject).value(forKey: "weight"), forKey: "weight")
                    person.setValue((res as AnyObject).value(forKey: "user_id"), forKey: "user_id")
                    person.setValue((res as AnyObject).value(forKey: "diabetes"), forKey: "diabetes")
                    person.setValue((res as AnyObject).value(forKey: "glucose"), forKey: "glucose")
                    person.setValue((res as AnyObject).value(forKey: "gender"), forKey: "gender")
                    person.setValue((res as AnyObject).value(forKey: "imagePath"), forKey: "imagePath")
                    
                    person.setValue((res as AnyObject).value(forKey: "biguanide"), forKey: "biguanide")
                    person.setValue((res as AnyObject).value(forKey: "sulphonyl"), forKey: "sulphonyl")
                    person.setValue((res as AnyObject).value(forKey: "a_gluc"), forKey: "a_gluc")
                    person.setValue((res as AnyObject).value(forKey: "no_medication"), forKey: "no_medication")
                }
                
                let name = person.value(forKey: "username") as! String
                let pwd = person.value(forKey: "password") as! String
                
                if name == username && pwd == password{
                    returnType = true   // Entered Username & password matched
                    
                    let id = person.value(forKey: "user_id") as! String
                    
                    UserDefaults.standard.setValue(id, forKey: "hm_user_id")
                }
                else{
                    returnType = false  //Wrong password/username
                }
            }
            else{
                returnType = false
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return returnType
    }
    
    func fetchRequestForMeasurementSettingsData()->[NSMutableDictionary]
    {
        var recordArr = [NSMutableDictionary]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMeasurementSettings")
        
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        fetchRequest.predicate = NSPredicate(format: "user_id = %@", user_id)
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            userMeasurementSettingObj = results as! [NSManagedObject]
            
            for dict in results {
                let testSetting:NSMutableDictionary = NSMutableDictionary()
                
                testSetting.setValue((dict as AnyObject).value(forKey: "twoHrFastGlucoseMin"), forKey: "twoHrFastGlucoseMin")
                testSetting.setValue((dict as AnyObject).value(forKey: "twoHrFastGlucoseMax"), forKey: "twoHrFastGlucoseMax")
                testSetting.setValue((dict as AnyObject).value(forKey: "mrngFastGlucoseMin"), forKey: "mrngFastGlucoseMin")
                testSetting.setValue((dict as AnyObject).value(forKey: "mrngFastGlucoseMax"), forKey: "mrngFastGlucoseMax")
                testSetting.setValue((dict as AnyObject).value(forKey: "pulseMin"), forKey: "pulseMin")
                testSetting.setValue((dict as AnyObject).value(forKey: "user_id"), forKey: "user_id")
                testSetting.setValue((dict as AnyObject).value(forKey: "measurementSetting_id"), forKey: "measurementSetting_id")
                
                testSetting.setValue((dict as AnyObject).value(forKey: "pulseMax"), forKey: "pulseMax")
                
                testSetting.setValue((dict as AnyObject).value(forKey: "oxSatMin"), forKey: "oxSatMin")
                testSetting.setValue((dict as AnyObject).value(forKey: "oxSatMax"), forKey: "oxSatMax")
                testSetting.setValue((dict as AnyObject).value(forKey: "hbMin"), forKey: "hbMin")
                testSetting.setValue((dict as AnyObject).value(forKey: "hbMax"), forKey: "hbMax")
                testSetting.setValue((dict as AnyObject).value(forKey: "bloodFlowMin"), forKey: "bloodFlowMin")
                testSetting.setValue((dict as AnyObject).value(forKey: "bloodFlowMax"), forKey: "bloodFlowMax")
                testSetting.setValue((dict as AnyObject).value(forKey: "email"), forKey: "email")
                testSetting.setValue((dict as AnyObject).value(forKey: "email2"), forKey: "email2")
                
                testSetting.setValue((dict as AnyObject).value(forKey: "email3"), forKey: "email3")
                
                recordArr.append(testSetting)
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return recordArr
    }
    
    func fetchRequestForReminderSettingsData()->[NSMutableDictionary]
    {
        var recordArr = [NSMutableDictionary]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserReminderSettings")
        
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        fetchRequest.predicate = NSPredicate(format: "user_id = %@", user_id)
        
        let managedContext = appDelegate.managedObjectContext
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            userReminderSettingObj = results as! [NSManagedObject]
            
            for dict in results {
                let reminderSettings:NSMutableDictionary = NSMutableDictionary()
                
                reminderSettings.setValue((dict as AnyObject).value(forKey: "user_id"), forKey: "user_id")
                reminderSettings.setValue((dict as AnyObject).value(forKey: "reminderSettings_id"), forKey: "reminderSettings_id")
                
                reminderSettings.setValue((dict as AnyObject).value(forKey: "heading"), forKey: "heading")
                reminderSettings.setValue((dict as AnyObject).value(forKey: "measure_medication"), forKey: "measure_medication")
                reminderSettings.setValue((dict as AnyObject).value(forKey: "state"), forKey: "state")
                reminderSettings.setValue((dict as AnyObject).value(forKey: "row"), forKey: "row")
                reminderSettings.setValue((dict as AnyObject).value(forKey: "time"), forKey: "time")
                
                recordArr.append(reminderSettings)
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return recordArr
    }
    
    //MARK:- Methods to Save data
    
    func saveUserInfoData(_ dict: NSDictionary) {
        
        print("Save UserInfoData")
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: "UserInfo", in: managedContext)
        let person = UserInfo(entity: entity!, insertInto: managedContext)
        
        let id = String(describing: person.objectID)//id 0x7f99e0f1c380 <x-coredata:///UserInfo/t5A482567-DB5E-47CA-8623-96EE410D8BDA2>
        UserDefaults.standard.set(id, forKey: "hm_user_id")
        UserDefaults.standard.setValue(dict.value(forKey: "password") as! String, forKey: "hm_password")
        UserDefaults.standard.setValue(dict.value(forKey: "username") as! String, forKey: "hm_username")
        
        //3
        person.setValue(dict.value(forKey: "username"), forKey: "username")
        person.setValue(dict.value(forKey: "password"), forKey: "password")
        person.setValue(dict.value(forKey: "age"), forKey: "age")
        person.setValue(dict.value(forKey: "height"), forKey: "height")
        person.setValue(dict.value(forKey: "weight"), forKey: "weight")
        person.setValue(id, forKey: "user_id")
        person.setValue(dict.value(forKey: "diabetes"), forKey: "diabetes")
        person.setValue(dict.value(forKey: "glucose"), forKey: "glucose")
        person.setValue(dict.value(forKey: "gender"), forKey: "gender")
        person.setValue(dict.value(forKey: "imagePath"), forKey: "imagePath")
        
        person.setValue(dict.value(forKey: "biguanide"), forKey: "biguanide")
        person.setValue(dict.value(forKey: "sulphonyl"), forKey: "sulphonyl")
        person.setValue(dict.value(forKey: "a_gluc"), forKey: "a_gluc")
        person.setValue(dict.value(forKey: "no_medication"), forKey: "no_medication")
        
        //4
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveUserRecord(_ dict: NSDictionary) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "UserRecord", in: managedContext)
        let testDetail = UserRecord(entity: entity!, insertInto: managedContext)
        
        let id = String(describing: testDetail.objectID)
        
        testDetail.setValue(dict.value(forKey: "date"), forKey: "date")
        
        // Default unit- %(Device number)
        testDetail.setValue(dict.value(forKey: "hb"), forKey: "hb")// Default unit- no unit(Device number)
        testDetail.setValue(dict.value(forKey: "pulse"), forKey: "pulse")// Default unit- time/min(Device number)
        testDetail.setValue(dict.value(forKey: "speed"), forKey: "speed")// Default unit- AU(Device number)
        testDetail.setValue(dict.value(forKey: "user_id"), forKey: "user_id")
        testDetail.setValue(dict.value(forKey: "oxSat"), forKey: "oxSat")// Default unit- %(Device number)
        testDetail.setValue(dict.value(forKey: "gluc"), forKey: "gluc")// Default unit- no unit(Device number)
        testDetail.setValue(dict.value(forKey: "diet"), forKey: "diet")
        testDetail.setValue(dict.value(forKey: "medicine"), forKey: "medicine")
        testDetail.setValue(dict.value(forKey: "time"), forKey: "time")
        
        testDetail.setValue(dict.value(forKey: "battery"), forKey: "battery")
        testDetail.setValue(dict.value(forKey: "envrHumi"), forKey: "envrHumi")
        testDetail.setValue(dict.value(forKey: "envrTemp"), forKey: "envrTemp")
        testDetail.setValue(dict.value(forKey: "surfHumi"), forKey: "surfHumi")
        testDetail.setValue(dict.value(forKey: "surfTemp"), forKey: "surfTemp")
        testDetail.setValue(id, forKey: "record_id")
        
        //4
        do {
            try managedContext.save()
            
            let testCount = Int(UserDefaults.standard.string(forKey: "test_count")!)! + 1
            
            UserDefaults.standard.setValue(testCount, forKey: "test_count")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveMeasurementSettingsData(_ dict: NSDictionary) {
        
        print("Save MeasurementSettingsData ")
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: "UserMeasurementSettings", in: managedContext)
        let testSetting = UserMeasurementSettings(entity: entity!, insertInto: managedContext)
        
        let id = String(describing: testSetting.objectID)
        let user_id = UserDefaults.standard.string(forKey: "hm_user_id")
        
        //3
        testSetting.setValue(dict.value(forKey: "twoHrFastGlucoseMin"), forKey: "twoHrFastGlucoseMin")
        testSetting.setValue(dict.value(forKey: "twoHrFastGlucoseMax"), forKey: "twoHrFastGlucoseMax")
        testSetting.setValue(dict.value(forKey: "mrngFastGlucoseMin"), forKey: "mrngFastGlucoseMin")
        testSetting.setValue(dict.value(forKey: "mrngFastGlucoseMax"), forKey: "mrngFastGlucoseMax")
        testSetting.setValue(dict.value(forKey: "pulseMin"), forKey: "pulseMin")
        testSetting.setValue(user_id, forKey: "user_id")
        testSetting.setValue(id, forKey: "measurementSetting_id")
        
        testSetting.setValue(dict.value(forKey: "pulseMax"), forKey: "pulseMax")
        
        testSetting.setValue(dict.value(forKey: "oxSatMin"), forKey: "oxSatMin")
        testSetting.setValue(dict.value(forKey: "oxSatMax"), forKey: "oxSatMax")
        testSetting.setValue(dict.value(forKey: "hbMin"), forKey: "hbMin")
        testSetting.setValue(dict.value(forKey: "hbMax"), forKey: "hbMax")
        testSetting.setValue(dict.value(forKey: "bloodFlowMin"), forKey: "bloodFlowMin")
        testSetting.setValue(dict.value(forKey: "bloodFlowMax"), forKey: "bloodFlowMax")
        testSetting.setValue(dict.value(forKey: "email"), forKey: "email")
        testSetting.setValue(dict.value(forKey: "email2"), forKey: "email2")
        testSetting.setValue(dict.value(forKey: "email3"), forKey: "email3")
        
        //4
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveReminderSettingsData(_ dict: NSDictionary) {
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        //2
        let entity = NSEntityDescription.entity(forEntityName: "UserReminderSettings", in: managedContext)
        let reminderSettings = UserReminderSettings(entity: entity!, insertInto: managedContext)
        
        let id = String(describing: reminderSettings.objectID)
        let user_id = UserDefaults.standard.string(forKey: "hm_user_id")
        
        //3
        
        reminderSettings.setValue(user_id, forKey: "user_id")
        reminderSettings.setValue(id, forKey: "reminderSettings_id")
        
        reminderSettings.setValue(dict.value(forKey: "heading"), forKey: "heading")
        reminderSettings.setValue(dict.value(forKey: "measure_medication"), forKey: "measure_medication")
        reminderSettings.setValue(dict.value(forKey: "state"), forKey: "state")
        reminderSettings.setValue(dict.value(forKey: "time"), forKey: "time")
        reminderSettings.setValue(dict.value(forKey: "row"), forKey: "row")
        
        //4
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    //MARK:- Methods to Update Data
    
    func updateUserInfo(_ dict: NSDictionary) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        fetchRequest.predicate = NSPredicate(format: "user_id = %@", user_id)
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            userInfoObj = results as! [NSManagedObject]
            for res in results {
                (res as AnyObject).setValue(dict.value(forKey: "username"), forKey: "username")
                (res as AnyObject).setValue(dict.value(forKey: "password"), forKey: "password")
                (res as AnyObject).setValue(dict.value(forKey: "age"), forKey: "age")
                (res as AnyObject).setValue(dict.value(forKey: "height"), forKey: "height")
                (res as AnyObject).setValue(dict.value(forKey: "weight"), forKey: "weight")
                (res as AnyObject).setValue(dict.value(forKey: "diabetes"), forKey: "diabetes")
                (res as AnyObject).setValue(dict.value(forKey: "glucose"), forKey: "glucose")
                (res as AnyObject).setValue(dict.value(forKey: "gender"), forKey: "gender")
                (res as AnyObject).setValue(dict.value(forKey: "imagePath"), forKey: "imagePath")
                (res as AnyObject).setValue(dict.value(forKey: "biguanide"), forKey: "biguanide")
                (res as AnyObject).setValue(dict.value(forKey: "sulphonyl"), forKey: "sulphonyl")
                (res as AnyObject).setValue(dict.value(forKey: "a_gluc"), forKey: "a_gluc")
                (res as AnyObject).setValue(dict.value(forKey: "no_medication"), forKey: "no_medication")
            }
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not fetch \(error)")//, \(error.userInfo)")
        }
    }
    
    func updateMedicationSettings(_ dict: NSDictionary) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        fetchRequest.predicate = NSPredicate(format: "user_id = %@", user_id)
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            userInfoObj = results as! [NSManagedObject]
            for res in results {
                
                (res as AnyObject).setValue(dict.value(forKey: "biguanide"), forKey: "biguanide")
                (res as AnyObject).setValue(dict.value(forKey: "sulphonyl"), forKey: "sulphonyl")
                (res as AnyObject).setValue(dict.value(forKey: "a_gluc"), forKey: "a_gluc")
                (res as AnyObject).setValue(dict.value(forKey: "no_medication"), forKey: "no_medication")
            }
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not fetch \(error)")//, \(error.userInfo)")
        }
    }
    
    func updateReminderSettings(_ dict: NSDictionary) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserReminderSettings")
        let row = dict.value(forKey: "row") as! String
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        fetchRequest.predicate = NSPredicate(format: "user_id = %@ AND row = %@", user_id,row)
        //"date >= %@ AND date =< %@"
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            userReminderSettingObj = results as! [NSManagedObject]
            for res in results {
                
                (res as AnyObject).setValue(dict.value(forKey: "heading"), forKey: "heading")
                (res as AnyObject).setValue(dict.value(forKey: "measure_medication"), forKey: "measure_medication")
                (res as AnyObject).setValue(dict.value(forKey: "state"), forKey: "state")
                (res as AnyObject).setValue(dict.value(forKey: "time"), forKey: "time")
                (res as AnyObject).setValue(row, forKey: "row")
            }
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not fetch \(error)")//, \(error.userInfo)")
        }
    }
}



