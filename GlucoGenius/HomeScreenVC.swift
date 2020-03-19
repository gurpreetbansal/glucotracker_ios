//
//  HomeScreenVC.swift
//  GlucoGenius
//
//  Created by i mark on 06/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController,HamburgerScreenViewProtocol {
    
    //MARK:- Outlets & Properties

    var testType:String = String()
    var hamburgerBtnSelected = true
    var hamburgerView:HamburgerScreenView = HamburgerScreenView()
    var dictToSendToDevice:NSMutableDictionary = NSMutableDictionary()
    var dictToShow:NSMutableDictionary = NSMutableDictionary()

    let coreDataObj:CoreData = CoreData()
    var switchUser = Bool()

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblYears: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var viewAlpha: UIView!
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.fetchResultsFromDb()
        initialState()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.intialSetup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfile.layoutIfNeeded()
        imgProfile.setNeedsUpdateConstraints()
        imgProfile.clipsToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.width*0.5
        imgProfile.layer.masksToBounds = true
        imgProfile.clipsToBounds = true
        imgProfile.contentMode = .scaleToFill
    }
        
    //MARK:- Methods

    func intialSetup(){
        
        self.title = homeVC_title
        self.viewAlpha.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeScreenVC.handleTap))
        self.viewAlpha.addGestureRecognizer(tap)
        let hamBurgerButton:UIButton = UIButton()
        var hamBarButton:UIBarButtonItem = UIBarButtonItem()
        hamBurgerButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.navicon)
        hamBurgerButton.setTitle(likeBtnTitle, for:UIControl.State())
        hamBurgerButton.addTarget(self, action: #selector(HomeScreenVC.hamBurgerButtonClicked(_:)), for: UIControl.Event.touchUpInside)
        hamBurgerButton.frame=CGRect(x: self.view.bounds.width-40, y: 0, width: 30, height: 40)
        hamBurgerButton.setTitleColor(UIColor.black, for: UIControl.State())
        hamBarButton = UIBarButtonItem(customView: hamBurgerButton)
        self.navigationItem.rightBarButtonItem = hamBarButton
    }
    
    @objc func handleTap(){
        self.viewAlpha.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.hamburgerView.frame = CGRect(x: self.view.frame.size.width, y: 64,width: self.view.frame.size.width-(self.view.frame.size.width/3) , height: self.view.frame.size.height - 64)},completion: {(value: Bool) in
        })
    }
    
    func initialState(){
        self.hamburgerBtnSelected = true
        self.hamburgerView.frame = CGRect(x: self.view.frame.size.width,y: 0,width: self.view.frame.size.width-(self.view.frame.size.width/3) , height: self.view.frame.size.height)
        self.mainView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.HamburgerScreenViewMethod()
    }
    
    func showDataOnScreen(_ dict: NSMutableDictionary){
        if dict.value(forKey: "imagePath") as! String != ""{
          Utility.getImage(dict.value(forKey: "imagePath") as! String,img: self.imgProfile)
        }
        else{
            self.imgProfile.image = UIImage(named: "avatar.png")
        }

        self.lblUsername.text = dict.value(forKey: "username") as? String
        self.lblYears.text = "\(dict.value(forKey: "age") as! String) \(yearsText)"
        
        if UserDefaults.standard.string(forKey: "hm_height_unit") == "inch"{
            self.lblHeight.text = "\(dict.value(forKey: "height") as! String) \(inchUnitText)"
        }
        else{
            self.lblHeight.text = "\(dict.value(forKey: "height") as! String) \(cmUnitText)"
        }
        
        if UserDefaults.standard.string(forKey: "hm_weight_unit") == "lb"{
            self.lblWeight.text = "\(dict.value(forKey: "weight") as! String) \(lbUnitText)"
        }
        else{
            self.lblWeight.text = "\(dict.value(forKey: "weight") as! String) \(kgUnitText)"
        }
    }
    
    func fetchResultsFromDb(){
        dictToShow = coreDataObj.fetchRequestForUserInfo()
        dictToSendToDevice = coreDataObj.fetchRequestForUserInfo()
        
        
        if UserDefaults.standard.string(forKey: "hm_height_unit") == "inch"{
            let weight = String(describing: NSDecimalNumber(value: Double(dictToShow.value(forKey: "height") as! String)!*0.393 as Double).rounding(accordingToBehavior: MConstants.behavior))
            dictToShow.setValue(weight, forKey: "height")
        }
        
        if UserDefaults.standard.string(forKey: "hm_weight_unit") == "lb"{
            
            let weight = String(describing: NSDecimalNumber(value: Double(dictToShow.value(forKey: "weight") as! String)!*2.2 as Double).rounding(accordingToBehavior: MConstants.behavior))
            dictToShow.setValue(String(weight), forKey: "weight")
        }
        
        self.showDataOnScreen(dictToShow)        
    }
    
    func HamburgerScreenViewMethod(){
        hamburgerView = (Bundle.main.loadNibNamed("HamburgerScreenView", owner: self, options: nil)?[0] as? HamburgerScreenView)!
        hamburgerView.frame = CGRect(x: self.view.frame.size.width, y: 64,width: self.view.frame.size.width-(self.view.frame.size.width/3) ,height: self.view.frame.size.height - 64)
        hamburgerView.delegate = self
        self.viewAlpha.isHidden = true
        self.view.addSubview(hamburgerView)
    }
    
   @objc func hamBurgerButtonClicked(_ sender:UIButton){
        if hamburgerView.frame.origin.x == self.view.frame.size.width-(self.view.frame.size.width-(self.view.frame.size.width/3)){
            self.viewAlpha.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                self.hamburgerView.frame = CGRect(x: self.view.frame.size.width, y: 64,width: self.view.frame.size.width-(self.view.frame.size.width/3) , height: self.view.frame.size.height - 64)},completion: {(value: Bool) in
            })
        }
        else{
            UIView.animate(withDuration: 0.2, animations: {
                self.viewAlpha.isHidden = false
                self.hamburgerView.frame = CGRect(x: self.view.frame.size.width-(self.view.frame.size.width-(self.view.frame.size.width/3)), y: 64,width: self.view.frame.size.width-(self.view.frame.size.width/3) ,height: self.view.frame.size.height - 64)
                }, completion: {
                    (value: Bool) in
            })
        }
    }

    //menu_bluetoothText, menu_editUserText, menu_unitSettingsText, menu_reminderSettingsText, menu_measurementRecordsText, menu_manageAccountsText, menu_switchUserText, menu_signOutText
    
    func hamburgerCellButtonClicked(_ indexPath:IndexPath){
        
        switch indexPath.row {
        case 0:// Bluetooth menu item
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "bluetoothDevicesVC") as! BluetoothDevicesVC
            self.navigationController!.pushViewController(nextViewController, animated: true)
            break
            
        case 1:// Edit User menu item
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "editUserVC") as! EditUserVC
            self.navigationController!.pushViewController(nextViewController, animated: true)
            break
            
        case 2:// Unit settings menu item
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "settingsVc") as! SettingsVc
            self.navigationController!.pushViewController(nextViewController, animated: true)
            break
            
        case 3:// Reminder settings menu item
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "healthReminderVC") as! HealthReminderVC
            self.navigationController!.pushViewController(nextViewController, animated: true)
            break
            
        case 4:// Measurement records menu item
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "measurementRecordVC") as! MeasurementRecordVC
            self.navigationController!.pushViewController(secondViewController, animated: true)
            break
            
        case 5:// Health reference menu item
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "healthReferenceVC") as! HealthReferenceVC
            self.navigationController!.pushViewController(secondViewController, animated: true)
            break
            
        case 6:// Manage accounts menu item
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "manageAccountsVC") as! ManageAccountsVC
            self.navigationController!.pushViewController(secondViewController, animated: true)
            break
            
        case 7:// Switch user menu item
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "selectUserVC") as! SelectUserVC
            self.navigationController!.pushViewController(secondViewController, animated: true)
            break
            
        case 8:// Logout menu item
            self.hamBurgerLogoutButtonCliceked()
            break
            
        default:
            break
        }
    }
    
    func hamBurgerLogoutButtonCliceked(){
        alert()
    }
    
    func alert(){
        let refreshAlert = UIAlertController(title: alertText, message: homeVC_alert_logOutAlert, preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: okText, style: .default, handler: { (action: UIAlertAction!) in
            
            UserDefaults.standard.removeObject(forKey: "hm_user_id")
            UserDefaults.standard.removeObject(forKey: "hm_username")
            UserDefaults.standard.removeObject(forKey: "hm_password")

            let mainScreen = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.navigationController?.pushViewController(mainScreen, animated: true)

        }))
        
        refreshAlert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { (action: UIAlertAction!) in
            self.viewAlpha.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                self.hamburgerView.frame = CGRect(x: self.view.frame.size.width, y: 64,width: self.view.frame.size.width-(self.view.frame.size.width/3) , height: self.view.frame.size.height - 64)},completion: {(value: Bool) in
            })
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    //MARK:- Button Actions

    @IBAction func settingsBtnAction(_ sender: UIButton) {
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "measurementSettingsVC") as! MeasurementSettingsVC
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }

    @IBAction func historyBtnAction(_ sender: UIButton) {
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "historyVC") as! HistoryVC
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func testBtnAction(_ sender: UIButton) {
        if (dictToSendToDevice.value(forKey: "diabetes") as! String) == "true"{
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "testScreenForType2VC") as! TestScreenForType2VC
            secondViewController.dictToSendToDevice = self.dictToSendToDevice
            self.navigationController!.pushViewController(secondViewController, animated: true)
        }
        else{
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "testScreenForNormalVC") as! TestScreenForNormalVC
            secondViewController.dictToSendToDevice = self.dictToSendToDevice
            secondViewController.dictToShow = self.dictToShow
            self.navigationController!.pushViewController(secondViewController, animated: true)
        }
    }
    
    @IBAction func guideBtnaction(_ sender: UIButton) {
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "guideVc") as! GuideVc
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
}
