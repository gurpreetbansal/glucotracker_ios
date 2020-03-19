//
//  TestScreenForType2VC.swift
//  GlucoGenius
//
//  Created by i mark on 07/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class TestScreenForType2VC: UIViewController {

    //MARK:- Outlets & Properties
    
    var fasting:String = String()
    var coreDataObj:CoreData = CoreData()
    var dictToSendToDevice:NSMutableDictionary = NSMutableDictionary()

    @IBOutlet weak var lblMorningFastingAlert: UILabel!
    @IBOutlet weak var imgCheck2HoursWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgCheckMrnfFastWidthConst: NSLayoutConstraint!
    @IBOutlet weak var btnMrngFast: UIButton!
    @IBOutlet weak var btn2HrsFast: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgCheckForMrngFast: UIImageView!
    @IBOutlet weak var imgCheckFor2HrsFast: UIImageView!
    @IBOutlet weak var scrollInnerViewHgtCnst: NSLayoutConstraint!
    @IBOutlet weak var scrollInnerViewWidthCnst: NSLayoutConstraint!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var switchMedication: UISwitch!
    @IBOutlet weak var switchSulphonyl: UISwitch!
    @IBOutlet weak var swicthBiguanides: UISwitch!
    @IBOutlet weak var switchA_gluc: UISwitch!
    
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.intialSetup()
        self.showDataOnScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Utility.makeRound(imgProfile)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Utility.makeRound(imgProfile)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        imgProfile.clipsToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.width*0.5
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- User defined methods
    
    func intialSetup(){
        
        self.title = normalUserTestVC_title
        self.navigationController?.isNavigationBarHidden = false
        lblMorningFastingAlert.text = ""
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: MConstants.testScreenViewHight)
        scrollInnerViewHgtCnst.constant = MConstants.testScreenViewHight
        scrollInnerViewWidthCnst.constant = UIScreen.main.bounds.width
        
        btnMrngFast.imageView?.image = UIImage(named: "")
        btn2HrsFast.imageView?.image = UIImage(named: "")
        
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(TestScreenForType2VC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn

    }
    
    func showSavedData(){
        
        UserDefaults.standard.setValue(dictToSendToDevice.value(forKey: "no_medication") as! String, forKey: "no_medication")
        UserDefaults.standard.setValue(dictToSendToDevice.value(forKey: "sulphonyl") as! String, forKey: "sulphonyl")
        UserDefaults.standard.setValue(dictToSendToDevice.value(forKey: "a_gluc") as! String, forKey: "a-gluc")
        UserDefaults.standard.setValue(dictToSendToDevice.value(forKey: "biguanide") as! String, forKey: "biguanide")
        
        if UserDefaults.standard.string(forKey: "no_medication")! == "1"{
            switchMedication.isOn = true
        }
        else{
            switchMedication.isOn = false
        }
        if UserDefaults.standard.string(forKey: "sulphonyl")! == "1"{
            switchSulphonyl.isOn = true
        }
        else{
            switchSulphonyl.isOn = false
        }
        if UserDefaults.standard.string(forKey: "biguanide")! == "1"{
            swicthBiguanides.isOn = true
        }
        else{
            swicthBiguanides.isOn = false
        }
        if UserDefaults.standard.string(forKey: "a-gluc")! == "1"{
            switchA_gluc.isOn = true
        }
        else{
            switchA_gluc.isOn = false
        }
    }
    
    func switchSetupForNoMedication(){
        swicthBiguanides.isOn = false
        switchA_gluc.isOn = false
        switchMedication.isOn = true
        switchSulphonyl.isOn = false
        UserDefaults.standard.setValue("1", forKey: "no_medication")
        UserDefaults.standard.setValue("0", forKey: "sulphonyl")
        UserDefaults.standard.setValue("0", forKey: "a-gluc")
        UserDefaults.standard.setValue("0", forKey: "biguanide")
    }
    
    func switchSetupForMedication(){
        swicthBiguanides.isOn = true
        switchA_gluc.isOn = true
        switchMedication.isOn = false
        switchSulphonyl.isOn = true
        UserDefaults.standard.setValue("0", forKey: "no_medication")
        UserDefaults.standard.setValue("1", forKey: "sulphonyl")
        UserDefaults.standard.setValue("1", forKey: "a-gluc")
        UserDefaults.standard.setValue("1", forKey: "biguanide")
    }
    
    func showDataOnScreen(){
        showSavedData()
        if dictToSendToDevice.value(forKey: "imagePath") as! String != ""{
            Utility.getImage(dictToSendToDevice.value(forKey: "imagePath") as! String,img: self.imgProfile)
        }
        else{
            self.imgProfile.image = UIImage(named: "avatar")
        }
        self.lblUsername.text = dictToSendToDevice.value(forKey: "username") as? String
    }
    
    func compareTestTime()->Bool{
        var validTestTime = true
        
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let testDate = UserDefaults.standard.object(forKey: "hm_test_time")
        
        if (testDate != nil){
            
            let interval = (testDate! as AnyObject).timeIntervalSince(currentDate)
            if interval > 300{
                validTestTime = true
            }
            else if interval < -300{
                validTestTime = true
            }
            else{
                Utility.showAlert("", message: btConnVC_alert_LessThan3mins, viewController: self)
                validTestTime = false
            }
        }
        else{
            validTestTime = true
        }
        return validTestTime
    }
    
    //MARK:- Button Actions
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchMedicationAction(_ sender: UISwitch) {
        if sender.isOn{
            UserDefaults.standard.setValue("1", forKey: "no_medication")
            switchSetupForNoMedication()
            updateMedicationSettings()
        }
        else{
            UserDefaults.standard.setValue("0", forKey: "no_medication")
            switchSetupForMedication()
            updateMedicationSettings()
        }
    }

    @IBAction func switchSulphonylAction(_ sender: UISwitch) {
        if sender.isOn{
            UserDefaults.standard.setValue("0", forKey: "no_medication")
            UserDefaults.standard.setValue("1", forKey: "sulphonyl")
            switchMedication.isOn = false
            updateMedicationSettings()
        }
        else{
            UserDefaults.standard.setValue("0", forKey: "sulphonyl")
            updateMedicationSettings()
        }
    }
    
    @IBAction func switchBiguanideslAction(_ sender: UISwitch) {
        if sender.isOn{
            UserDefaults.standard.setValue("0", forKey: "no_medication")
            UserDefaults.standard.setValue("1", forKey: "biguanide")
            switchMedication.isOn = false
            updateMedicationSettings()
        }
        else{
            UserDefaults.standard.setValue("0", forKey: "biguanide")
            updateMedicationSettings()
        }
    }
    
    @IBAction func switchAGlucAction(_ sender: UISwitch) {
        if sender.isOn{
            UserDefaults.standard.setValue("0", forKey: "no_medication")
            UserDefaults.standard.setValue("1", forKey: "a-gluc")
            switchMedication.isOn = false
            updateMedicationSettings()
        }
        else{
            UserDefaults.standard.setValue("0", forKey: "a-gluc")
            updateMedicationSettings()
        }
    }

    @IBAction func createBtnAction(_ sender: UIButton) {
        
        if fasting != ""{
            
            if compareTestTime(){
                let medication = "\(UserDefaults.standard.string(forKey: "sulphonyl")!)\(UserDefaults.standard.string(forKey: "biguanide")!)\(UserDefaults.standard.string(forKey: "a-gluc")!)0"
                dictToSendToDevice.setValue(fasting, forKey: "diet")
               
                if UserDefaults.standard.string(forKey: "no_medication") == "1"{
                    dictToSendToDevice.setValue("0000", forKey: "medication")
                    dictToSendToDevice.setValue("false", forKey: "medicine")
                }
                else{
                    dictToSendToDevice.setValue(medication, forKey: "medication")
                    dictToSendToDevice.setValue("true", forKey: "medicine")
                }
                dictToSendToDevice.setValue(UserDefaults.standard.value(forKey: "mealSize"), forKey: "mealSize")
                
                print("dictToSendToDevice",dictToSendToDevice)
                
                let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "startTestVC") as! StartTestVC
                secondViewController.dictToSendToDevice = self.dictToSendToDevice
                self.navigationController!.pushViewController(secondViewController, animated: true)
            }
        }
        else{
            Utility.showAlert(errorText, message: normalUserTestVC_alert_chooseMeal, viewController: self)}
    }
    
    @IBAction func mrngFastingBtnAction(_ sender: UIButton) {
        if sender.isSelected{
            fasting = "0"
            imgCheckFor2HrsFast.image = UIImage(named: "")
            imgCheckForMrngFast.image = UIImage(named: "Check")
            lblMorningFastingAlert.text = signUpVC_alert_MorningFastingAlert
            UserDefaults.standard.setValue("0", forKey: "mealSize")
        }
    }
    
    @IBAction func twoHrsFastBtnAction(_ sender: UIButton) {
        if sender.isSelected{
            fasting = "2"
            imgCheckForMrngFast.image = UIImage(named: "")
            imgCheckFor2HrsFast.image = UIImage(named: "Check")
            lblMorningFastingAlert.text = ""
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "mealSizeSelectionVC") as! MealSizeSelectionVC
            secondViewController.dictToSendToDevice = dictToSendToDevice
            self.navigationController!.pushViewController(secondViewController, animated: false)
        }
    }
    
    //Methods to save UserInfo
    
    func updateMedicationSettings(){
        let dict:NSMutableDictionary = NSMutableDictionary()
        dict.setValue(UserDefaults.standard.string(forKey: "biguanide"), forKey: "biguanide")
        dict.setValue(UserDefaults.standard.string(forKey: "sulphonyl"), forKey: "sulphonyl")
        dict.setValue(UserDefaults.standard.string(forKey: "a-gluc"), forKey: "a_gluc")
        dict.setValue(UserDefaults.standard.string(forKey: "no_medication"), forKey: "no_medication")
        coreDataObj.updateMedicationSettings(dict)
    }
}
