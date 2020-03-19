//
//  Utility.swift
//  MarektX
//
//  Created by NurdyMuny on 07/03/16.
//  Copyright © 2016 NurdyMuny. All rights reserved.
//

import UIKit
import MessageUI
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

class Utility: NSObject,MFMailComposeViewControllerDelegate
{
    // MARK:- Alert
    
    class func showAlert(_ title: String?, message: String?, viewController:UIViewController)
    {
        let alertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: okText, style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func saveImgDocumentDirectory(_ pic:UIImage)->String
    {
        let fileManager = FileManager.default
        let randNum = arc4random_uniform(100000)
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("hma\(randNum)")
        let imageData = pic.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        return paths
    }
    
    class func getImage(_ paths:String,img:UIImageView)
    {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: paths){
            img.image = UIImage(contentsOfFile: paths)
        }
    }
    
    // MARK:- Empty string
    
    class func isEmptyString(_ string:String) -> Bool
    {
        if string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0{
            return true
        }
        return false
    }
    
    class func trimString(_ string:String) -> String
    {
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    // MARK:- Check login status
    
    class func isUserLoggedIn() -> Bool
    {
        if let _:String = UserDefaults.standard.value(forKey: "ownerEmail") as? String{
            return true
        }
        
        return false
    }
    
    // MARK:- Common Alert method
    
    class func commonPingAlert(_ viewController:UIViewController, title:String, resString:String){
        
        let actionSheetController: UIAlertController = UIAlertController(title:title, message:resString, preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: okText, style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        viewController.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK:- Other Methods
    
    class func isValidString(_ testStr:String) -> Bool {
        let string = "[A-Za-z._]"
        
        let stringTest = NSPredicate(format:"SELF MATCHES %@", string)
        if (stringTest.evaluate(with: testStr)) && (string != ""){
            return true
        }
        else{
            return false
        }
    }
    
    class func isValidZipcode(_ testStr:String) -> Bool {
        
        if (testStr.count <= 10) && (testStr.count >= 5){
            return true
        }
        else{return false}
    }
    
    class func isValidPhoneNo(_ testStr:String) -> Bool {
        
        if (testStr.count >= 10) && (testStr.count <= 15){
            return true
        }
        else{return false}
    }
    
    class func isValidDOB(_ sender:UIDatePicker,age:UITextField)->Bool {
        
        let Currentdate:Date = Date()
        let ageComponents:DateComponents = (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: sender.date, to: Currentdate, options: NSCalendar.Options.init(rawValue: 0))
        
        if (ageComponents.year < 12){
            return false
        }else{
            age.text = String(describing: ageComponents.year!)
            return true
        }
    }
    
    class func checkAllTxtFieldValidations(_ username:String,password:String,age:String,height:String,weight:String,gender:String,glucose:String,viewController:UIViewController)->Bool {
        
        if username != "" && password != "" && age != "" && height != "" && weight != "" && gender != ""
        {
            if age.count == 2{
                
                if Float(height) >= 50 && Float(height) <= 250 {
                    
                    if Float(weight) >= 30 && Float(weight) <= 200 {
                        return true
                    }
                    else{
                        self.commonPingAlert(viewController, title: "Alert", resString: "Weight is incorrect!")
                        return false
                    }
                }
                else{
                    self.commonPingAlert(viewController, title: "Alert", resString: "Height is incorrect.")
                    return false
                }
            }
            else{
                self.commonPingAlert(viewController, title: "Alert", resString: "You must be 12 years of age or older.")
                return false
            }
        }
        else{
            self.commonPingAlert(viewController, title: "Alert", resString: "All the fields are mandatory!")
            return false
        }
    }
    
    class func makeRound(_ imgView:UIImageView) {
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.width*0.5
    }
    
    class func animateViewMoving (_ up:Bool, moveValue :CGFloat,view :UIView){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        view.frame = view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    class func getCurrentDateStr()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        formatter.dateFormat = "yyyy-M-dd"
        let str = formatter.string(from: date)
        return str
    }
    
    class func mmol_LTomg_gL(_ mmol:Double)->Double{
        
        let mg_dL = mmol*18.02
        return mg_dL
    }
    
    class func mg_dLTomoml_L(_ mg_dL:Double)->Double{
        
        let mmol = mg_dL*0.0555
        
        return mmol
    }
    
    class func g_LTog_dL(_ g_L:Double)->Double{
        let g_dL = 10*g_L
        
        return g_dL
    }
    
    class func g_dLTog_L(_ g_dL:Double)->Double{
        
        let g_L = 0.1 * g_dL
        return g_L
    }
    
    class func toGetCurrentTime()->String{
        let currentDate:Date = Date()
        let formatter : DateFormatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en-US")
        let dateStr = formatter.string(from: currentDate)
        return dateStr
    }
    
    class func localNotification(_ local_notifications_start_time:String, local_notifications_date:String,notificationStr: String)
    {
        let booking_date = local_notifications_date.components(separatedBy: "-")
        let year = booking_date[0]
        let month = booking_date[1]
        let day = booking_date[2]
        
        let time = local_notifications_start_time.components(separatedBy: ":")
        
        let hour = time[0]
        let min = time[1]
        
        var dateComp:DateComponents = DateComponents()
        
        dateComp.year = Int(year)!
        dateComp.month = Int(month)!
        dateComp.day = Int(day)!
        
        dateComp.hour = Int(hour)!
        dateComp.minute = Int(min)!
        
        (dateComp as NSDateComponents).timeZone = TimeZone.current
        
        let calender:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date:Date = calender.date(from: dateComp)!
        
        let notification:UILocalNotification = UILocalNotification()
        
        var notificationAlertBodyText = String()
        var notificationAlert = String()
        
        switch notificationStr {
        case "00":
            notificationAlertBodyText = notificationText
            notificationAlert = reminderAlert
            break
        case "11":
            notificationAlertBodyText = notificationText4
            notificationAlert = reminderAlert2

            break
        case "01":
            notificationAlertBodyText = notificationText2
            notificationAlert = reminderAlert3

            break
        case "10":
            notificationAlertBodyText = notificationText3
            notificationAlert = reminderAlert4

            break
        default:

            break
        }
        
        notification.alertBody = "\(notificationAlertBodyText) \(local_notifications_start_time)!"

        notification.userInfo = ["alertText":notificationAlert]
        notification.fireDate = date
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    //MARK:- Method to Cancel Local Notification
    
    class func cancelNotification(_ local_notifications_start_time:String, local_notifications_date:String)
    {
        // list of all notifications
        let notifications = UIApplication.shared.scheduledLocalNotifications
        
        let date_of_booking = local_notifications_date
        let start_time_of_booking = local_notifications_start_time
        
        let booking_date = date_of_booking.components(separatedBy: "-")
        
        let year = booking_date[0]
        let month = booking_date[1]
        let day = booking_date[2]
        
        let time = start_time_of_booking.components(separatedBy: ":")
        
        let hour = time[0]
        let min = time[1]
        
        var dateComp:DateComponents = DateComponents()
        
        dateComp.year = Int(year)!
        dateComp.month = Int(month)!
        dateComp.day = Int(day)!
        
        dateComp.hour = Int(hour)!
        dateComp.minute = Int(min)!
        
        (dateComp as NSDateComponents).timeZone = TimeZone.current
        
        let calender:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date:Date = calender.date(from: dateComp)!
        let dateToCancel:Date = date
        
        for notification in notifications!
        {
            if notification.fireDate == dateToCancel // compare date with enabled notifications
            {
                UIApplication.shared.cancelLocalNotification(notification)
            }
            else{
            }
        }
    }

    //Take screen shot and share with Email functionality
    
    class func screenShotMethod(_ viewForScreenShot: UIView)->UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContext(viewForScreenShot.frame.size)
        viewForScreenShot.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        
        return image!
    }
    
    
}
