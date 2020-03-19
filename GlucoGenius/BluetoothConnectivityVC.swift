//
//  BluetoothConnectivityVC.swift
//  GlucoGenius
//
//  Created by i mark on 06/09/16.
//  Copyright © 2016 i mark. All rights reserved.

import CoreBluetooth
import UIKit
import Foundation

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
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}


class BluetoothConnectivityVC: UIViewController, BLESerialComManagerDelegate {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var imgLoader: UIImageView!
    @IBOutlet weak var testingInProcessView: UIView!
    @IBOutlet weak var lblProcessing: UILabel!
    @IBOutlet weak var imgViewDeviceStatus: UIImageView!
    @IBOutlet weak var lblDeviceStatus: UILabel!
    @IBOutlet weak var lblInst1: UILabel!
    @IBOutlet weak var lblInst2: UILabel!
    @IBOutlet weak var viewProgressIndicator: UIView!
    @IBOutlet weak var lblInst3: UILabel!
    @IBOutlet weak var countDownlbl: UILabel!
    @IBOutlet weak var insertFingerCountDownlbl: UILabel!
    
    
    var inputData = [String]()
    var dictToSendToDevice:NSMutableDictionary = NSMutableDictionary()
    var showData:NSMutableDictionary = NSMutableDictionary()
    let coreDataObj:CoreData = CoreData()
    var timer = Timer(); var testTimer = Timer(); var dataNotReceivedTimer = Timer(); var returnTimer = Timer(); var goBackTimer = Timer(); var showFingerTemErrTimer = Timer();
    var countDownTimer = Timer()
    var insertFingerCountDownTimer = Timer()
    var fullString:String = String()
    
    var index = -1;
    var counter:Int = 3; var forceFullyDisconnectDevice = false;
    var resendData = 0; var alreadyDiconnect = false;
    var saveData = false
    let imgArr = MConstants.imgArr
    let lblArr = MConstants.lblArr
    var battery = Int()
    var isShutDownCommand = false
    
    var bleSerialComMgr = BLESerialComManager.sharedInstance()
    var port = BLEPort()
    var allPorts = NSMutableArray()
    var firstPacketString = String()
    var secondPacketString = String()
    var thirdPacketString = String()
    var fourthPacketString = String()
    
    var fourthPacketRecivedCount:Int = 0
    var isMoveToResultScreen = false;
    var connectivityTimer = Timer()
    
    // MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        viewProgressIndicator.isHidden = true
        testingInProcessView.isHidden = true
        bleSerialComMgr = BLESerialComManager.sharedInstance()
        bleSerialComMgr!.delegate = self
        self.makeDataToSend()
        self.compareTestTime()
        if bleSerialComMgr!.state == CENTRAL_STATE_POWEREDON{
            bleSerialComMgr!.startEnumeratePorts(5.0)
        }else{
           startConnectivityTimer()
        }
    }
    
    func startConnectivityTimer(){
        connectivityTimer = Timer.scheduledTimer(timeInterval: 10.0
            , target: self, selector: #selector(BluetoothConnectivityVC.stopScan), userInfo: nil, repeats: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = btConnVC_firstTitle
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    //MARK:- Intial setup Method
    
    func intialSetUp(){
        viewProgressIndicator.isHidden = false
        self.lblProcessing.text = btConnVC_lblProcessingText
        //timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(BluetoothConnectivityVC.stopScan), userInfo: nil, repeats: true)
        self.navigationItem.hidesBackButton = true
        self.lblInst1.text = btConnVC_lblInst1_text
        self.lblInst2.text = btConnVC_lblInst2_text
        self.lblInst3.text = btConnVC_lblInst3_text
    }
    
    
    @objc func dataNotReceived(){
        dataNotReceivedTimer.invalidate()
        resendData += 1
        if resendData == 2{
            forceFullyDisconnectDevice = true
            someThingWentWrong(btConnVC_alert_resetDevice)
        }else{
            resendDataMethod()
        }
    }
    
    func resendDataMethod(){
        if isShutDownCommand{
            self.shutDownDevice()
        } else{
            let codeStr = inputData[index]
            print(codeStr)
            bleSerialComMgr?.write(codeStr.data(using: .utf8), to: port)
            dataNotReceivedTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(BluetoothConnectivityVC.dataNotReceived), userInfo: nil, repeats: false)
        }
    }
    
    
    func bufferData(_ stringFromData:String){
        dataNotReceivedTimer.invalidate()
        let stringArr = Array(stringFromData)
        let count = stringArr.count
        for i in 0 ..< count{
            if stringArr[i] == "$"{
                fullString.append(stringArr[i])
                if fullString == MConstants.dataReceived{
                    if index != 0 && index != 2{
                        sendDataToDevice()
                    }
                }
                else if fullString == MConstants.signalAccepted{
                }
                else{
                    self.findData(fullString)
                }
                fullString = ""
            }
            else{
                fullString.append(stringArr[i])
            }
        }
    }
    
    func sendDataToDevice(){
        if index < inputData.count-1{
            index += 1
            let codeStr = inputData[index]
            print(codeStr)
            bleSerialComMgr?.write(codeStr.data(using: .utf8), to: port)
            resendData = 0;
            if index != 3{
                dataNotReceivedTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(BluetoothConnectivityVC.dataNotReceived), userInfo: nil, repeats: false)
            }
        }
    }
    
    
    // MARK: - User Defined methods
    
    func disconnectEverthing(){
        timer.invalidate()
        testTimer.invalidate()
        goBackTimer.invalidate()
        dataNotReceivedTimer.invalidate()
    }
    
    func compareTestTime(){
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let testDate = UserDefaults.standard.object(forKey: "hm_test_time")
        
        if (testDate != nil){
            
            let interval = (testDate! as AnyObject).timeIntervalSince(currentDate)
            if interval > 300{
                self.intialSetUp()
            }
            else if interval < -300{
                self.intialSetUp()
            }
            else{
                self.navigationItem.hidesBackButton = true
                self.imgViewDeviceStatus.image = UIImage(named: "something-went-wrong")
                self.lblDeviceStatus.text = btConnVC_alert_LessThan3mins
                goBackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(BluetoothConnectivityVC.back), userInfo: nil, repeats: true)
            }
        }
        else{
            intialSetUp()
        }
    }
    
    func toGetCurrentDate()->String{
        let currentDate:Date = Date()
        let formatter : DateFormatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        
        formatter.dateFormat = "yyyyMMdd,HHmm"
        formatter.locale = Locale(identifier: "en-US")
        let dateStr = formatter.string(from: currentDate)
        return dateStr
    }
    
    func makeDataToSend(){
        inputData.append("CCDLJC$")
        
        var userDataStr = String()
        userDataStr = "DDYHSJ"
        userDataStr = userDataStr + (dictToSendToDevice.value(forKey: "diet") as! String)
        if dictToSendToDevice.value(forKey: "diabetes") as! String == "true"{
            userDataStr = userDataStr + "2"
            userDataStr = userDataStr + getGulocoseData()
        }else{
            userDataStr = userDataStr + "0"
            userDataStr = userDataStr + "000"
        }
        
        userDataStr = userDataStr + findBMIValue()
        userDataStr = userDataStr + (dictToSendToDevice.value(forKey: "medication") as! String)
        userDataStr = userDataStr + "$"
        inputData.append(userDataStr)
        
        // Environment Check Inputs
        inputData.append("CCHJJC$")
        
        //Start Measuring
        inputData.append("CCSTAT$")
        
        print("input data Dict:",inputData)
    }
    
    func findBMIValue()->String{
        let weightValue:Float = Float(dictToSendToDevice.value(forKey: "weight") as! String)!
        let height:Float = Float(dictToSendToDevice.value(forKey: "height") as! String)!
        print(weightValue)
        print(height)
        var lowerValue = (height/100)
        lowerValue = lowerValue * lowerValue
        let calculation = (weightValue/lowerValue) * 10 // for remove the decimal
        print(calculation)
        let bmiValue = String(format: "%.f", calculation)
        return bmiValue
    }
    
    func getGulocoseData()->String{
        let glucose = (dictToSendToDevice.value(forKey: "glucose") as! String).components(separatedBy: ".")
        var first = glucose[0]
        if Int(first)!<10{
            first = "0"+glucose.first!
        }
        var last = String()
        if glucose.count == 2 {
            last = glucose[1]
            if last != ""{
                if Int(last)!<10{
                    last = glucose.last!
                }
            }
            else{
                last = "0"
            }
        }
        else{
            last = "0"
        }
        let glucInput:String = first + last
        return glucInput
    }
    
    func getInputString(_ index: Int) -> String {
        return inputData[index];
    }
    
    
    @objc func stopScan(){
        timer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: "something-went-wrong")
        self.lblDeviceStatus.text = btConnVC_alert_DeviceNotFound
        startReturnTimer()
    }
    
    
    func findData(_ str:String){
        if (str.range(of: "HJER1") != nil) {
            errEnvnTemp(btConnVC_alert_envrTempLow)
        }
        else if (str.range(of: "DLZT") != nil) {
            let battery = self.seperateDigitsFromString(str)
            self.battery = Int(battery)!
            if Int(battery) <= 20{
                //self.imgViewDeviceStatus.image = UIImage(named: "something-went-wrong")
                //self.lblDeviceStatus.text = btConnVC_alert_batteryLow
                inserYourFIngerScreen("\(btConnVC_alert_insertProbe)\n\(btConnVC_alert_batteryLow)")
            }
            sendDataToDevice()
        }
            
        else if (str.range(of: "HJER0") != nil) {//&& (self.battery >= 20) {
            sendDataToDevice()
            inserYourFIngerScreen("\(btConnVC_alert_insertProbe)")
        }
            
        else if (str.range(of: "HJER2") != nil){
            //errEnvnTemp(btConnVC_alert_envrTempHigh)
            sendDataToDevice()
            inserYourFIngerScreen("\(btConnVC_alert_insertProbe)\n\(btConnVC_alert_envrTempHigh)")
        }
        else if (str.range(of: "HJER3") != nil) {
            //errEnvnTemp(btConnVC_alert_envrTempDry)
            sendDataToDevice()
            inserYourFIngerScreen("\(btConnVC_alert_insertProbe)\n\(btConnVC_alert_envrTempDry)")
        }
        else if (str.range(of: "HJER4") != nil){
            //errEnvnTemp(btConnVC_alert_envrHumid)
            sendDataToDevice()
            inserYourFIngerScreen("\(btConnVC_alert_insertProbe)\n\(btConnVC_alert_envrHumid)")
        }
            
        else if (str.range(of: "CCFRCS") != nil){     // Finger not insert
            self.shutDownDevice()
            someThingWentWrong(btConnVC_alert_timeOut)
        }
            
        else if (str.range(of: "CCERRO") != nil){
            self.shutDownDevice()
            self.fingerRemoved()
        }
        else if (str.range(of: "FRSZ") != nil) || (str.range(of: "CCFR") != nil){   // Finger already Inserted
            insertFingerCountDownTimer.invalidate()
            insertFingerCountDownlbl.text = ""
            let codeStr = "CCJSOK$"
            bleSerialComMgr?.write(codeStr.data(using: .utf8), to: port)
            testTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(BluetoothConnectivityVC.testInProcess), userInfo: nil, repeats: true)
        }
            
        else if (str.range(of: "CSSJ") != nil){
            // Test Completed
            self.saveAndShowData()
        }
        else if (str.range(of: "CWHM01") != nil){
            self.shutDownDevice()
            self.errFingerTemp(btConnVC_alert_fingerTempLow)
        }
            
        else if (str.range(of: "CWHM06") != nil){
            self.shutDownDevice()
            self.errFingerTemp(btConnVC_alert_fingerTempHigh)
        }else if (str.range(of: "CWHM") != nil){
            self.shutDownDevice()
            someThingWentWrong(btConnVC_alert_fingerNotInsertedProperly)
        }
        else if (str.range(of: "SZER0") != nil){
            insertFingerCountDownTimer.invalidate()
            insertFingerCountDownlbl.text = ""
            testTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(BluetoothConnectivityVC.testInProcess), userInfo: nil, repeats: true)
        }
            ///////
        else if (str.range(of: "ERR") != nil){
            self.shutDownDevice()
            someThingWentWrong(btConnVC_alert_probeNotInserted)
        }
            
        else if (str.range(of: "ERTT") != nil){
            self.shutDownDevice()
            someThingWentWrong(btConnVC_alert_fingerNotInsertedProperly)
        }
            
        else if (str.range(of: "ERAD") != nil){
            self.shutDownDevice()
            someThingWentWrong(btConnVC_alert_wrongDataCollection)
        }
            
        else if (str.range(of: "ERBW") != nil){
            self.shutDownDevice()
            someThingWentWrong(btConnVC_alert_probeNotInsertedProperly)
        }
            
        else if (str.range(of: "ERWD") != nil){
            self.shutDownDevice()
            someThingWentWrong(btConnVC_alert_checkSensors)
        }
            
        else if (str.range(of: "STOP") != nil){
            
        }else if (str.range(of: "CSZY") != nil){
            firstPacketString = str
            let codeStr = "CCJSOK$"
            bleSerialComMgr?.write(codeStr.data(using: .utf8), to: port)
            readFirstPacket()
        }else if (str.range(of: "CSZE") != nil){
            secondPacketString = str
            let codeStr = "CCJSOK$"
            bleSerialComMgr?.write(codeStr.data(using: .utf8), to: port)
            readSecondPacket()
        }else if (str.range(of: "CSZS") != nil){
            thirdPacketString = str
            let codeStr = "CCJSOK$"
            bleSerialComMgr?.write(codeStr.data(using: .utf8), to: port)
            readThirdPacket()
        }else if (str.range(of: "FXCS") != nil){
            fourthPacketString = str
            fourthPacketRecivedCount = fourthPacketRecivedCount + 1
            if fourthPacketRecivedCount == 4 {
                
                let codeStr = "CCJSOK$"  //CCCSSJ$
                print(codeStr)
                bleSerialComMgr?.write(codeStr.data(using: .utf8), to: port)
                
                self.shutDownDevice()
                goNextScreen()
            }else{
                let codeStr = "CCJSOK$"
                bleSerialComMgr?.write(codeStr.data(using: .utf8), to: port)
            }
        }
    }
    
    func readFirstPacket() {
        firstPacketString = firstPacketString.replacingOccurrences(of: "DDCSZY", with: "")
        firstPacketString = firstPacketString.replacingOccurrences(of: "$", with: "")
        let endIndex = firstPacketString.index(firstPacketString.startIndex, offsetBy: 3)
        let glucoseValue = firstPacketString.substring(to: endIndex)
        self.showData.setObject(glucoseValue, forKey: "gluc" as NSCopying)
        
        let startIndex = firstPacketString.index(firstPacketString.startIndex, offsetBy: 3)
        let endIndexForOxygen = firstPacketString.index(firstPacketString.startIndex, offsetBy: 5)
        let range = startIndex..<endIndexForOxygen
        let oxygenValue = firstPacketString.substring(with: range)
        self.showData.setObject(oxygenValue, forKey: "oxSat" as NSCopying)
        
        let startIndexForHB = firstPacketString.index(firstPacketString.startIndex, offsetBy: 5)
        let endIndexForForHB = firstPacketString.index(firstPacketString.startIndex, offsetBy: 9)
        let rangeForHB = startIndexForHB..<endIndexForForHB
        let hbValue = firstPacketString.substring(with: rangeForHB)
        self.showData.setObject(hbValue, forKey: "hb" as NSCopying)
        
        let startIndexForBFS = firstPacketString.index(firstPacketString.startIndex, offsetBy: 9)
        let bfsValue = firstPacketString.substring(from: startIndexForBFS)
        self.showData.setObject(bfsValue, forKey: "speed" as NSCopying)
    }
    
    func readSecondPacket() {
        secondPacketString = secondPacketString.replacingOccurrences(of: "DDCSZE", with: "")
        secondPacketString = secondPacketString.replacingOccurrences(of: "$", with: "")
        let endIndex = secondPacketString.index(secondPacketString.startIndex, offsetBy: 3)
        let envTemp = secondPacketString.substring(to: endIndex)
        self.showData.setObject(envTemp, forKey: "envrTemp" as NSCopying)
        
        let startIndex = secondPacketString.index(secondPacketString.startIndex, offsetBy: 3)
        let endIndexForEnvHumd = secondPacketString.index(secondPacketString.startIndex, offsetBy: 6)
        let range = startIndex..<endIndexForEnvHumd
        let envHumdValue = secondPacketString.substring(with: range)
        self.showData.setObject(envHumdValue, forKey: "envrHumi" as NSCopying)
        
        let startIndexForSurfaceTemp = secondPacketString.index(secondPacketString.startIndex, offsetBy: 6)
        let endIndexForForSurfaceTemp = secondPacketString.index(secondPacketString.startIndex, offsetBy: 9)
        let rangeForSurfaceTemp = startIndexForSurfaceTemp..<endIndexForForSurfaceTemp
        let surfaceTempValue = secondPacketString.substring(with: rangeForSurfaceTemp)
        self.showData.setObject(surfaceTempValue, forKey: "surfTemp" as NSCopying)
        
        let startIndexForsurfaceHumidity = secondPacketString.index(secondPacketString.startIndex, offsetBy: 9)
        let surfaceHumidityValue = secondPacketString.substring(from: startIndexForsurfaceHumidity)
        self.showData.setObject(surfaceHumidityValue, forKey: "surfHumi" as NSCopying)
    }
    
    func readThirdPacket(){
        thirdPacketString = thirdPacketString.replacingOccurrences(of: "DDCSZS", with: "")
        thirdPacketString = thirdPacketString.replacingOccurrences(of: "$", with: "")
        let endIndex = thirdPacketString.index(thirdPacketString.startIndex, offsetBy: 3)
        let pulse = thirdPacketString.substring(to: endIndex)
        self.showData.setObject(pulse, forKey: "pulse" as NSCopying)
        
        let startIndexForBattery = thirdPacketString.index(thirdPacketString.startIndex, offsetBy: 3)
        let endIndexForBattery = thirdPacketString.index(thirdPacketString.startIndex, offsetBy: 6)
        let rangeForBattery = startIndexForBattery..<endIndexForBattery
        let battery = thirdPacketString.substring(with: rangeForBattery)
        self.showData.setObject(battery, forKey: "battery" as NSCopying)
    }
    
    // Method to shut down device
    func shutDownDevice(){
        insertFingerCountDownTimer.invalidate()
        insertFingerCountDownlbl.text = ""
        testTimer.invalidate()
        stopCountDownTimer()
        self.isShutDownCommand = true
    }
    
    func saveAndShowData(){
        self.shutDownDevice()
        saveData = true
        forceFullyDisconnectDevice = true
        goBackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(BluetoothConnectivityVC.goBack), userInfo: nil, repeats: true)
    }
    
    func goNextScreen(){
        self.saveDataUserRecord()
        shutDownDevice()
        isMoveToResultScreen = true
        bleSerialComMgr?.delegate = nil
        bleSerialComMgr = nil
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "testResultVC") as! TestResultVC
        secondViewController.showData = self.showData
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    @objc func goBack(){
        disconnectEverthing()
        startReturnTimer()
    }
    
    @objc func back(){
        goBackTimer.invalidate()
        testTimer.invalidate()
        dataNotReceivedTimer.invalidate()
        timer.invalidate()
        shutDownDevice()
        bleSerialComMgr?.delegate = nil
        bleSerialComMgr = nil
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
    
    func saveDataUserRecord(){
        
        let dateObj = Date()
        UserDefaults.standard.set(dateObj, forKey: "hm_test_time")
        
        if Int(showData.value(forKey: "hb") as! String) != Int("0") && Int(showData.value(forKey: "speed") as! String) != Int("0") && Int(showData.value(forKey: "gluc") as! String) != Int("0") && Int(showData.value(forKey: "pulse") as! String) != Int("0") && Int(showData.value(forKey: "oxSat") as! String) != Int("0"){
            saveDataToDataBase();
        }
        else{
            someThingWentWrong(btConnVC_alert_incorectTestResult)
        }
    }
    
    func saveDataToDataBase() {
        let user_id:String = UserDefaults.standard.string(forKey: "hm_user_id")!
        let dict:NSMutableDictionary = NSMutableDictionary()
        
        let dateToSave:Date = UserDefaults.standard.object(forKey: "hm_test_time")  as!  Date//stringForKey("hm_test_time")!
        let time = Utility.toGetCurrentTime()//toGetCurrentDate().componentsSeparatedByString(",").last!.insert(":", ind: 2)
        
        dict.setValue(dateToSave, forKey: "date")
        showData.setValue(dateToSave, forKey: "date")
        dict.setValue(time, forKey: "time")
        dict.setValue(showData.value(forKey: "hb"), forKey: "hb")// Default unit- no unit(Device number)
        dict.setValue(showData.value(forKey: "speed"), forKey: "speed")// Default unit- AU(Device number)
        dict.setValue(showData.value(forKey: "gluc"), forKey: "gluc")// Default unit- no unit(Device number)
        dict.setValue(showData.value(forKey: "pulse"), forKey: "pulse")// Default unit- time/min(Device number)
        dict.setValue(showData.value(forKey: "oxSat"), forKey: "oxSat")// Default unit- %(Device number)
        dict.setValue(showData.value(forKey: "battery"), forKey: "battery")
        
        dict.setValue(user_id, forKey: "user_id")
        dict.setValue(dictToSendToDevice.value(forKey: "diet"), forKey: "diet")
        dict.setValue(dictToSendToDevice.value(forKey: "medicine"), forKey: "medicine")
        
        showData.setValue(dictToSendToDevice.value(forKey: "diet"), forKey: "diet")
        showData.setValue(dictToSendToDevice.value(forKey: "medicine"), forKey: "medicine")
        
        dict.setValue(showData.value(forKey: "envrHumi"), forKey: "envrHumi")
        dict.setValue(showData.value(forKey: "envrTemp"), forKey: "envrTemp")
        dict.setValue(showData.value(forKey: "surfHumi"), forKey: "surfHumi")
        dict.setValue(showData.value(forKey: "surfTemp"), forKey: "surfTemp")
        
        print("dict to save:",dict)
        coreDataObj.saveUserRecord(dict)
    }
    
    var seconds = 61
  @objc func updateCounDownTimer() {
        if(seconds > 0){
            seconds -= 1
            countDownlbl.text = String(seconds)
        }else{
            
            if showData.allKeys.count > 0{
                
                if Int(showData.value(forKey: "hb") as! String) != Int("0") && Int(showData.value(forKey: "speed") as! String) != Int("0") && Int(showData.value(forKey: "gluc") as! String) != Int("0") && Int(showData.value(forKey: "pulse") as! String) != Int("0") && Int(showData.value(forKey: "oxSat") as! String) != Int("0"){
                    saveDataToDataBase()
                }else{
                    someThingWentWrong(btConnVC_alert_incorectTestResult)
                }
            }else{
                someThingWentWrong(btConnVC_alert_incorectTestResult)
            }
        }
    }
    
    func runTimer() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(BluetoothConnectivityVC.updateCounDownTimer)), userInfo: nil, repeats: true)
    }
    
    func stopCountDownTimer(){
        countDownTimer.invalidate()
    }
    
    var insertFingerSeconds = 11
    @objc func updateInsetFingerCounDownTimer() {
        if insertFingerSeconds > 0{
            insertFingerSeconds -= 1
            insertFingerCountDownlbl.text = String(insertFingerSeconds)
        }else{
            stopScan()
        }
    }
    
    func runInsertFingerTimer() {
        insertFingerCountDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(BluetoothConnectivityVC.updateInsetFingerCounDownTimer)), userInfo: nil, repeats: true)
    }
    
    
    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    func seperateDigitsFromString(_ str:String)->String{
        let glucose = str.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let newString = NSArray(array: glucose).componentsJoined(by: "")
        return newString
    }
    
    func inserYourFIngerScreen(_ str: String){
        self.imgViewDeviceStatus.image = UIImage(named: "insert-finger")
        self.lblDeviceStatus.text = str// btConnVC_alert_insertProbe
        runInsertFingerTimer()
    }
    
    func compatibleEnvnTemp(){
        goBackTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: "environment-testring")
        self.lblDeviceStatus.text = btConnVC_alert_compliantEnvr
    }
    
    func errEnvnTemp(_ str: String){
        goBackTimer.invalidate()
        insertFingerCountDownTimer.invalidate()
        insertFingerCountDownlbl.text = ""
        shutDownDevice()
        self.imgViewDeviceStatus.image = UIImage(named: "environment-testring")
        self.lblDeviceStatus.text = str
        forceFullyDisconnectDevice = true
        goBackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(BluetoothConnectivityVC.goBack), userInfo: nil, repeats: true)
    }
    
    
    func bluetoothConnectivityErr(){
        goBackTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: "BT-Detection_Failed")
        self.lblDeviceStatus.text = btConnVC_alert_btDetectionfail
        
        startReturnTimer()
    }
    
    func startReturnTimer(){
        goBackTimer.invalidate()
        testTimer.invalidate()
        dataNotReceivedTimer.invalidate()
        timer.invalidate()
        if !isMoveToResultScreen{
            returnTimer = Timer.scheduledTimer(timeInterval: 1.0
                , target: self, selector: #selector(BluetoothConnectivityVC.updateTimer(_:)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimer(_ dt:Timer){
        counter -= 1
        if counter==0{
            returnTimer.invalidate()
            back()
        } else{
            self.lblDeviceStatus.text = btConnVC_alert_return
        }
    }
    
    func alertButtonPressed(_ title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) // 7
        disconnectEverthing()
        let defaultAction = UIAlertAction(title: "OK", style: .default)
        { (alert: UIAlertAction!) -> Void in
            self.back()
        } // 8
        alert.addAction(defaultAction) // 9
        present(alert, animated: true, completion:nil)  // 11
    }
    
    func alertButton(_ title: String,message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) // 7
        
        let defaultAction = UIAlertAction(title: "OK", style: .default)
        { (alert: UIAlertAction!) -> Void in
            self.back()
            
        } // 8
        alert.addAction(defaultAction) // 9
        present(alert, animated: true, completion:nil)  // 11
    }
    
    func bluetoothConnectivity(){
        self.imgViewDeviceStatus.image = UIImage(named: "BT-Detection")
        self.lblDeviceStatus.text = btConnVC_alert_btDetection
    }
    
    func fingerInserted(){
        goBackTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: "alvbmq-c")
        self.lblDeviceStatus.text = btConnVC_alert_probeInserted
    }
    
    func fingerRemoved(){
        goBackTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: "finger-not-inserted")
        self.lblDeviceStatus.text = btConnVC_alert_probeRemoved
        forceFullyDisconnectDevice = true
        goBackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(BluetoothConnectivityVC.goBack), userInfo: nil, repeats: true)
    }
    
    func errFingerTemp(_ str:String){
        goBackTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: "something-went-wrong")
        self.lblDeviceStatus.text = str
        forceFullyDisconnectDevice = true
        goBackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(BluetoothConnectivityVC.goBack), userInfo: nil, repeats: true)
    }
    
    func someThingWentWrong(_ str:String){
        goBackTimer.invalidate()
        insertFingerCountDownTimer.invalidate()
        insertFingerCountDownlbl.text = ""
        self.shutDownDevice()
        self.imgViewDeviceStatus.image = UIImage(named: "something-went-wrong")
        self.lblDeviceStatus.text = str
        forceFullyDisconnectDevice = true
        bleSerialComMgr?.delegate = nil
        bleSerialComMgr = nil
        if !isMoveToResultScreen{
            goBackTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(BluetoothConnectivityVC.goBack), userInfo: nil, repeats: true)
        }
    }
    
    func deviceDiscoonected(){
        goBackTimer.invalidate()
        if !forceFullyDisconnectDevice{
            self.imgViewDeviceStatus.image = UIImage(named: "device-connection-failure")
            self.lblDeviceStatus.text = btConnVC_alert_deviceDiscoonected
        }
        startReturnTimer()
    }
    
    // MARK:- Testing Methods
    
    @objc func testInProcess(){
        testTimer.invalidate()
        goBackTimer.invalidate()
        insertFingerCountDownTimer.invalidate()
        insertFingerCountDownlbl.text = ""
        //1
        self.title = btConnVC_secondTitle
        testTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(BluetoothConnectivityVC.process1), userInfo: nil, repeats: true)
        runTimer()// Start count down
    }
    
    @objc func process1(){
        let jeremyGif = UIImage.gifImageWithName("hourglass")
        
        let imgView = UIImageView(image: jeremyGif)
        imgView.frame = self.imgLoader.frame
        testingInProcessView.addSubview(imgView)
        
        viewProgressIndicator.isHidden = true
        testingInProcessView.isHidden = false
        testTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: self.imgArr[0])
        self.lblDeviceStatus.text = self.lblArr[0]
        testTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(BluetoothConnectivityVC.process2), userInfo: nil, repeats: true)
    }
    
    @objc func process2(){
        testTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: self.imgArr[1])
        self.lblDeviceStatus.text = self.lblArr[1]
        testTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(BluetoothConnectivityVC.process3), userInfo: nil, repeats: true)
    }
    
    @objc func process3(){
        testTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: self.imgArr[2])
        self.lblDeviceStatus.text = self.lblArr[2]
        testTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(BluetoothConnectivityVC.process4), userInfo: nil, repeats: true)
    }
    
    @objc func process4(){
        testTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: self.imgArr[3])
        self.lblDeviceStatus.text = self.lblArr[3]
        testTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(BluetoothConnectivityVC.process5), userInfo: nil, repeats: true)
    }
    
    @objc func process5(){
        testTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: self.imgArr[4])
        self.lblDeviceStatus.text = self.lblArr[4]
        testTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(BluetoothConnectivityVC.process6), userInfo: nil, repeats: true)
    }
    
    @objc func process6(){
        testTimer.invalidate()
        self.imgViewDeviceStatus.image = UIImage(named: self.imgArr[5])
        self.lblDeviceStatus.text = self.lblArr[5]
        //testTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(BluetoothConnectivityVC.saveAndShowData), userInfo: nil, repeats: true)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    // BLE DELEGATE METHOD
    func bleSerilaComManagerDidEnumComplete(_ bleSerialComManager: BLESerialComManager!) {
        if allPorts.count > 0{
            port = allPorts.object(at: 0) as! BLEPort
            let openParams = paramsPackage4Open();
            bleSerialComMgr?.startOpen(port, with: openParams)
        }else{
            stopScan()
        }
    }
    
    func bleSerilaComManager(_ bleSerialComManager: BLESerialComManager!, didFound port: BLEPort!) {
        allPorts.add(port as Any)
    }
    
    func bleSerilaComManagerDidStateChange(_ bleSerialComManager: BLESerialComManager!) {
        returnTimer.invalidate()
        connectivityTimer.invalidate()
        if bleSerialComManager.state == CENTRAL_STATE_POWEREDON{
            bleSerialComMgr?.startEnumeratePorts(5.0)
        }else{
            stopScan()
        }
    }
    
    func bleSerialComManager(_ bleSerialComManager: BLESerialComManager!, didClosedPort port: BLEPort!){
        stopScan()
    }
    
    func bleSerilaComManager(_ bleSerialComManager: BLESerialComManager!, didOpen port: BLEPort!, withResult result: resultCodeType) {
        timer.invalidate()
        sendDataToDevice()
    }
    
    func bleSerialComManager(_ bleSerialComManager: BLESerialComManager!, didDataReceivedOn port: BLEPort!, withLength length: UInt32) {
        let dataRec = bleSerialComManager.readData(from: port, withLength: Int32(length));
        let datastring = NSString(data: dataRec!, encoding: String.Encoding.utf8.rawValue)
        bufferData(datastring! as String)
        print(datastring!)
    }
}

extension String {
    func insert(_ string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
}



