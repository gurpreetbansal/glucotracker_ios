//
//  SettingsVc.swift
//  GlucoGenius
//
//  Created by i mark on 08/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class SettingsVc: UIViewController{
    
    //MARK:- Outlets & Properties
    
    @IBOutlet weak var unitNoteLbl: UILabel!
    @IBOutlet weak var switchBtnHeightUnit: ADVSegmentedControl!
    @IBOutlet weak var switchBtnWeightUnit: ADVSegmentedControl!
    @IBOutlet weak var switchBtnGlucUnit: ADVSegmentedControl!
    @IBOutlet weak var switchBtnHbUnit: ADVSegmentedControl!
    
    var hbUnit = UserDefaults.standard.string(forKey: "hm_hb_unit")! as String
    var glucUnit = UserDefaults.standard.string(forKey: "hm_gluc_unit")! as String
    var heightUnit = UserDefaults.standard.string(forKey: "hm_height_unit")! as String
    var weightUnit = UserDefaults.standard.string(forKey: "hm_weight_unit")! as String
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = unitSettingVC_title
        intialSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(SettingsVc.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    //MARK:- Methods

    func intialSetup(){
        self.unitNoteLbl.text = unitNoteMessage
        switchBtnHbUnit.items = [g_LUnitText,g_dLUnitText]
        switchBtnGlucUnit.items = [unit_AText,unit_Btext]
        switchBtnHeightUnit.items = [cmUnitText,inchUnitText]
        switchBtnWeightUnit.items = [kgUnitText,lbUnitText]
        switchBtnGlucUnit.addTarget(self, action: #selector(SettingsVc.switchBtnGlucUnitValueChanged(_:)), for: .valueChanged)
        switchBtnWeightUnit.addTarget(self, action: #selector(SettingsVc.switchBtnWeightUnitValueChanged(_:)), for: .valueChanged)
        switchBtnHbUnit.addTarget(self, action: #selector(SettingsVc.switchBtnHbUnitValueChanged(_:)), for: .valueChanged)
        switchBtnHeightUnit.addTarget(self, action: #selector(SettingsVc.switchBtnHeightUnitValueChanged(_:)), for: .valueChanged)
        
        setsavedUnits()
    }
    
    func setsavedUnits(){
    
        switch(hbUnit){
            case "g_L" : switchBtnHbUnit.selectedIndex = 0
            break
        default:switchBtnHbUnit.selectedIndex = 1
            break
        }
        
        switch(heightUnit){
        case "cm" : switchBtnHeightUnit.selectedIndex = 0
            break
        default:switchBtnHeightUnit.selectedIndex = 1
            break
        }
        
        switch(glucUnit){
        case "mmol_L" : switchBtnGlucUnit.selectedIndex = 0
            break
        default:switchBtnGlucUnit.selectedIndex = 1
            break
        }
        
        switch(weightUnit){
        case "kgs" : switchBtnWeightUnit.selectedIndex = 0
            break
        default:switchBtnWeightUnit.selectedIndex = 1
            break
        }

    }
    

    
    //MARK:- Button Action
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func switchBtnGlucUnitValueChanged(_ sender: AnyObject){
        if switchBtnGlucUnit.selectedIndex == 0 {
            glucUnit = "mmol_L"
        }
        else{
            glucUnit = "mg_dL"
        }
    }

    @objc func switchBtnWeightUnitValueChanged(_ sender: AnyObject){
        
        if switchBtnWeightUnit.selectedIndex == 0 {
            weightUnit = "kgs"
        }
        else{
            weightUnit = "lb"
        }
    }

    @objc func switchBtnHbUnitValueChanged(_ sender: AnyObject){
        if switchBtnHbUnit.selectedIndex == 0 {
            hbUnit = "g_L"
        }
        else{
            hbUnit = "g_dL"
        }
    }

    @objc func switchBtnHeightUnitValueChanged(_ sender: AnyObject){
        if switchBtnHeightUnit.selectedIndex == 0 {
            heightUnit = "cm"
        }
        else{
            heightUnit = "inch"
        }
    }

    @IBAction func saveBtnAction(_ sender: UIButton) {
        UserDefaults.standard.setValue(heightUnit, forKey: "hm_height_unit")
        UserDefaults.standard.setValue(weightUnit, forKey: "hm_weight_unit")
        UserDefaults.standard.setValue(hbUnit, forKey: "hm_hb_unit")
        UserDefaults.standard.setValue(glucUnit, forKey: "hm_gluc_unit")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

