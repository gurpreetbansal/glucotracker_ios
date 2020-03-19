//
//  MeasurementSettingsVC.swift
//  GlucoGenius
//
//  Created by i mark on 20/09/16.
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


class MeasurementSettingsVC: UIViewController,UITextFieldDelegate ,MFMailComposeViewControllerDelegate{
    
    //MARK:- Outlets & Properties
    
    @IBOutlet weak var txtFieldSaO2MT: UITextField!
    @IBOutlet weak var txtFieldSaO2LT: UITextField!
    @IBOutlet weak var txtFieldHbMT: UITextField!
    @IBOutlet weak var txtFieldHbLT: UITextField!
    @IBOutlet weak var txtFieldBfvMT: UITextField!
    @IBOutlet weak var txtFieldBfvLT: UITextField!
    @IBOutlet weak var txtFieldPulseMT: UITextField!
    @IBOutlet weak var txtFieldPulseLT: UITextField!
    @IBOutlet weak var txtFieldGlucMrngFastMT: UITextField!
    @IBOutlet weak var txtFieldGlucMrngFastLT: UITextField!
    @IBOutlet weak var txtFieldGluc2HrLT: UITextField!
    @IBOutlet weak var txtFieldGluc2HrMT: UITextField!
    @IBOutlet weak var txtFeildEmail1: UITextField!
    @IBOutlet weak var txtFeildEmail2: UITextField!
    @IBOutlet weak var txtFieldEmail3: UITextField!
    
    var coreDataObj = CoreData()
    let redColor = UIColor.red
    let blackColor = UIColor.black
    var healthContent = String()
    var userTestResultDict = [NSMutableDictionary]()
    var black = UIColor.black
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserLastTestResult()
        fetchUserLastMeasurementSettings()
        self.intialSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = measurementSettingsVC_title
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Methods
    
    func intialSetup(){
        txtFeildEmail1.delegate = self
        txtFeildEmail2.delegate = self
        txtFieldEmail3.delegate = self
        txtFieldSaO2MT.delegate = self
        txtFieldSaO2LT.delegate = self
        txtFieldHbMT.delegate = self
        txtFieldHbLT.delegate = self
        txtFieldBfvMT.delegate = self
        txtFieldBfvLT.delegate = self
        txtFieldPulseMT.delegate = self
        txtFieldPulseLT.delegate = self
        txtFieldGlucMrngFastMT.delegate = self
        txtFieldGlucMrngFastLT.delegate = self
        txtFieldGluc2HrLT.delegate = self
        txtFieldGluc2HrMT.delegate = self
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(MeasurementSettingsVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    
    }
    
    func fetchUserLastTestResult(){
        userTestResultDict = coreDataObj.fetchRequestForTestDetail()
    }
    
    func fetchUserLastMeasurementSettings(){
        let dict = coreDataObj.fetchRequestForMeasurementSettingsData()

        let settingsDict = dict.last
        
        self.txtFieldSaO2MT.text = String(settingsDict?.value(forKey: "oxSatMax") as! Int)
        self.txtFieldSaO2LT.text = String(settingsDict?.value(forKey: "oxSatMin") as! Int)
        self.txtFieldHbMT.text = String(settingsDict?.value(forKey: "hbMax") as! Int)
        self.txtFieldHbLT.text = String(settingsDict?.value(forKey: "hbMin") as! Int)
        self.txtFieldBfvMT.text = String(settingsDict?.value(forKey: "bloodFlowMax") as! Int)
        self.txtFieldBfvLT.text = String(settingsDict?.value(forKey: "bloodFlowMin") as! Int)
        self.txtFieldPulseMT.text = String(settingsDict?.value(forKey: "pulseMax") as! Int)
        self.txtFieldPulseLT.text = String(settingsDict?.value(forKey: "pulseMin") as! Int)
        self.txtFieldGlucMrngFastMT.text = String(settingsDict?.value(forKey: "mrngFastGlucoseMax") as! Int)
        self.txtFieldGlucMrngFastLT.text = String(settingsDict?.value(forKey: "mrngFastGlucoseMin") as! Int)
        self.txtFieldGluc2HrLT.text = String(settingsDict?.value(forKey: "twoHrFastGlucoseMin") as! Int)
        self.txtFieldGluc2HrMT.text = String(settingsDict?.value(forKey: "twoHrFastGlucoseMax") as! Int)
        self.txtFeildEmail1.text = settingsDict?.value(forKey: "email") as? String
        
        self.txtFeildEmail2.text = settingsDict?.value(forKey: "email2") as? String

        self.txtFieldEmail3.text = settingsDict?.value(forKey: "email3") as? String

        relateTestDataToStandardSettngs(userTestResultDict)
    }

    func relateTestDataToStandardSettngs(_ dict : [NSMutableDictionary]){
        let testResult = dict.last

        if testResult != nil{
            
            let glucose = Utility.mmol_LTomg_gL(Double(testResult?.value(forKey: "gluc") as! String)!/10)
           
            let hgb = Double(testResult?.value(forKey: "hb") as! String)!/10
            
            let oxSat = Double(testResult?.value(forKey: "oxSat") as! String)
            let pulse = Double(testResult?.value(forKey: "pulse") as! String)
            let bloodFlow = Double(testResult?.value(forKey: "speed") as! String)
            
            let username = UserDefaults.standard.string(forKey: "hm_username")
            
            let time = testResult?.value(forKey: "time") as! String
            
            let date = testResult?.value(forKey: "date") as! Date
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

            formatter.dateFormat = "yyyy-MM-dd"
            let dateStr = formatter.string(from: date)
            //Glucose
            
            if (testResult?.value(forKey: "diet"))! as! String == "2"{
                if glucose>Double(txtFieldGluc2HrMT.text!){
                    txtFieldGluc2HrMT.textColor = blackColor
                }
                if glucose<Double(txtFieldGluc2HrLT.text!){
                    txtFieldGluc2HrLT.textColor = blackColor
                }
            }
            else{
                if glucose>Double(txtFieldGlucMrngFastMT.text!){
                    txtFieldGlucMrngFastMT.textColor = blackColor
                }
                if glucose<Double(txtFieldGlucMrngFastLT.text!){
                    txtFieldGlucMrngFastLT.textColor = blackColor
                }
            }
            
            // Oxygen saturation
            if oxSat>Double(txtFieldSaO2MT.text!){
                txtFieldSaO2MT.textColor = blackColor
            }
            if oxSat<Double(txtFieldSaO2LT.text!){
                txtFieldSaO2LT.textColor = blackColor
            }
            
            // Blood flow(Speed)
            if bloodFlow>Double(txtFieldBfvMT.text!){
                txtFieldBfvMT.textColor = blackColor
            }
            if bloodFlow<Double(txtFieldBfvLT.text!){
                txtFieldBfvLT.textColor = blackColor
            }
            
            // Pulse
            if pulse>Double(txtFieldPulseMT.text!){
                txtFieldPulseMT.textColor = blackColor
            }
            if pulse<Double(txtFieldPulseLT.text!){
                txtFieldPulseLT.textColor = blackColor
            }
            
            // Hemoglobin
            if hgb>Double(txtFieldHbMT.text!){
                txtFieldHbMT.textColor = blackColor
            }
            if hgb<Double(txtFieldHbLT.text!){
                txtFieldHbLT.textColor = blackColor
            }
            healthContent = HealthReportContent.emailContent(username!,hbUnit:g_LUnitText, glucUnit:mg_dLUnitText, date: dateStr, time: time, dict: testResult!)
        }
    }

    func createPDF()->String {
        let html = "\(healthContent)"

        let fmt = UIMarkupTextPrintFormatter(markupText: html)
        
        // 2. Assign print formatter to UIPrintPageRenderer
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        // 3. Assign paperRect and printableRect
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 641) // A4, 72 dpi2480 X 3508 pixels
        
        let printable = page.insetBy(dx: 0, dy: 20)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        
        for i in 1...render.numberOfPages {
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        
        // 5. Save PDF file
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        pdfData.write(toFile: "\(documentsPath)/\(measurementSettingsVC_reportName).pdf", atomically: true)
        return "\(documentsPath)/\(measurementSettingsVC_reportName).pdf"
    }
    
    func saveMeasurementSettings(){
        
        if txtFieldHbMT.text! != "" && txtFieldHbLT.text! != ""  && txtFieldGluc2HrLT.text != ""  && txtFieldGluc2HrMT.text != ""  && txtFieldGlucMrngFastLT.text != ""  && txtFieldGlucMrngFastMT.text != ""  && txtFieldPulseLT.text != ""  && txtFieldPulseMT.text != ""  && txtFieldBfvLT.text != ""  && txtFieldBfvMT.text != ""  && txtFieldSaO2LT.text != "" && txtFieldSaO2MT.text != ""{
            
        if Double(Utility.trimString(self.txtFieldHbMT.text!)) > Double(Utility.trimString(self.txtFieldHbLT.text!))  && Double(Utility.trimString(self.txtFieldGluc2HrMT.text!)) > Double(Utility.trimString(self.txtFieldGluc2HrLT.text!))  && Double(Utility.trimString(self.txtFieldGlucMrngFastMT.text!)) > Double(Utility.trimString(self.txtFieldGlucMrngFastLT.text!)) && Double(Utility.trimString(self.txtFieldPulseMT.text!)) > Double(Utility.trimString(self.txtFieldPulseLT.text!)) && Double(Utility.trimString(self.txtFieldSaO2MT.text!)) > Double(Utility.trimString(self.txtFieldSaO2LT.text!)) && Double(Utility.trimString(self.txtFieldBfvMT.text!)) > Double(Utility.trimString(self.txtFieldBfvLT.text!)) {
            
            let dict:NSMutableDictionary = NSMutableDictionary()
            
            dict.setValue(Int(Utility.trimString(self.txtFieldHbMT.text!)), forKey: "hbMax")
            dict.setValue(Int(Utility.trimString(self.txtFieldHbLT.text!)), forKey: "hbMin")
            
            dict.setValue(Int(Utility.trimString(self.txtFieldGluc2HrLT.text!)), forKey: "twoHrFastGlucoseMin")
            dict.setValue(Int(Utility.trimString(self.txtFieldGluc2HrMT.text!)), forKey: "twoHrFastGlucoseMax")
            
            dict.setValue(Int(Utility.trimString(self.txtFieldGlucMrngFastLT.text!)), forKey: "mrngFastGlucoseMin")
            dict.setValue(Int(Utility.trimString(self.txtFieldGlucMrngFastMT.text!)), forKey: "mrngFastGlucoseMax")
            
            dict.setValue(Int(Utility.trimString(self.txtFieldPulseLT.text!)), forKey: "pulseMin")
            dict.setValue(Int(Utility.trimString(self.txtFieldPulseMT.text!)), forKey: "pulseMax")
            
            dict.setValue(Int(Utility.trimString(self.txtFieldSaO2LT.text!)), forKey: "oxSatMin")
            dict.setValue(Int(Utility.trimString(self.txtFieldSaO2MT.text!)), forKey: "oxSatMax")
            
            dict.setValue(Int(Utility.trimString(self.txtFieldBfvLT.text!)), forKey: "bloodFlowMin")
            dict.setValue(Int(Utility.trimString(self.txtFieldBfvMT.text!)), forKey: "bloodFlowMax")
            
            dict.setValue(Utility.trimString(self.txtFeildEmail1.text!), forKey: "email")
            dict.setValue(Utility.trimString(self.txtFeildEmail2.text!), forKey: "email2")
            dict.setValue(Utility.trimString(self.txtFieldEmail3.text!), forKey: "email3")

            alert(dict)

        }
        else{
            Utility.showAlert(errorText, message: measurementSettingsVC_alert_incorrectValues, viewController: self)
            self.setAllTextFieldsTextColor()
            self.fetchUserLastMeasurementSettings()
        }
        }
        else{
            Utility.showAlert(errorText, message: measurementSettingsVC_alert_IncompleteData, viewController: self)
            self.setAllTextFieldsTextColor()
            self.fetchUserLastMeasurementSettings()
        }
    }

    func alert(_ dict : NSMutableDictionary){
        let refreshAlert = UIAlertController(title: alertText, message: measurementSettingsVC_alert_changeSettings, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: okText, style: .default, handler: { (action: UIAlertAction!) in
            self.setAllTextFieldsTextColor()
            self.coreDataObj.saveMeasurementSettingsData(dict)
            self.fetchUserLastMeasurementSettings()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { (action: UIAlertAction!) in
            self.setAllTextFieldsTextColor()
            self.fetchUserLastMeasurementSettings()
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func setAllTextFieldsTextColor(){
        txtFieldSaO2MT.textColor = black
        txtFieldSaO2LT.textColor = black
        txtFieldHbMT.textColor = black
        txtFieldHbLT.textColor = black
        txtFieldBfvMT.textColor = black
        txtFieldBfvLT.textColor = black
        txtFieldPulseMT.textColor = black
        txtFieldPulseLT.textColor = black
        txtFieldGlucMrngFastMT.textColor = black
        txtFieldGlucMrngFastLT.textColor = black
        txtFieldGluc2HrLT.textColor = black
        txtFieldGluc2HrMT.textColor = black
    }

    func displayShareSheet() {
        
        let title = historyVC_mailSubject
        let content = historyVC_mailMessage
        
        let file = createPDF()
        let fileURL = URL(fileURLWithPath: file)
        
        var objectsToShare = [AnyObject]()
        objectsToShare = [title as AnyObject, content as AnyObject, fileURL as AnyObject]

        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.setValue(title, forKey: "Subject")
        self.present(activityVC, animated: true, completion: nil)
    }
    
    //MARK:- Button Actions
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func sendEmailBtnAction(_ sender: UIButton) {
        if userTestResultDict.count != 0{
            displayShareSheet()
        }
        else{
            Utility.showAlert(errorText, message: historyVC_alert_noRecord, viewController: self)
        }
    }
    
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        self.saveMeasurementSettings()
    }

    //MARK: TextField delegates
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag != 421 && textField.tag != 621 && textField.tag != 422 && textField.tag != 622{
        Utility.animateViewMoving(true, moveValue: 160,view: self.view)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        var maxLength = Int()
        
        switch textField.tag {
        case 551:
            maxLength = 50
            break
        case 552:
            maxLength = 50
            break
        case 553:
            maxLength = 50
            break
        default:
            maxLength = 3
            break
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag != 421 && textField.tag != 621 && textField.tag != 422 && textField.tag != 622{

        Utility.animateViewMoving(false, moveValue: 160,view: self.view)
        }
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
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([txtFeildEmail1.text!,txtFeildEmail2.text!,txtFieldEmail3.text!])
        
        mailComposerVC.setSubject(historyVC_mailSubject)
        mailComposerVC.setMessageBody(historyVC_mailMessage, isHTML: false)
        
        let filePaths = createPDF()
        
        if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePaths)) {
            mailComposerVC.addAttachmentData(fileData, mimeType: "application/pdf", fileName: measurementSettingsVC_reportName)//"application/.pdf"
        }
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        Utility.showAlert(historyVC_alertTitle_mailNotSend, message: historyVC_alert_mailNotSend, viewController: self)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        toolbar.barTintColor = UIColor.white
        toolbar.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(MeasurementSettingsVC.doneButtonTapped))
        doneButton.tintColor = UIColor.black
        toolbar.items = [doneButton]
        textField.inputAccessoryView = toolbar
        return true
    }

}
