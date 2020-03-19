//
//  GuideNoticesVC.swift
//  Vigori Diary
//
//  Created by i mark on 05/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class GuideNoticesVC: UIViewController,UICollectionViewDelegate {
    
    //MARK:- Outlets & Properties

    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imgWidthConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imgHeightConst.constant = (((imgView.image?.size.height)!/(imgView.image?.size.width)!) * UIScreen.main.bounds.width)
        imgWidthConst.constant = UIScreen.main.bounds.width-20
        scrollView.contentSize = CGSize(width: self.imgView.bounds.width, height: (((imgView.image?.size.height)!/(imgView.image?.size.width)!) * UIScreen.main.bounds.width)+20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = noticeVC_title
        self.navigationController?.navigationBar.isHidden = false
        let backBtn:UIButton = UIButton()
        var barBackBtn:UIBarButtonItem = UIBarButtonItem()
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        let likeBtnTitle = String.fontAwesomeIcon(name: FontAwesome.chevronLeft)
        backBtn.setTitle(likeBtnTitle, for:UIControl.State())
        backBtn.addTarget(self, action: #selector(GuideNoticesVC.backBtnAction), for: UIControl.Event.touchUpInside)
        backBtn.frame=CGRect(x: 10, y: 0, width: 20, height: 40)
        backBtn.setTitleColor(UIColor.black, for: UIControl.State())
        barBackBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barBackBtn
    }
    
    //MARK:- Back button action

   @objc func backBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }

    
}
