//
//  MeasurementRecordVC.swift
//  Vigori Diary
//
//  Created by i mark on 21/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

var measurementRecordBack:Bool!

class MeasurementRecordVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MeasurementRecordCellProtocol,MFMailComposeViewControllerDelegate {

    //MARK:- Outlets & Properties
    
    let coreDataObj = CoreData()
    var recordArr = [NSMutableDictionary]()
    var colorCount = 0
    var uiColorArray = [UIColor]() 
    var colorNumber = 0

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRecordFoundLbl: UILabel!

    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        recordArr = coreDataObj.fetchRequestForMeasurementRecord()
        self.tableView.tableFooterView = UIView()
        if recordArr.count != 0{
            setColorArr()
            self.noRecordFoundLbl.text = ""
        }
        else{
            self.noRecordFoundLbl.text = historyVC_alert_noRecord
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        self.title = measurementRecord_title
        measurementRecordBack = true

        self.navigationItem.setHidesBackButton(true, animated: false)
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(MeasurementRecordVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
        
        let shareBtn:UIButton = UIButton()
        var barShareBtn:UIBarButtonItem = UIBarButtonItem()
        shareBtn.addTarget(self, action: #selector(MeasurementRecordVC.shareReportBtnAction), for: UIControl.Event.touchUpInside)
        shareBtn.frame=CGRect(x: UIScreen.main.bounds.width-35, y: 0, width: 25, height: 25)
        shareBtn.setImage(UIImage(named: "ShareBtn"), for: UIControl.State())
        barShareBtn = UIBarButtonItem(customView: shareBtn)
        self.navigationItem.rightBarButtonItem = barShareBtn
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Others Methods

    func setColorArr(){
        for _ in 0..<recordArr.count{
            switch colorCount {
            case 0:
                self.uiColorArray.append(MConstants.blueColor)
                colorCount += 1
                break
            case 1:
                self.uiColorArray.append(MConstants.yellowColor)
                colorCount += 1
                break
            case 2:
                self.uiColorArray.append(MConstants.greenColor)
                colorCount += 1
                break
            case 3:
                self.uiColorArray.append(MConstants.orangeColor)
                colorCount = 0
                break
            default:
                break
            }
        }
    }
    
    func displayShareSheet(_ shareContent:Data) {
        let username = UserDefaults.standard.string(forKey: "hm_username")!
        let message = "\(historyVC_mailMessage) \n \(testResultVC_mailMessage) \(username)"
        let title = historyVC_mailSubject
        let content = message
        var objectsToShare = [AnyObject]()
        objectsToShare = [title as AnyObject, content as AnyObject, shareContent as AnyObject]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.setValue(title, forKey: "Subject")
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func shareReportBtnAction(){
        if recordArr.count != 0{
            let screenShot = Utility.screenShotMethod(self.view)
            let imageData: Data = screenShot.pngData()!
            displayShareSheet(imageData)
        }
        else{
            Utility.showAlert(errorText, message: historyVC_alert_noRecord, viewController: self)
        }
    }
 
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
 
    //MARK:- Table View delegates

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MeasurementRecordCustomCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! MeasurementRecordCustomCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.glucoseView.backgroundColor = uiColorArray[indexPath.row]

        let dict = recordArr[indexPath.row]
        cell.delegate = self
        let testDate = dict.value(forKey: "date") as? Date
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        formatter.dateFormat = "MMM d, yyyy a hh:mm"
        cell.lblDate.text = formatter.string(from: testDate!)
        
        if dict.value(forKey: "diet") as! String == "2"{
            cell.lblDiet.text = measurementRecord_2HrAfterMealText
        }
        else{
            cell.lblDiet.text = measurementRecord_mrngFasting
        }

        if UserDefaults.standard.string(forKey: "hm_gluc_unit") == "mg_dL"{
            cell.lblGlucose.text! = "\(String(describing: NSDecimalNumber(value: Utility.mmol_LTomg_gL(Double(dict.value(forKey: "gluc") as! String)!/10) as Double).rounding(accordingToBehavior: MConstants.behavior)))"
            cell.lblGlucUnit.text = "\(unit_Btext)"
        }
        else{
            cell.lblGlucose.text! = "\(String(describing: NSDecimalNumber(value: Double(dict.value(forKey: "gluc") as! String)!/10 as Double)))"
            cell.lblGlucUnit.text = "\(unit_AText)"
        }
        
        if dict.value(forKey: "medicine") as! String == "true"
        {
            cell.lblMedication.text = measurementRecord_medicationText
        }
        else{
            cell.lblMedication.text = measurementRecord_noMedicationText
        }
        return cell
    }

    func measurementRecordDelBtnClicked(_ cell: MeasurementRecordCustomCell){
        
        let refreshAlert = UIAlertController(title: alertText, message: measurementRecord_alert_deleteRecord, preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: okText, style: .default, handler: { (action: UIAlertAction!) in
            
            let indexPath = self.tableView?.indexPath(for: cell)
            let appDel  = UIApplication.shared.delegate as! AppDelegate
            let context = appDel.managedObjectContext
            
            let record_id = self.recordArr[(indexPath?.row)!].value(forKey: "record_id") as! String
            
            let fetchPredicate = NSPredicate(format: "record_id == %@", record_id)
            
            // Add Sort Descriptor
            
            let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRecord")
            fetchUsers.predicate                = fetchPredicate
            fetchUsers.returnsObjectsAsFaults   = false
            
            do {
                let fetchedUsers = try context.fetch(fetchUsers)
                
                for fetchedUser in fetchedUsers {
                    
                    
                    context.delete(fetchedUser as! NSManagedObject)
                    do{
                        try context.save()
                        self.recordArr = self.coreDataObj.fetchRequestForMeasurementRecord()
                        self.tableView.reloadData()
                        
                    } catch let error as NSError {
                        // failure
                        print(error)
                    }
                }
            }
            catch {
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "testResultVC") as! TestResultVC
        secondViewController.showData = recordArr[indexPath.row]
        self.navigationController!.pushViewController(secondViewController, animated: true)
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
        
        let screenShot = Utility.screenShotMethod(self.view)
        let username = UserDefaults.standard.string(forKey: "hm_username")!
        let message = "\(historyVC_mailMessage) \n \(testResultVC_mailMessage) \(username)"
        
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
