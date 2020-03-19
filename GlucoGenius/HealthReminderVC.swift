//
//  HealthReminderVC.swift
//  GlucoGenius
//
//  Created by i mark on 10/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import CoreData

var notificationTime = String()
var notificationHeading = String()
var state = String()
var measure_medicationSelection = String()

class HealthReminderVC: UIViewController,EditReminderScreenProtocol {
    
    //MARK:- Outlets & Properties
    
    var notificationSelected = String()
    let coreDataObj = CoreData()
    var reminderDataDict = [NSMutableDictionary]()
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTime2: UILabel!
    @IBOutlet weak var lblTime3: UILabel!
    @IBOutlet weak var lblTime4: UILabel!
    @IBOutlet weak var lblTime5: UILabel!
    @IBOutlet weak var lblTime6: UILabel!
    @IBOutlet weak var lblHeading1: UILabel!
    @IBOutlet weak var lblHeading3: UILabel!
    @IBOutlet weak var lblHeading6: UILabel!
    @IBOutlet weak var lblHeading5: UILabel!
    @IBOutlet weak var lblHeading4: UILabel!
    @IBOutlet weak var lblHeading2: UILabel!
    
    @IBOutlet weak var switch6: UISwitch!
    @IBOutlet weak var switch5: UISwitch!
    @IBOutlet weak var switch4: UISwitch!
    @IBOutlet weak var switch3: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var lblmedication2: UILabel!
    @IBOutlet weak var lblmedication6: UILabel!
    @IBOutlet weak var lblmedication5: UILabel!
    @IBOutlet weak var lblmedication4: UILabel!
    @IBOutlet weak var lblmedication3: UILabel!
    @IBOutlet weak var lblmedication1: UILabel!
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = healthReminderScreen_title
        self.navigationController?.navigationBar.isHidden = false
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(HealthReminderVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
        self.fetchRemindersSettingsData()
    }
    
    //MARK:- Methods
    
    func fetchRemindersSettingsData(){
        reminderDataDict = coreDataObj.fetchRequestForReminderSettingsData()
        setSavedNotifications()
    }
    
    func saveNotificationInfoInNSuserDefault(){
        showSettings(lblTime,lbHeading: lblHeading1,row: 0,reminderSwitch: switch1,lbMeasureMedication: lblmedication1)
        showSettings(lblTime2,lbHeading: lblHeading2,row: 1,reminderSwitch: switch2,lbMeasureMedication: lblmedication2)
        showSettings(lblTime3,lbHeading: lblHeading3,row: 2,reminderSwitch: switch3,lbMeasureMedication: lblmedication3)
        showSettings(lblTime4,lbHeading: lblHeading4,row: 3,reminderSwitch: switch4,lbMeasureMedication: lblmedication4)
        showSettings(lblTime5,lbHeading: lblHeading5,row: 4,reminderSwitch: switch5,lbMeasureMedication: lblmedication5)
        showSettings(lblTime6,lbHeading: lblHeading6,row: 5,reminderSwitch: switch6,lbMeasureMedication: lblmedication6)
    }
    
    func showSettings(_ lbTime:UILabel,lbHeading:UILabel,row:Int,reminderSwitch:UISwitch,lbMeasureMedication:UILabel){
        var state = String()
        var measureMediction = String()
        lbTime.text = reminderDataDict[row].value(forKey: "time") as? String
        lbHeading.text = reminderDataDict[row].value(forKey: "heading") as? String
        state = (reminderDataDict[row].value(forKey: "state") as? String)!
        
        measureMediction = reminderDataDict[row].value(forKey: "measure_medication") as! String
        
        setMeasure_medication(measureMediction, lbl: lbMeasureMedication)
        if state == "on"{reminderSwitch.isOn = true}
        else{reminderSwitch.isOn = false}
    }
    
    func setMeasure_medication(_ measure_medi: String,lbl:UILabel){
        
        let formattedString = NSMutableAttributedString()
        
        switch measure_medi {
        case "00":
            formattedString.black(measureText).black(measurementRecord_medicationText)
            lbl.attributedText = formattedString
            break
        case "11":
            formattedString.red(measureText).red(measurementRecord_medicationText)
            lbl.attributedText = formattedString
            break
        case "01":
            formattedString.black(measureText).red(measurementRecord_medicationText)
            lbl.attributedText = formattedString
            break
        case "10":
            formattedString.red(measureText).black(measurementRecord_medicationText)
            lbl.attributedText = formattedString
            break
        default:
            formattedString.black(measureText).black(measurementRecord_medicationText)
            lbl.attributedText = formattedString
            break
        }
    }
    
    func setSavedNotifications(){
        
        switch(notificationSelected){
        case "0":
            coreDataObj.updateReminderSettings(["time":notificationTime,"heading":notificationHeading,"state":state,"measure_medication": measure_medicationSelection,"row":"0"])
            break
        case "1":
            coreDataObj.updateReminderSettings(["time":notificationTime,"heading":notificationHeading,"state":state,"measure_medication": measure_medicationSelection,"row":"1"])
            break
        case "2":
            coreDataObj.updateReminderSettings(["time":notificationTime,"heading":notificationHeading,"state":state,"measure_medication": measure_medicationSelection,"row":"2"])
            break
        case "3":
            coreDataObj.updateReminderSettings(["time":notificationTime,"heading":notificationHeading,"state":state,"measure_medication": measure_medicationSelection,"row":"3"])
            break
        case "4":
            coreDataObj.updateReminderSettings(["time":notificationTime,"heading":notificationHeading,"state":state,"measure_medication": measure_medicationSelection,"row":"4"])
            break
        case "5":
            coreDataObj.updateReminderSettings(["time":notificationTime,"heading":notificationHeading,"state":state,"measure_medication": measure_medicationSelection,"row":"5"])
            break
        default:break
        }
        
        saveNotificationInfoInNSuserDefault()
    }
    
    //MARK:- Button Action
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction1(_ sender: UIButton) {
        
        notificationSelected = "0"
        notificationTime = lblTime.text!
        notificationHeading = lblHeading1.text!
        if switch1.isOn{state = "on"}
        else{state = "off"}
        measure_medicationSelection = reminderDataDict[0].value(forKey: "measure_medication") as! String
        goToEditReminderScreen(lblTime.text!,heading: lblHeading1.text!)
    }
    
    @IBAction func btnAction2(_ sender: UIButton) {
        notificationSelected = "1"
        notificationTime = lblTime2.text!
        notificationHeading = lblHeading2.text!
        if switch2.isOn{state = "on"}
        else{state = "off"}
        measure_medicationSelection = reminderDataDict[1].value(forKey: "measure_medication") as! String
        goToEditReminderScreen(lblTime2.text!,heading: lblHeading2.text!)
    }
    
    @IBAction func btnAction3(_ sender: UIButton) {
        notificationSelected = "2"
        notificationTime = lblTime3.text!
        notificationHeading = lblHeading3.text!
        if switch3.isOn{state = "on"}
        else{state = "off"}
        measure_medicationSelection = reminderDataDict[2].value(forKey: "measure_medication") as! String
        goToEditReminderScreen(lblTime3.text!,heading: lblHeading3.text!)
    }
    
    @IBAction func btnAction4(_ sender: UIButton) {
        notificationSelected = "3"
        notificationTime = lblTime4.text!
        notificationHeading = lblHeading4.text!
        if switch4.isOn{state = "on"}
        else{state = "off"}
        measure_medicationSelection = reminderDataDict[3].value(forKey: "measure_medication") as! String
        goToEditReminderScreen(lblTime4.text!,heading: lblHeading4.text!)
    }
    
    @IBAction func btnAction5(_ sender: UIButton) {
        
        notificationSelected = "4"
        notificationTime = lblTime5.text!
        notificationHeading = lblHeading5.text!
        if switch5.isOn{state = "on"}
        else{state = "off"}
        measure_medicationSelection = reminderDataDict[4].value(forKey: "measure_medication") as! String
        goToEditReminderScreen(lblTime5.text!,heading: lblHeading5.text!)
    }
    
    @IBAction func btnAction6(_ sender: UIButton) {
        notificationSelected = "5"
        notificationTime = lblTime6.text!
        notificationHeading = lblHeading6.text!
        if switch6.isOn{state = "on"}
        else{state = "off"}
        measure_medicationSelection = reminderDataDict[5].value(forKey: "measure_medication") as! String
        goToEditReminderScreen(lblTime6.text!,heading: lblHeading6.text!)
    }
    
    func goToEditReminderScreen(_ time:String,heading:String){
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "editReminderScreen") as! EditReminderScreen
        secondViewController.time = time
        secondViewController.heading = heading
        secondViewController.notificationSelected = notificationSelected
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func switch1Action(_ sender: UISwitch) {
        if sender.isOn{
            coreDataObj.updateReminderSettings(["time":self.lblTime.text!,"heading":self.lblHeading1.text!,"state":"on","measure_medication": reminderDataDict[0].value(forKey: "measure_medication") as! String,"row":"0"])
            
            Utility.localNotification(Utility.trimString(self.lblTime.text!), local_notifications_date: Utility.getCurrentDateStr(),notificationStr: reminderDataDict[0].value(forKey: "measure_medication") as! String)
        }
        else{
            coreDataObj.updateReminderSettings(["time":self.lblTime.text!,"heading":self.lblHeading1.text!,"state":"off","measure_medication": reminderDataDict[0].value(forKey: "measure_medication") as! String,"row":"0"])
            
            Utility.cancelNotification(String(validatingUTF8: Utility.trimString(self.lblTime.text!))!, local_notifications_date: Utility.getCurrentDateStr())
        }
        reminderDataDict = coreDataObj.fetchRequestForReminderSettingsData()
    }
    
    @IBAction func switch2Action(_ sender: UISwitch) {
        if sender.isOn{
            coreDataObj.updateReminderSettings(["time":self.lblTime2.text!,"heading":self.lblHeading2.text!,"state":"on","measure_medication": reminderDataDict[1].value(forKey: "measure_medication") as! String,"row":"1"])
            
            Utility.localNotification(Utility.trimString(self.lblTime2.text!), local_notifications_date: Utility.getCurrentDateStr(),notificationStr:reminderDataDict[1].value(forKey: "measure_medication") as! String)
        }
        else{
            coreDataObj.updateReminderSettings(["time":self.lblTime2.text!,"heading":self.lblHeading2.text!,"state":"off","measure_medication": reminderDataDict[1].value(forKey: "measure_medication") as! String,"row":"1"])
            
            Utility.cancelNotification(String(validatingUTF8: Utility.trimString(self.lblTime2.text!))!, local_notifications_date: Utility.getCurrentDateStr())
        }
        reminderDataDict = coreDataObj.fetchRequestForReminderSettingsData()
    }
    
    @IBAction func switch3Action(_ sender: UISwitch) {
        
        if sender.isOn{
            coreDataObj.updateReminderSettings(["time":self.lblTime3.text!,"heading":self.lblHeading3.text!,"state":"on","measure_medication": reminderDataDict[2].value(forKey: "measure_medication") as! String,"row":"2"])
            
            Utility.localNotification(Utility.trimString(self.lblTime3.text!), local_notifications_date: Utility.getCurrentDateStr(),notificationStr: reminderDataDict[2].value(forKey: "measure_medication") as! String)
        }
        else{
            coreDataObj.updateReminderSettings(["time":self.lblTime3.text!,"heading":self.lblHeading3.text!,"state":"off","measure_medication": reminderDataDict[2].value(forKey: "measure_medication") as! String,"row":"2"])
            
            Utility.cancelNotification(String(validatingUTF8: Utility.trimString(self.lblTime3.text!))!, local_notifications_date: Utility.getCurrentDateStr())
        }
        reminderDataDict = coreDataObj.fetchRequestForReminderSettingsData()
    }
    
    @IBAction func switch4Action(_ sender: UISwitch) {
        
        if sender.isOn{
            
            coreDataObj.updateReminderSettings(["time":self.lblTime4.text!,"heading":self.lblHeading4.text!,"state":"on","measure_medication": reminderDataDict[3].value(forKey: "measure_medication") as! String,"row":"3"])
            
            Utility.localNotification(Utility.trimString(self.lblTime4.text!), local_notifications_date: Utility.getCurrentDateStr(),notificationStr: reminderDataDict[3].value(forKey: "measure_medication") as! String)
        }
        else{
            coreDataObj.updateReminderSettings(["time":self.lblTime4.text!,"heading":self.lblHeading4.text!,"state":"off","measure_medication": reminderDataDict[3].value(forKey: "measure_medication") as! String,"row":"3"])
            
            Utility.cancelNotification(String(validatingUTF8: Utility.trimString(self.lblTime4.text!))!, local_notifications_date: Utility.getCurrentDateStr())
        }
        reminderDataDict = coreDataObj.fetchRequestForReminderSettingsData()
    }
    
    @IBAction func switch5Action(_ sender: UISwitch) {
        if sender.isOn{
            coreDataObj.updateReminderSettings(["time":self.lblTime5.text!,"heading":self.lblHeading5.text!,"state":"on","measure_medication": reminderDataDict[4].value(forKey: "measure_medication") as! String,"row":"4"])
            
            Utility.localNotification(Utility.trimString(self.lblTime5.text!), local_notifications_date: Utility.getCurrentDateStr(),notificationStr: reminderDataDict[4].value(forKey: "measure_medication") as! String)
        }
        else{
            coreDataObj.updateReminderSettings(["time":self.lblTime5.text!,"heading":self.lblHeading5.text!,"state":"off","measure_medication": reminderDataDict[4].value(forKey: "measure_medication") as! String,"row":"4"])
            
            Utility.cancelNotification(String(validatingUTF8: Utility.trimString(self.lblTime5.text!))!, local_notifications_date: Utility.getCurrentDateStr())
        }
        reminderDataDict = coreDataObj.fetchRequestForReminderSettingsData()
    }
    
    @IBAction func switch6Action(_ sender: UISwitch) {
        if sender.isOn{
            coreDataObj.updateReminderSettings(["time":self.lblTime6.text!,"heading":self.lblHeading6.text!,"state":"on","measure_medication": reminderDataDict[5].value(forKey: "measure_medication") as! String,"row":"5"])
            
            Utility.localNotification(Utility.trimString(self.lblTime6.text!), local_notifications_date: Utility.getCurrentDateStr(),notificationStr: reminderDataDict[5].value(forKey: "measure_medication") as! String)
        }
        else{
            coreDataObj.updateReminderSettings(["time":self.lblTime6.text!,"heading":self.lblHeading6.text!,"state":"off","measure_medication": reminderDataDict[5].value(forKey: "measure_medication") as! String,"row":"5"])
            
            Utility.cancelNotification(String(validatingUTF8: Utility.trimString(self.lblTime6.text!))!, local_notifications_date: Utility.getCurrentDateStr())
        }
        reminderDataDict = coreDataObj.fetchRequestForReminderSettingsData()
    }
    
    func saveButtonClicked(_ time:String,heading:String){
    }
    
}
