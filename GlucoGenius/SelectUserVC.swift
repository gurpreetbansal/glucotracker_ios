//
//  SelectUserVC.swift
//  GlucoGenius
//
//  Created by i mark on 23/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class SelectUserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var users:NSArray = NSArray()
    var coreDataObj:CoreData = CoreData()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.users = coreDataObj.allRegisterUsers() as NSArray
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = selectUserVC_title
        self.navigationController?.isNavigationBarHidden = false
        
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(SelectUserVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    //MARK:- Methods
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Table View delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectUserCustomCell
        
        let dict:NSDictionary = users.object(at: indexPath.row) as! NSDictionary
        let username = dict.value(forKey: "username") as! String
        
        cell.textLabel?.text = username
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectUserCustomCell
        
        let currentSize = cell.textLabel?.font.pointSize
        
        if (UIScreen.main.bounds.height > 736){
            cell.textLabel?.font = cell.textLabel?.font.withSize(currentSize!+8)
        }
        else{
            cell.textLabel?.font = cell.textLabel?.font.withSize(currentSize!)
        }
        
        UserDefaults.standard.setValue(cell.textLabel?.text, forKey: "hm_username")
        UserDefaults.standard.setValue((users.object(at: indexPath.row) as AnyObject).value(forKey: "password") as! String, forKey: "hm_password")
        UserDefaults.standard.setValue((users.object(at: indexPath.row) as AnyObject).value(forKey: "user_id") as! String, forKey: "hm_user_id")
        //self.delegate?.selectUserButtonClicked((cell.textLabel?.text)!)
        
        _ = self.navigationController?.popViewController(animated: true)

//        if switchUser{
//            self.navigationController?.popViewController(animated: true)
//        }
//        else{
//            self.navigationController?.popViewController(animated: true)
//        }
    }
}
