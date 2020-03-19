//
//  HealthReportContent.swift
//  Vigori Diary
//
//  Created by i mark on 13/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class HealthReportContent: NSObject {
    
    class func emailContent(_ username:String,hbUnit: String,glucUnit: String,date: String,time: String, dict:NSMutableDictionary)->String{
        
        let glucInMg_dL = String(describing: NSDecimalNumber(value: Utility.mmol_LTomg_gL(Double(dict.value(forKey: "gluc") as! String)!/10) as Double).rounding(accordingToBehavior: MConstants.behavior))
        
        let content = "\(helloText) \(username) <Br /><Br /> \(yourRecentMeasurementAt) \(date) \(time): <Br /><Br /> \(bloodGlucoseText) - \(glucInMg_dL) \(glucUnit) <Br /> \(oxygenSaturationText) - \(dict.value(forKey: "oxSat") as! String )% <Br /> \(hemoglobinText) - \(Int(dict.value(forKey: "hb") as! String)!/10 ) \(hbUnit) <Br /> \(bloodFlowVelocityText)- \(dict.value(forKey: "speed") as! String ) \(auUnitText) <Br /> \(pulseText) - \(dict.value(forKey: "pulse") as! String ) \(timePerMinUnitText) <Br /> \(HealthReport_Content)"
        
        return content
    }
 
}
