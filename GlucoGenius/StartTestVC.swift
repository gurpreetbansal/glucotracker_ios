//
//  StartTestVC.swift
//  GlucoGenius
//
//  Created by i mark on 20/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class StartTestVC: UIViewController {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet weak var lblInst: UILabel!
    
    var dictToSendToDevice:NSMutableDictionary = NSMutableDictionary()
    var timer = Timer()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        measurementRecordBack = false
        lblInst.text = startTestVC_lblInstText
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(StartTestVC.goToNextScreen), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = startTestVC_title
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    //MARK:- Methods
    
    @objc func goToNextScreen(){
        timer.invalidate()
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "bluetoothConnectivityVC") as! BluetoothConnectivityVC//startTestVC
        secondViewController.dictToSendToDevice = self.dictToSendToDevice
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func startTestBtnAction(_ sender: UIButton) {
    }
}
