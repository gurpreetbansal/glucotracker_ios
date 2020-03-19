//
//  HamburgerScreenView.swift
//  MyProposalApp
//
//  Created by Pannu on 14/08/16.
//  Copyright © 2016 Pannu. All rights reserved.
//

import UIKit

//MARK: Protocol

protocol HamburgerScreenViewProtocol {
    func hamburgerCellButtonClicked(_ indexPath:IndexPath)
}

class HamburgerScreenView: UIView,UITableViewDelegate,UITableViewDataSource,HamburgerscreenInvestorCellProtocol {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet var hamburgerTableView: UITableView!
    
    var humburgerTableViewCell:HamburgerTableViewCustomCellTableViewCell = HamburgerTableViewCustomCellTableViewCell()
    var delegate:HamburgerScreenViewProtocol?
    let sideBarMenuArr = [menu_bluetoothText, menu_editUserText, menu_unitSettingsText, menu_reminderSettingsText, menu_measurementRecordsText, menu_HealthRefText, menu_manageAccountsText, menu_switchUserText, menu_signOutText]
    //let imageArray = ["user","frnd","inbox","Subscription","frnd","settings"]
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        hamburgerTableView.delegate = self
        hamburgerTableView.dataSource = self
        
        // Register nib file
        hamburgerTableView.register(UINib(nibName: "HamburgerTableViewCustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "HamburgerTableViewCustomCellIdentifier")
    }

    // MARK: - TableView Delegates & Datesource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideBarMenuArr.count
    }
    
    func CellButtonClicked(_ cell:HamburgerTableViewCustomCellTableViewCell){
        let indexPath = self.hamburgerTableView?.indexPath(for: cell)
        self.delegate?.hamburgerCellButtonClicked(indexPath!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HamburgerTableViewCustomCellTableViewCell = hamburgerTableView.dequeueReusableCell(withIdentifier: "HamburgerTableViewCustomCellIdentifier", for: indexPath)as! HamburgerTableViewCustomCellTableViewCell
        cell.delegate = self
        cell.cellLbl.text = sideBarMenuArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height/2)/7
    }
    
}
