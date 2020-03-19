//
//  MConstants.swift
//  MarketX
//
//  Created by NurdyMuny on 17/06/16.
//  Copyright © 2016 NurdyMuny. All rights reserved.
//

 struct MConstants {
    
    static let TRANSFER_SERVICE_UUID = "FFB0"
    static let READ_UUID = "FFB2"
    static let WRITE_UUID = "FFB1"
    static let signUpViewWidth:CGFloat = 900
    static let chartViewHeight:CGFloat = 350
    static let testScreenViewHight:CGFloat = 770
    static let dataReceived = "DDJSOK$"
    static let signalAccepted = "CCJSOK$"
    static let imgArr = ["check-health","physical-activity","manage-stress","eat-well","sleep-well","stay-hydrated","stay-hydrated"]
    
    static let lblArr = [BtConnVC_testing_screen1Text,BtConnVC_testing_screen2Text,BtConnVC_testing_screen3Text, BtConnVC_testing_screen4Text, BtConnVC_testing_screen5Text,   BtConnVC_testing_screen6Text]
    static let scale: Int16 = 1
    static let behavior = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)

    static let blueColor = UIColor(red: 132/255, green: 213/255, blue: 245/255, alpha: 1)//blue
    static let yellowColor = UIColor(red: 249/255, green: 188/255, blue: 98/255, alpha: 1)//yellow
    static let greenColor = UIColor(red: 141/255, green: 207/255, blue: 177/255, alpha: 1)//green
    static let orangeColor = UIColor(red: 246/255, green: 141/255, blue: 132/255, alpha: 1)//orange
    
    static let chartBarBlueColor = UIColor(red: 92/255, green: 154/255, blue: 212/255, alpha: 1)//blue
    
    static let one:Int = 1
    static let two:Int = 2
    static let three:Int = 3
    static let zero:Int = 0
    static let backBtnFrame = CGRect(x: 10, y: 0, width: 20, height: 40)
}

