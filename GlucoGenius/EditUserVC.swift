//
//  EditUserVC.swift
//  Vigori Diary
//
//  Created by i mark on 05/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
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
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
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


class EditUserVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: - Outlets & Properties
    
    var diabetic:String = String()
    let coreDataObj:CoreData = CoreData()
    var dictToSendToDevice:NSMutableDictionary = NSMutableDictionary()
    let imagePicker = UIImagePickerController()
    let datePickerView:UIDatePicker = UIDatePicker()
    var genderPicker:UIPickerView = UIPickerView()
    let genderArr = [signUpVC_TextMale,signUpVC_TextFemale]
    var pic:UIImage!
    let blueColor = UIColor.blue

    // Fields to save
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var glucose: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var SwitchGlucoseType: UISegmentedControl!
    @IBOutlet weak var lineImg: UIImageView!
    @IBOutlet weak var viewGlucose: UIView!
    @IBOutlet weak var mrngFastingAlertlbl: UILabel!
    @IBOutlet weak var txtFieldGlucInMg_dL: UITextField!
    @IBOutlet weak var txtFieldWeightInLb: UITextField!
    @IBOutlet weak var txtFieldHeightInInch: UITextField!
    @IBOutlet weak var viewGlucoseHeightConst: NSLayoutConstraint!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
        self.fetchResultsFromDb()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Utility.makeRound(imgViewProfile)
        self.switchSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        self.title = editProfile_title
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(EditUserVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    // MARK: - Methods
    
    // Intial Setup
    func intialSetup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleTap))
        self.view.addGestureRecognizer(tap)
        self.age.endEditing(true)
        self.gender.endEditing(true)
        imagePicker.delegate = self
        username.allowsEditingTextAttributes = false
        password.allowsEditingTextAttributes = false
        self.txtFieldWeightInLb.delegate = self
        self.txtFieldGlucInMg_dL.delegate = self
        self.txtFieldHeightInInch.delegate = self
        self.age.delegate = self
        self.height.delegate = self
        self.weight.delegate = self
        self.glucose.delegate = self
        imgViewProfile.clipsToBounds = true
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.width*0.5
    }
    
    // Back button action
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }

    func switchSetup(){
        SwitchGlucoseType.layer.masksToBounds = true
        SwitchGlucoseType.layer.cornerRadius = SwitchGlucoseType.bounds.height / 2
        SwitchGlucoseType.layer.borderColor = UIColor.lightGray.cgColor
        SwitchGlucoseType.layer.borderWidth = 2
        SwitchGlucoseType.addTarget(self, action: #selector(SignUpViewController.segmentValueChanged(_:)), for: .valueChanged)
    }
    
    func segmentValueChanged(_ sender: AnyObject){
        if SwitchGlucoseType.selectedSegmentIndex == 0 {
            viewGlucose.isHidden = true
            viewGlucoseHeightConst.constant = 0
            diabetic = "false"
            self.mrngFastingAlertlbl.text = ""
        }
        else if SwitchGlucoseType.selectedSegmentIndex == 1{
            viewGlucose.isHidden = false
            viewGlucoseHeightConst.constant = 80
            diabetic = "true"
            self.mrngFastingAlertlbl.text = signUpVC_alert_MorningFastingAlert
        }
    }
    
    func fetchResultsFromDb(){
        dictToSendToDevice = coreDataObj.fetchRequestForUserInfo()
        if dictToSendToDevice.value(forKey: "imagePath") as! String != ""{
            Utility.getImage(dictToSendToDevice.value(forKey: "imagePath") as! String,img: self.imgViewProfile)
            pic = self.imgViewProfile.image
        }
        self.username.text = dictToSendToDevice.value(forKey: "username") as? String
        self.password.text = dictToSendToDevice.value(forKey: "password") as? String
        self.age.text = dictToSendToDevice.value(forKey: "age") as? String
        self.height.text = dictToSendToDevice.value(forKey: "height") as? String
        self.weight.text = dictToSendToDevice.value(forKey: "weight") as? String
        self.glucose.text = dictToSendToDevice.value(forKey: "glucose") as? String
        let diabetic = dictToSendToDevice.value(forKey: "diabetes") as? String
        self.gender.text = dictToSendToDevice.value(forKey: "gender") as? String
        
        self.txtFieldWeightInLb.text = String(describing: NSDecimalNumber(value: Double(weight.text!)!*2.2 as Double).rounding(accordingToBehavior: MConstants.behavior))
        self.txtFieldHeightInInch.text = String(describing: NSDecimalNumber(value: Double(height.text!)!*0.393 as Double).rounding(accordingToBehavior: MConstants.behavior))
        
        if glucose.text != ""{
            self.txtFieldGlucInMg_dL.text = String(describing: NSDecimalNumber(value: Utility.mmol_LTomg_gL(Double(glucose.text!)!) as Double).rounding(accordingToBehavior: MConstants.behavior))
        }
        if diabetic == "true"{
            SwitchGlucoseType.selectedSegmentIndex = 1
            viewGlucose.isHidden = false
            viewGlucoseHeightConst.constant = 80
            self.diabetic = "true"
            self.mrngFastingAlertlbl.text = signUpVC_alert_MorningFastingAlert
        }
        else{
            SwitchGlucoseType.selectedSegmentIndex = 0
            viewGlucose.isHidden = true
            viewGlucoseHeightConst.constant = 0
            self.diabetic = "false"
            self.mrngFastingAlertlbl.text = ""
        }
    }

    func handleTap(){
        gender.endEditing(true)
        height.endEditing(true)
        age.endEditing(true)
        glucose.endEditing(true)
        weight.endEditing(true)
        txtFieldHeightInInch.endEditing(true)
        txtFieldGlucInMg_dL.endEditing(true)
        txtFieldWeightInLb.endEditing(true)
    }
    
    // Methods to save UserInfo
    
    func updateUserInfoData(){
        if (dictToSendToDevice.value(forKey: "username") as? String) == Utility.trimString(self.username.text!){
            self.update()
        }
        else{
            if (coreDataObj.checkUserNotExists(self.username.text!)){
                self.update()
            }
            else{
                Utility.showAlert(errorText, message: signUpVC_alert_userExists, viewController: self)
            }
        }
    }
    
    func update(){
        if  Utility.checkAllTxtFieldValidations(Utility.trimString(self.username.text!), password: Utility.trimString(self.password.text!), age: Utility.trimString(self.age.text!), height: Utility.trimString(self.height.text!), weight: Utility.trimString(self.weight.text!), gender: Utility.trimString(self.gender.text!), glucose: Utility.trimString(self.glucose.text!),viewController: self){
            
            let dict:NSMutableDictionary = NSMutableDictionary()
            if pic != nil{
                let path = Utility.saveImgDocumentDirectory(pic)
                dict.setValue(path, forKey: "imagePath")
            }
            else{
                dict.setValue("", forKey: "imagePath")
            }
            dict.setValue(Utility.trimString(self.username.text!), forKey: "username")
            dict.setValue(Utility.trimString(self.password.text!), forKey: "password")
            dict.setValue(Utility.trimString(self.age.text!), forKey: "age")
            dict.setValue(Utility.trimString(self.height.text!), forKey: "height")
            dict.setValue(Utility.trimString(self.weight.text!), forKey: "weight")
            dict.setValue(Utility.trimString(self.diabetic), forKey: "diabetes")
            dict.setValue(Utility.trimString(self.glucose.text!), forKey: "glucose")
            dict.setValue(Utility.trimString(self.gender.text!), forKey: "gender")
            
            dict.setValue("0", forKey: "biguanide")
            dict.setValue("0", forKey: "sulphonyl")
            dict.setValue("0", forKey: "a_gluc")
            dict.setValue("1", forKey: "no_medication")
            coreDataObj.updateUserInfo(dict)
            do{
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    // Methods to update  profile image
    
   func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.allowsEditing = true
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            picker.allowsEditing = true
            picker.delegate = self
            self.imgViewProfile.contentMode = .scaleAspectFill
            self.imgViewProfile.image = pickedImage
            pic = self.imgViewProfile.image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextField delegates
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.darkGray
        Utility.animateViewMoving(true, moveValue: 120,view:self.view)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = blueColor
        if textField.text != ""{
            switch textField.tag {
            case 105:
                if !(Float(textField.text!) >= 50 && Float(textField.text!) <= 250) {
                    Utility.showAlert(errorText, message: signUpVC_alert_heightInCmIncorrect, viewController: self)
                    textField.text = ""
                    txtFieldHeightInInch.text = ""
                }else{
                    txtFieldHeightInInch.text =  String(describing: NSDecimalNumber(value: Double(height.text!)!*0.393 as Double).rounding(accordingToBehavior: MConstants.behavior))
                    txtFieldHeightInInch.textColor = blueColor
                }
                break
            case 106:
                if !(Float(textField.text!) >= 30 && Float(textField.text!) <= 200) {
                    Utility.showAlert(errorText, message: signUpVC_alert_weightInKgIncorrect, viewController: self)
                    textField.text = ""
                    txtFieldWeightInLb.text = ""
                }else{
                    txtFieldWeightInLb.textColor = blueColor
                    txtFieldWeightInLb.text = String(describing: NSDecimalNumber(value: Double(weight.text!)!*2.2 as Double).rounding(accordingToBehavior: MConstants.behavior))
                }
                break
            case 107:
                if !(Float(textField.text!) >= 3.1 && Float(textField.text!) <= 17.5) {
                    Utility.showAlert(errorText, message: signUpVC_alert_glucInMmolIncorrect, viewController: self)
                    textField.text = ""
                    txtFieldGlucInMg_dL.text = ""
                } else{
                    txtFieldGlucInMg_dL.textColor = blueColor
                    txtFieldGlucInMg_dL.text = String(describing: NSDecimalNumber(value: Utility.mmol_LTomg_gL(Double(glucose.text!)!) as Double).rounding(accordingToBehavior: MConstants.behavior))
                }
                break
            case 31:
                if !(Float(textField.text!) >= 19.7 && Float(textField.text!) <= 98.4) {
                    Utility.showAlert(errorText, message: signUpVC_alert_heightInInchIncorrect, viewController: self)
                    textField.text = ""
                    height.text = ""
                } else{
                    height.text = String(describing: NSDecimalNumber(value: Double(textField.text!)!*2.54 as Double).rounding(accordingToBehavior: MConstants.behavior))
                    height.textColor = blueColor
                }
                break
            case 32:
                if !(Float(textField.text!) >= 66.19 && Float(textField.text!) <= 440.9) {
                    Utility.showAlert(errorText, message: signUpVC_alert_weightInLbIncorrect, viewController: self)
                    textField.text = ""
                    weight.text = ""
                } else{
                    weight.text = String(describing: NSDecimalNumber(value: Double(textField.text!)!*0.45 as Double).rounding(accordingToBehavior: MConstants.behavior))//String(Float(textField.text!)!*0.45)
                    weight.textColor = blueColor
                }
                break//0.453592
            case 33:
                if !(Float(textField.text!) >= 55.86 && Float(textField.text!) <= 315.3) {
                    Utility.showAlert(errorText, message: signUpVC_alert_glucInMgIncorrect, viewController: self)
                    textField.text = ""
                    glucose.text = ""
                } else{
                    glucose.text = String(describing: NSDecimalNumber(value: Utility.mg_dLTomoml_L(Double(textField.text!)!) as Double).rounding(accordingToBehavior: MConstants.behavior))//String(Utility.mg_dLTomoml_L(Double(textField.text!)!))
                    glucose.textColor = blueColor
                }
                break
            default:break
            }
        }
        else{
            switch textField.tag {
            case 105:
                txtFieldHeightInInch.text = ""
                break
            case 106:
                txtFieldWeightInLb.text = ""
                break
            case 107:
                txtFieldGlucInMg_dL.text = ""
                break
            case 31:
                height.text = ""
                break
            case 32:
                weight.text = ""
                break
            case 33:
                glucose.text = ""
                break
            default:break
            }
        }
        Utility.animateViewMoving(false, moveValue: 120,view: self.view)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        var maxLength:Int = Int()
        
        switch textField.tag {
        case 101: maxLength = 20
            break
        case 102: maxLength = 20
            break
        case 103: maxLength = 8
            break
        case 104: maxLength = 2
            break
        case 105: maxLength = 5
            break
        case 106: maxLength = 5
            break
        case 107: maxLength = 5
            break
        case 31: maxLength = 5
            break
        case 32: maxLength = 5
            break
        case 33: maxLength = 5
            break
        default:
            break
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        toolbar.barTintColor = UIColor.white
        toolbar.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(SignUpViewController.doneButtonTapped))
        doneButton.tintColor = UIColor.black
        toolbar.items = [doneButton]
        textField.inputAccessoryView = toolbar
        
        switch textField.tag{
        case 103:
            gender.inputView = genderPicker
            textField.inputView  = genderPicker
            genderPicker.delegate = self
            break
        case 104:
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(SignUpViewController.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
            break
        default :
            break
        }
        return true
    }
    
    // Hide keyboard on Done button action
    func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    // MARK: - Picker view & textfeild delegates
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return genderArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return genderArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        gender.text = genderArr[row]
    }
    
    // MARK: - Date Picker View
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        if Utility.isValidDOB(sender,age: self.age){
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }else{
            Utility.commonPingAlert(self, title: alertText, resString: signUpVC_alert_ageIncorrect)
        }
    }
    
    // MARK: - Button Actions
    
    // Update user profile button action
    @IBAction func createBtnAction(_ sender: UIButton) {
        if diabetic == "true"{
            if glucose.text != ""{
                self.updateUserInfoData()
            }
            else{
                Utility.showAlert(errorText, message: signUpVC_alert_fillAllData, viewController: self)
            }
        }
        else{
            self.updateUserInfoData()
        }
    }
    
    // Sign In button action
    @IBAction func signInBtnAction(_ sender: UIButton) {
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    // choose image btn action
    @IBAction func uploadImgBtnActipn(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
 
}
