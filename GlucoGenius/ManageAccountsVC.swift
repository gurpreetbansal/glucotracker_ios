//
//  ManageAccountsVC.swift
//  Vigori Diary
//
//  Created by i mark on 04/08/17.
//  Copyright © 2017 i mark. All rights reserved.
//

import UIKit
import CoreData

class ManageAccountsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var noUserFoundLbl: UILabel!
    
    var allUsersAccount = [NSDictionary]()
    var selectedUsersList = [NSDictionary]()
    var coreDataObj:CoreData = CoreData()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set Navigation Bar UI
        self.navBarSetup()
        
        // Fetch all resgister accounts
        self.fetchAllRegisterUsers()
        self.deleteBtn.setTitle(deleteText, for: UIControl.State.normal)
        self.userListTableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func navBarSetup(){
        self.title = manageAccounts_title
        self.navigationController?.navigationBar.isHidden = false
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(ManageAccountsVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame = MConstants.backBtnFrame
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    func fetchAllRegisterUsers(){
        self.allUsersAccount.removeAll()
        // Fetch all resgister accounts
        let usersList = coreDataObj.allRegisterUsers() as [NSDictionary]
        
        if usersList.count != 1{
            print("All users : ", usersList.count)
            self.noUserFoundLbl.text = ""
            
            for i in 0..<usersList.count{
                if usersList[i].value(forKey: "user_id") as! String != UserDefaults.standard.value(forKey: "hm_user_id") as! String{
                    
                    let dict:NSMutableDictionary = usersList[i].mutableCopy() as! NSMutableDictionary
                    dict.setValue(0, forKey: "state")
                    self.allUsersAccount.append(dict)
                }
            }
        }
        else{
            self.deleteBtn.isHidden = true
            self.noUserFoundLbl.text = manageAccounts_noUserFoundAlert
        }
        self.userListTableView.reloadData()
    }
    
    // MARK: - Table View delegates & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUsersAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManageAccountsVcCustomCell
        
        let dict = self.allUsersAccount[indexPath.row]
        
        cell.userNameLbl.text = dict.value(forKey: "username") as? String
        
        if dict.value(forKey: "state") as! Int == 1{
            cell.checkBoxImage.image = UIImage(named: "check")//blueCheck
        } else{
            cell.checkBoxImage.image = UIImage(named: "uncheck")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.userListTableView.cellForRow(at: indexPath) as! ManageAccountsVcCustomCell
        
        // Handle Selected users list
        
        if self.allUsersAccount[indexPath.row].value(forKey: "state") as! Int == 1{
            
            cell.checkBoxImage.image = UIImage(named: "uncheck")//blueUncheck
            
            self.selectedUsersList = self.selectedUsersList.filter{$0 != self.allUsersAccount[indexPath.row]}
            
            self.allUsersAccount[indexPath.row].setValue(0, forKey: "state")
            
            //print("removed  ",selectedUsersList)
        }
        else{
            
            cell.checkBoxImage.image = UIImage(named: "check")
            
            selectedUsersList.append(self.allUsersAccount[indexPath.row])
            
            self.allUsersAccount[indexPath.row].setValue(1, forKey: "state")
            
            //print("inserted  ",selectedUsersList)
        }
        print("All ....",self.allUsersAccount)
    }
    
    func deleteSelectedUserRecords(userID:String){
        let appDel  = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let fetchPredicate = NSPredicate(format: "user_id == %@", userID)
        
        let fetchUserRecords                      = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRecord")
        fetchUserRecords.predicate                = fetchPredicate
        fetchUserRecords.returnsObjectsAsFaults   = false
        
        do {
            let fetchedUsers = try context.fetch(fetchUserRecords)
            
            for fetchedUser in fetchedUsers {
                
                context.delete(fetchedUser as! NSManagedObject)
                do{
                    try context.save()
                    print("All user records deleted")
                } catch let error as NSError {
                    // failure
                    print(error)
                }
            }
        }catch {// failure
            print(error)
        }
    }
    
    func deleteSelectedUserReminderSettings(userID:String){
        let appDel  = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let fetchPredicate = NSPredicate(format: "user_id == %@", userID)
        
        let fetchUserReminderSettings                      = NSFetchRequest<NSFetchRequestResult>(entityName: "UserReminderSettings")
        fetchUserReminderSettings.predicate                = fetchPredicate
        fetchUserReminderSettings.returnsObjectsAsFaults   = false
        
        do {
            let fetchedUsers = try context.fetch(fetchUserReminderSettings)
            
            for fetchedUser in fetchedUsers {
                
                context.delete(fetchedUser as! NSManagedObject)
                do{
                    try context.save()
                    print("All user Reminder settings deleted")
                } catch let error as NSError {
                    // failure
                    print(error)
                }
            }
        }catch {// failure
            print(error)
        }
    }
    
    func deleteSelectedUserMeasurementSettings(userID:String){
        let appDel  = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        let fetchPredicate = NSPredicate(format: "user_id == %@", userID)
        
        let fetchUserMeasurementSettings                      = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMeasurementSettings")
        fetchUserMeasurementSettings.predicate                = fetchPredicate
        fetchUserMeasurementSettings.returnsObjectsAsFaults   = false
        
        do {
            let fetchedUsers = try context.fetch(fetchUserMeasurementSettings)
            
            for fetchedUser in fetchedUsers {
                
                context.delete(fetchedUser as! NSManagedObject)
                do{
                    try context.save()
                    print("All user Measurement settings deleted")
                } catch let error as NSError {
                    // failure
                    print(error)
                }
            }
        }catch {// failure
            print(error)
        }
    }
    
    // MARK: - Button actions
    
    // Delete Selected users
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        
        if self.selectedUsersList.count != 0{
            
            let refreshAlertView = UIAlertController(title: alertText, message: manageAccounts_deleteAccAlert, preferredStyle: UIAlertController.Style.alert)
            refreshAlertView.addAction(UIAlertAction(title: okText, style: .default, handler: { (action: UIAlertAction!) in
                
                let allUserAccountsArr = self.allUsersAccount
                
                // 1 Delete Selected user account
                for i in 0..<allUserAccountsArr.count{
                    
                    if allUserAccountsArr[i].value(forKey: "state") as? Int == 1{
                        let appDel  = UIApplication.shared.delegate as! AppDelegate
                        let context = appDel.managedObjectContext
                        
                        let userID = allUserAccountsArr[i].value(forKey: "user_id") as! String
                        let fetchPredicate = NSPredicate(format: "user_id == %@", userID)
                        
                        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
                        fetchUsers.predicate                = fetchPredicate
                        fetchUsers.returnsObjectsAsFaults   = false
                        
                        do {
                            let fetchedUsers = try context.fetch(fetchUsers)
                            
                            print("Fetched user count : ", fetchedUsers.count)
                            
                            for fetchedUser in fetchedUsers {
                                context.delete(fetchedUser as! NSManagedObject)
                                do{
                                    try context.save()
                                    
                                    // 3 Delete selected user's all data
                                    self.deleteSelectedUserRecords(userID: userID)
                                    self.deleteSelectedUserReminderSettings(userID: userID)
                                    self.deleteSelectedUserMeasurementSettings(userID: userID)
                                } catch let error as NSError {
                                    // failure
                                    print(error)
                                }
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
                Utility.showAlert(alertText, message: manageAccounts_accDeletedAlert, viewController: self)
                self.fetchAllRegisterUsers()
            }))
            refreshAlertView.addAction(UIAlertAction(title: cancelText, style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            present(refreshAlertView, animated: true, completion: nil)
        }
        else{
            Utility.showAlert(alertText, message: manageAccounts_noAccToDeleteAlert, viewController: self)
        }
     }
    
    // Back button action
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
