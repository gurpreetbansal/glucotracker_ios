//
//  GuideVc.swift
//  GlucoGenius
//
//  Created by i mark on 08/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class StartingScreenVC: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupDescLabel: UITextView!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = startTile
        self.popupTitleLabel.text = popupTitle
        self.popupDescLabel.text = popupDesc
        self.acceptButton.setTitle(acceptBtnText, for: UIControl.State.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User defined functions
    @IBAction func acceptBtnAction(_ sender: UIButton) {
        
        if( UserDefaults.standard.object(forKey: "hm_user_id") != nil)
        {
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "homeScreenVC") as! HomeScreenVC
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else{
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
}
