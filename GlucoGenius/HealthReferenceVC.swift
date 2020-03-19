//
//  HealthReferenceVC.swift
//  Vigori Diary
//
//  Created by i mark on 04/08/17.
//  Copyright © 2017 i mark. All rights reserved.
//

import UIKit

class HealthReferenceVC: UIViewController {

    // MARK: - Outltes & properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imgViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgViewHeightConst.constant = ((imgView.image?.size.height)!/(imgView.image?.size.width)!) * UIScreen.main.bounds.width
        imgViewWidthConst.constant = UIScreen.main.bounds.width-20
        scrollView.contentSize = CGSize(width: self.imgView.bounds.width, height: ((imgView.image?.size.height)!/(imgView.image?.size.width)!) * UIScreen.main.bounds.width)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.title = healthReferenceVC_title
        self.navigationController?.navigationBar.isHidden = false
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(HealthReferenceVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    // MARK: - Button Action
    
    @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }

}
