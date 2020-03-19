//
//  EditReminderScreen.swift
//  Vigori Diary
//
//  Created by i mark on 13/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import CoreData

//MARK: Protocol

protocol EditReminderScreenProtocol {
    func saveButtonClicked(_ time:String,heading : String)
}

class EditReminderScreen: UIViewController,UITextFieldDelegate {
    
    //MARK:- Outlets & Properties
    
    var headingEditBtnTapped = true
    var time = String()
    var heading = String()
    var notificationSelected = String()
    var isMeasureSelected=Bool()
    var isMedicationSelected=Bool()
    var delegate:EditReminderScreenProtocol?
    var datePickerView = UIDatePicker()
    var reminderEditing = false
    var coreDataObj = CoreData()
    
    @IBOutlet weak var timeeTopView: UIView!
    @IBOutlet weak var imgMedicationCheck: UIImageView!
    @IBOutlet weak var imgMeasureCheck: UIImageView!
    @IBOutlet weak var txtFieldHeading: UITextField!
    @IBOutlet weak var headingFrontView: UIView!
    @IBOutlet weak var txtfieldTime: UITextField!
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditReminderScreen.handleTap))
        self.view.addGestureRecognizer(tap)
        timeeTopView.isHidden = true
        self.toShowTimePicker()
        self.txtFieldHeading.delegate = self
        self.txtfieldTime.delegate = self
        headingFrontView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        intialSetup()
    }
    
    //MARK:- Methods for intial setup

    func intialSetup(){
        self.navigationController?.isNavigationBarHidden = false
        self.title = editReminder_title
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(EditReminderScreen.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
        
        self.setDefalutValues()
    }
    
    func setDefalutValues(){
        self.txtfieldTime.text = time
        self.txtFieldHeading.text = heading
        
        switch(measure_medicationSelection){
            case "00":
                setMeasureMedicationdDefaultImage("uncheck", medication: "uncheck")
                isMeasureSelected = true
                isMedicationSelected = true
            break
            case "11":
                setMeasureMedicationdDefaultImage("check", medication: "check")
                isMeasureSelected = false
                isMedicationSelected = false
            break
            case "01":
                setMeasureMedicationdDefaultImage("uncheck", medication: "check")
                isMeasureSelected = true
                isMedicationSelected = false
            break
            case "10":
                setMeasureMedicationdDefaultImage("check", medication: "uncheck")
                isMeasureSelected = false
                isMedicationSelected = true
            break
            default: break
        }
    }
    
    func setMeasureMedicationdDefaultImage(_ measeure:String, medication: String){
        self.imgMeasureCheck.image = UIImage(named: measeure)
        self.imgMedicationCheck.image = UIImage(named: medication)
    }

    //MARK:- Button Action
    
    @objc func backBtnAction(){
        
        if reminderEditing{
            alert()
        }
        else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
        self.saveBtn()
    }
    
    @IBAction func reminderHeadingBtnAction(_ sender: UIButton) {
        
        if headingEditBtnTapped{
            headingEditBtnTapped = false
        }
        else{
            headingEditBtnTapped = true
        }
    }
    
    @IBAction func reminderTimeBtnAction(_ sender: UIButton) {
        self.toShowTimePicker()
    }
    
    
    @IBAction func measureBtnAction(_ sender: UIButton) {
        if isMeasureSelected{
            isMeasureSelected = false
            self.imgMeasureCheck.image = UIImage(named: "check")
        }
        else{
            isMeasureSelected = true
            self.imgMeasureCheck.image = UIImage(named: "uncheck")
        }
    }
    
    @IBAction func medicationBtnAction(_ sender: UIButton) {
        
        if isMedicationSelected{
            isMedicationSelected = false
            self.imgMedicationCheck.image = UIImage(named: "check")
        }
        else{
            isMedicationSelected = true
            self.imgMedicationCheck.image = UIImage(named: "uncheck")
        }
    }
    
    //MARK:- Other Methods
    
    func alert(){
        let refreshAlert = UIAlertController(title: alertText, message: editReminder_alert_saveChanges, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: okText, style: .default, handler: { (action: UIAlertAction!) in
            self.saveBtn()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { (action: UIAlertAction!) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func saveBtn(){
        Utility.cancelNotification(String(validatingUTF8: Utility.trimString(notificationTime))!, local_notifications_date: Utility.getCurrentDateStr())
        
        notificationTime = self.txtfieldTime.text!
        notificationHeading = self.txtFieldHeading.text!
        if isMeasureSelected && isMedicationSelected{
            measure_medicationSelection = "00"
        }
        else if isMeasureSelected && !isMedicationSelected{
            measure_medicationSelection = "01"
        }
        else if !isMeasureSelected && isMedicationSelected{
            measure_medicationSelection = "10"
        }
        else{
            measure_medicationSelection = "11"
        }
        state = "on"
        self.delegate?.saveButtonClicked(self.txtfieldTime.text!,heading: self.txtFieldHeading.text!)
        Utility.localNotification(Utility.trimString(notificationTime), local_notifications_date: Utility.getCurrentDateStr(),notificationStr: measure_medicationSelection)
        
        _ = self.navigationController?.popViewController(animated: true)
    coreDataObj.updateReminderSettings(["time":notificationTime,"heading":notificationHeading,"state":state,"measure_medication": measure_medicationSelection,"row":notificationSelected])
    }

    @objc func handleTap(){
        txtfieldTime.endEditing(true)
        txtFieldHeading.endEditing(true)
    }
    
    //MARK:- Date Picker View
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateFormatter.dateFormat = "HH:mm"
       
        dateFormatter.locale = Locale(identifier: "en-US")
        let str = dateFormatter.string(from: sender.date)
        self.txtfieldTime.text = str
    }
    
    func toShowTimePicker(){
        datePickerView.datePickerMode = UIDatePicker.Mode.time

        txtfieldTime.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(EditReminderScreen.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    //MARK:- Text field delegates
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reminderEditing = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        let maxLength:Int = 20
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}
