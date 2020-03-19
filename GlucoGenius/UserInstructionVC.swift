//
//  UserInstructionVC.swift
//  Vigori Diary
//
//  Created by i mark on 05/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class UserInstructionVC: UIViewController {

    //MARK:- Outlets & properties

    @IBOutlet weak var lblContent: UILabel!
    var userInstructionBtnTapped = Bool()
    
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
        self.navigationController?.navigationBar.isHidden = false
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(UserInstructionVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    //MARK:- Methods

    func intialSetup(){
        if userInstructionBtnTapped{
            self.title = userInstVC_title
            self.userInstructionScreen()
        }
        else{
            self.title = powerMgmtVC_title
            self.powerManagementScreen()
        }
    }
    
   @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func userInstructionScreen(){
        self.lblContent.text = userInstVC_lblContent
    }

    func powerManagementScreen(){
        self.lblContent.text = powerMgmtVC_lblContent
    }
}
