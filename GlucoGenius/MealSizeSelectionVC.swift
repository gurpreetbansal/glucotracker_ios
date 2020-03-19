//
//  MealSizeSelectionVC.swift
//  Vigori Diary
//
//  Created by i mark on 27/01/17.
//  Copyright © 2017 i mark. All rights reserved.
//

import UIKit

class MealSizeSelectionVC: UIViewController {
    
    //MARK:- Outlets & properties
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabelCustomClass!
    
    @IBOutlet weak var switchForSmallMeal: UISwitch!
    @IBOutlet weak var switchForLargeMeal: UISwitch!
    @IBOutlet weak var switchForMediumMeal: UISwitch!
    
    @IBOutlet weak var lblLargeText: UILabel!
    @IBOutlet weak var lblMediumtext: UILabel!
    @IBOutlet weak var lblSmallText: UILabel!
    @IBOutlet weak var lblToShowNotice: UILabel!
    @IBOutlet weak var lblCarbohydrateIntake: UILabel!

    @IBOutlet weak var nextBtn: UIButtonCustomClass!
    
    var mealSize = "0"
    var dictToSendToDevice:NSMutableDictionary = NSMutableDictionary()
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        inialSetup()
        showDataOnScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Utility.makeRound(profileImg)
    }
    
    //MARK:- Methods

    func inialSetup(){
        self.title = normalUserTestVC_title
        self.navigationController?.isNavigationBarHidden = false
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(MealSizeSelectionVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
        self.switchForSmallMeal.isSelected = true
        
        lblLargeText.text = mealSizeVC_largeText
        lblSmallText.text = mealSizeVC_smallText
        lblMediumtext.text = mealSizeVC_mediumText
        lblCarbohydrateIntake.text = mealSizeVC_CarbohydrateText
        lblToShowNotice.text = mealSizeVC_noticeText
        nextBtn.setTitle(mealSizeVC_nextText, for: UIControl.State())
        
        smallMealSizeSelectionMethod()
        switchForSmallMeal.isOn = true

    }
    
    func showDataOnScreen(){
        if dictToSendToDevice.value(forKey: "imagePath") as! String != ""{
            Utility.getImage(dictToSendToDevice.value(forKey: "imagePath") as! String,img: self.profileImg)
        }
        else{
            self.profileImg.image = UIImage(named: "avatar")
        }
        self.userNameLbl.text = dictToSendToDevice.value(forKey: "username") as? String
    }
    
    func smallMealSizeSelectionMethod(){
        mealSize = "1"
        UserDefaults.standard.setValue(mealSize, forKey: "mealSize")
        switchForLargeMeal.isOn = false
        switchForMediumMeal.isOn = false
    }
    
    //MARK:- Button Actions
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func smallMealSelectionAction(_ sender: UISwitch) {
        smallMealSizeSelectionMethod()
    }
    
    @IBAction func mediumMealSelectionAction(_ sender: UISwitch) {
        mealSize = "2"
        UserDefaults.standard.setValue(mealSize, forKey: "mealSize")
        switchForLargeMeal.isOn = false
        switchForSmallMeal.isOn = false
    }
    
    @IBAction func lar5geMealSelectionAction(_ sender: UISwitch) {
        mealSize = "3"
        UserDefaults.standard.setValue(mealSize, forKey: "mealSize")
        switchForMediumMeal.isOn = false
        switchForSmallMeal.isOn = false
    }
    
    @IBAction func testBtnAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}
