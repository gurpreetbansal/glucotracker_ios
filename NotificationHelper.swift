//
//  NotificationHelper.swift
//  TextNotification
//
//  Created by Andrea Mazzini on 11/06/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit

struct NotificationHelper {
    static func askPermission() {

        let category = UIMutableUserNotificationCategory()
        category.identifier = "CATEGORY_ID"

        let categories = NSSet(object: category) as! Set<UIUserNotificationCategory>
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: categories)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }

    static func scheduleNotification() {
        let now: DateComponents = (Calendar.current as NSCalendar).components([.hour, .minute], from: Date())

        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = (cal as NSCalendar).date(bySettingHour: now.hour!, minute: now.minute! + 1, second: 0, of: Date(), options: NSCalendar.Options())
        let reminder = UILocalNotification()
        reminder.fireDate = date
        reminder.alertBody = "You can now reply with text"
        reminder.alertAction = "Cool"
        reminder.soundName = "sound.aif"
        reminder.category = "CATEGORY_ID"

        UIApplication.shared.scheduleLocalNotification(reminder)
    }
}
