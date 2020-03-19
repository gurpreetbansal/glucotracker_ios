//
//  TestScreenForNormalVC.swift
//  GlucoGenius
//
//  Created by i mark on 07/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class TestScreenForNormalVC: UIViewController {

    //MARK:- Outlets & Properties
    
    var fasting:String = String()
    var dictToSendToDevice:NSMutableDictionary = NSMutableDictionary()
    var dictToShow:NSMutableDictionary = NSMutableDictionary()

    @IBOutlet weak var imgCheck2HourWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgCheckWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgCheckForMrngFast: UIImageView!
    @IBOutlet weak var imgCheckFor2HrsFast: UIImageView!
    @IBOutlet weak var btnMrngFast: UIButton!
    @IBOutlet weak var btn2HrsFast: UIButton!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblYears: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.makeRound(imgProfile)
        self.intialSetup()
        self.showDataOnScreen()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Utility.makeRound(imgProfile)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

        btnMrngFast.imageView?.image = UIImage(named: "")
        btn2HrsFast.imageView?.image = UIImage(named: "")
        
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(TestScreenForNormalVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    func showDataOnScreen(){
        if dictToSendToDevice.value(forKey: "imagePath") as! String != ""{
            Utility.getImage(dictToSendToDevice.value(forKey: "imagePath") as! String,img: self.imgProfile)
        }
        else{
            self.imgProfile.image = UIImage(named: "avatar")
        }
        self.lblUsername.text = dictToShow.value(forKey: "username") as? String
        self.lblYears.text = "\(dictToShow.value(forKey: "age") as! String) \(yearsText)"
        
        if UserDefaults.standard.string(forKey: "hm_height_unit") == "inch"{
            self.lblHeight.text = "\(dictToShow.value(forKey: "height") as! String) \(inchUnitText)"
        }
        else{
            self.lblHeight.text = "\(dictToShow.value(forKey: "height") as! String) \(cmUnitText)"
        }
        
        if UserDefaults.standard.string(forKey: "hm_weight_unit") == "lb"{
            self.lblWeight.text = "\(dictToShow.value(forKey: "weight") as! String) \(lbUnitText)"
        }
        else{
            self.lblWeight.text = "\(dictToShow.value(forKey: "weight") as! String) \(kgUnitText)"
        }
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
    
    @IBAction func createBtnAction(_ sender: UIButton) {
        
        if fasting != ""{
            
            if compareTestTime(){
                dictToSendToDevice.setValue(fasting, forKey: "diet")
                dictToSendToDevice.setValue("0000", forKey: "medication")
                dictToSendToDevice.setValue("false", forKey: "medicine")
                
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
    
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mrngFastingBtnAction(_ sender: UIButton) {
        if sender.isSelected{
            fasting = "0"
            imgCheckFor2HrsFast.image = UIImage(named: "")
            imgCheckForMrngFast.image = UIImage(named: "Check")
            UserDefaults.standard.setValue("0", forKey: "mealSize")
        }
    }
    
    @IBAction func twoHrsFastBtnAction(_ sender: UIButton) {
        
        if sender.isSelected{
            fasting = "2"
            imgCheckForMrngFast.image = UIImage(named: "")
            imgCheckFor2HrsFast.image = UIImage(named: "Check")
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "mealSizeSelectionVC") as! MealSizeSelectionVC
            secondViewController.dictToSendToDevice = dictToSendToDevice
            self.navigationController!.pushViewController(secondViewController, animated: false)
        }
    }


}
