//
//  BluetoothConnectivityVC.swift
//  GlucoGenius
//
//  Created by i mark on 08/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import MessageUI
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class TestResultVC: UIViewController,MFMailComposeViewControllerDelegate {

    //MARK:- Outlets & Properties

    @IBOutlet weak var lblGlucose: UILabel!
    @IBOutlet weak var lblHb: UILabel!
    @IBOutlet weak var lblPulse: UILabel!
    @IBOutlet weak var lblBloodFlow: UILabel!
    @IBOutlet weak var lblOxSaturation: UILabel!
    @IBOutlet weak var lblBatteryLife: UILabel!
    @IBOutlet weak var lblEH: UILabel!
    @IBOutlet weak var lblST: UILabel!
    @IBOutlet weak var lblSH: UILabel!
    @IBOutlet weak var lblET: UILabel!
    @IBOutlet weak var screenShotView: UIView!
    @IBOutlet weak var lblGuide: UILabel!
    @IBOutlet weak var lblHistory: UILabel!
    
    var date = String()
    var redColor = UIColor.red
    var showData:NSMutableDictionary = NSMutableDictionary()
    var coreDataObj = CoreData()
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleNotice: UILabel!
    
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
    }
    
    //MARK:- Methods

    func intialSetup(){
        self.navigationController?.isNavigationBarHidden = true
        self.titleLbl.text = testResultVcTitle
        self.titleNotice.numberOfLines = 3
        self.titleNotice.text = testResultVC_titleNotice
//        self.title = "\(testResultVcTitle)\n\(testResultVC_titleNotice)"//testResultVcTitle

//        self.navigationItem.setHidesBackButton(true, animated: false)
       // let backBtn:UIButton = UIButton()
     //   var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(TestResultVC.backBtnAction), for: UIControl.Event.touchUpInside)
       // backBtn.frame=CGRectMake(10, 0, 20, 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
       // barBackBtn = UIBarButtonItem(customView: backBtn)
       // self.navigationItem.leftBarButtonItem = barBackBtn
        
        //let shareBtn:UIButton = UIButton()
       // var barShareBtn:UIBarButtonItem = UIBarButtonItem()
        shareBtn.addTarget(self, action: #selector(TestResultVC.shareReportBtnAction), for: UIControl.Event.touchUpInside)
       // shareBtn.frame=CGRectMake(UIScreen.mainScreen().bounds.width-35, 0, 25, 25)
       // shareBtn.setImage(UIImage(named: "ShareBtn"), forState: UIControlState.Normal)
       // barShareBtn = UIBarButtonItem(customView: shareBtn)
        //self.navigationItem.rightBarButtonItem = barShareBtn
        
        self.showDataOnScreen()

        lblGuide.text = guideVC_title
        lblHistory.text = historyVC_title
    }
    
    func showDataOnScreen(){

        if showData.count != 0{
            lblPulse.text! = "\(Int(showData.value(forKey: "pulse") as! String)!)"
            lblBloodFlow.text! = "\(Int(showData.value(forKey: "speed") as! String)!)"
            lblOxSaturation.text! = "\(Int(showData.value(forKey: "oxSat") as! String)!)"
            
            lblBatteryLife.text! = "\(Int(showData.value(forKey: "battery") as! String)!)"
  
            lblET.text = "\(envrTempCode)\(Float(showData.value(forKey: "envrTemp") as! String)!/10)"
            lblEH.text = "\(envrHumiCode)\(Float(showData.value(forKey: "envrHumi") as! String)!/10)"
            lblST.text = "\(surfTempCode)\(Float(showData.value(forKey: "surfTemp") as! String)!/10)"
            lblSH.text = "\(surfHumiCode)\(Float(showData.value(forKey: "surfHumi") as! String)!/10)"
            
            
            if UserDefaults.standard.string(forKey: "hm_gluc_unit") == "mg_dL"{
                
                lblGlucose.text! = "\(String(describing: NSDecimalNumber(value: Utility.mmol_LTomg_gL(Double(showData.value(forKey: "gluc") as! String)!/10) as Double).rounding(accordingToBehavior: MConstants.behavior)))"
            }
            else{
                lblGlucose.text! = "\(String(describing: NSDecimalNumber(value: Double(showData.value(forKey: "gluc") as! String)!/10 as Double)))"
            }
            
            if UserDefaults.standard.string(forKey: "hm_hb_unit") == "g_L"{
                lblHb.text! = "\(Float(showData.value(forKey: "hb") as! String)! / 10) \(g_LUnitText)"
            }
            else{
                lblHb.text! = "\(Float(showData.value(forKey: "hb") as! String)! / 100) \(g_dLUnitText)"
            }
        }
        
        let testDate = showData.value(forKey: "date") as? Date
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        formatter.dateFormat = "MMM d, yyyy a hh:mm"
        self.date = formatter.string(from: testDate!)
        
        relateTestDataToStandardSettngs(showData)
    }

    func relateTestDataToStandardSettngs(_ testResult : NSMutableDictionary){
        let dict = coreDataObj.fetchRequestForMeasurementSettingsData()
        
        let settingsDict = dict.last
        
            let hgb = Double(testResult.value(forKey: "hb") as! String)!/10
            let oxSat = Double(testResult.value(forKey: "oxSat") as! String)
            let pulse = Double(testResult.value(forKey: "pulse") as! String)
            let bloodFlow = Double(testResult.value(forKey: "speed") as! String)
            let glucose = Utility.mmol_LTomg_gL(Double(testResult.value(forKey: "gluc") as! String)!/10)

            //Glucose
        
            if (testResult.value(forKey: "diet"))! as! String == "2"{
                if glucose>settingsDict!.value(forKey: "twoHrFastGlucoseMax")as? Double || glucose<settingsDict!.value(forKey: "twoHrFastGlucoseMin") as? Double{
                    lblGlucose.textColor = redColor
                }
            }
            else{
                if glucose>settingsDict!.value(forKey: "mrngFastGlucoseMax") as? Double || glucose<settingsDict!.value(forKey: "mrngFastGlucoseMin") as? Double{
                    lblGlucose.textColor = redColor
                }
            }
            
            // Oxygen saturation
            if oxSat>settingsDict!.value(forKey: "oxSatMax") as? Double || oxSat<settingsDict!.value(forKey: "oxSatMin") as? Double{
                lblOxSaturation.textColor = redColor
            }

            // Blood flow(Speed)
            if bloodFlow>settingsDict!.value(forKey: "bloodFlowMax") as? Double || bloodFlow<settingsDict!.value(forKey: "bloodFlowMin") as? Double{
                lblBloodFlow.textColor = redColor
            }
            
            // Pulse
            if pulse>settingsDict!.value(forKey: "pulseMax") as? Double || pulse<settingsDict!.value(forKey: "pulseMin") as? Double{
                lblPulse.textColor = redColor
            }

            // Hemoglobin
            if hgb>settingsDict!.value(forKey: "hbMax") as! Double || hgb<settingsDict!.value(forKey: "hbMin") as! Double{
                lblHb.textColor = redColor
            }
    }
    
    func displayShareSheet(_ shareContent:Data) {
        
        let username = UserDefaults.standard.string(forKey: "hm_username")!
        let message = "\(historyVC_mailMessage) \n \(testResultVC_mailMessage) \(username) \(testResultVC_atText) \(self.date)"
        
        let title = historyVC_mailSubject
        let content = message
        var objectsToShare = [AnyObject]()
        objectsToShare = [title as AnyObject, content as AnyObject, shareContent as AnyObject]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.setValue(title, forKey: "Subject")
        self.present(activityVC, animated: true, completion: nil)
    }
    
    //MARK:- Button Action

    @IBAction func guideBtnAction(_ sender: UIButton) {
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "guideVc") as! GuideVc
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func historyBtnAction(_ sender: UIButton) {
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "historyVC") as! HistoryVC
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    @objc func backBtnAction(){
        if !measurementRecordBack {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true);
        }
        else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func shareReportBtnAction(){
        
        let screenShot = Utility.screenShotMethod(self.screenShotView)
        let imageData: Data = screenShot.pngData()!
        displayShareSheet(imageData)
        //sendEmailButtonTapped()
    }
    
    
    // MARK:- MFMailComposeViewController Delegate
    
    func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let screenShot = Utility.screenShotMethod(self.screenShotView)
        let username = UserDefaults.standard.string(forKey: "hm_username")!
        let message = "\(historyVC_mailMessage) \n \(testResultVC_mailMessage) \(username) \(testResultVC_atText) \(self.date)"
        
        mailComposerVC.setSubject(historyVC_mailSubject)
        mailComposerVC.setMessageBody(message, isHTML: false)
        mailComposerVC.addAttachmentData(screenShot.jpegData(compressionQuality: CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        Utility.showAlert(historyVC_alertTitle_mailNotSend, message: historyVC_alert_mailNotSend, viewController: self)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
