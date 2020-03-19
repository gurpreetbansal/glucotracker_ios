//
//  GuideVc.swift
//  GlucoGenius
//
//  Created by i mark on 08/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class GuideVc: UIViewController{

    // MARK: - Outlets & Properties
    
    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imgWidthConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    var userInstructionBtnTapped = Bool()

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User defined functions

    func intialSetup(){
        
        self.title = guideVC_title
        
        self.navigationController?.isNavigationBarHidden = false
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(GuideVc.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }

    func openUserInstScreen(_ bool:Bool){
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "userInstructionVC") as! UserInstructionVC
        secondViewController.userInstructionBtnTapped = bool
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }

    // MARK: - Button Actions
    
    // Go to User instructions Screen
    @IBAction func userInstBtnAction(_ sender: UIButton) {
        openUserInstScreen(true)
    }
    
    // Go to power Management Screen
    @IBAction func powerMgmtBtnAction(_ sender: UIButton) {
        openUserInstScreen(false)
    }
    
    @IBAction func productBasicsBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func noticesBtnAction(_ sender: UIButton) {
    }

    // Back action
    @objc func backBtnAction(){
        _  = self.navigationController?.popViewController(animated: true)
    }
}
