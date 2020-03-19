

//
//  LoginViewController.swift
//  GlucoGenius
//
//  Created by i mark on 06/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    func blue(_ text:String) -> NSMutableAttributedString {
        let lineattribute : [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.blue,
            .underlineStyle : NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "\(text)", attributes: lineattribute)
        self.append(attributeString)
        return self
    }
    
    func red(_ text:String) -> NSMutableAttributedString {
         let lineattribute : [NSAttributedString.Key : Any] = [
                   .foregroundColor : UIColor.red,
                   .underlineStyle : NSUnderlineStyle.single.rawValue]
               let attributeString = NSMutableAttributedString(string: "\(text)", attributes: lineattribute)
               self.append(attributeString)
        return self
    }
    
    func black(_ text:String) -> NSMutableAttributedString {
         let lineattribute : [NSAttributedString.Key : Any] = [
                   .foregroundColor : UIColor.black,
                   .underlineStyle : NSUnderlineStyle.single.rawValue]
               let attributeString = NSMutableAttributedString(string: "\(text)", attributes: lineattribute)
               self.append(attributeString)
        return self
    }
}

class LoginViewController: UIViewController,UITextFieldDelegate {

    //MARK:- Outlets & Properties

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!

    let coreDataObj:CoreData = CoreData()
    var switchUser = Bool()

     //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        self.txtFieldUsername.text = UserDefaults.standard.string(forKey: "hm_username")
        self.txtFieldPassword.text = UserDefaults.standard.string(forKey: "hm_password")
    }
    
    //MARK:- User defined methods
        
    func intialSetup(){

        let formattedString = NSMutableAttributedString()
        formattedString.black(signUPBtnText1)
        formattedString.blue(signUPBtnText2)
        self.signUpBtn.setAttributedTitle(formattedString, for: UIControl.State())
        self.txtFieldUsername.delegate = self
        self.txtFieldPassword.delegate = self
    }
    
    func isValidUser()->Bool{
       return coreDataObj.CheckForUserNameAndPasswordMatch(Utility.trimString(self.txtFieldUsername.text!), password: Utility.trimString(self.txtFieldPassword.text!))
    }
//    
//    func selectUserButtonClicked(_ username:String){
//        self.txtFieldUsername.text = username
//    }
    
    //MARK: TextField delegates
    
    // dismissing keyboard on pressing return key
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    // dismissing keyboard on pressing return key
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        let maxLength = 22
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    //MARK:- Button Actions

    @IBAction func selectUserBtnAction(_ sender: UIButton) {
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "selectUserVC") as! SelectUserVC
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    // Login button action
    @IBAction func loginBtnAction(_ sender: UIButton) {
        // Check validations
        if Utility.trimString(self.txtFieldPassword.text!) != "" && Utility.trimString(self.txtFieldUsername.text!) != ""{
            if isValidUser(){
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "homeScreenVC") as! HomeScreenVC
            self.navigationController!.pushViewController(secondViewController, animated: true)
            }
            else{
                 Utility.showAlert(oopsText, message: loginVC_alert_userNotExist, viewController: self)
            }
        }
        else{
            Utility.showAlert(errorText, message: loginVC_alert_enterUsernamePwd, viewController: self)
        }
    }
    
    // Sign Up button action
    @IBAction func signUpBtnAction(_ sender: UIButton) {
        
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "signUpVC") as! SignUpViewController
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    // Hide or Unhide password
    @IBAction func showPwdBtnACtion(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.txtFieldPassword.isSecureTextEntry = false
            btnShow.setTitle(hideText, for: UIControl.State.selected)
        }
        else{
            self.txtFieldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func forgotPwdBtnAction(_ sender: UIButton) {
        // No functionality Yet
    }
    
}
