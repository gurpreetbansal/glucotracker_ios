//
//  HamburgerTableViewCustomCellTableViewCell.swift
//  MyProposalApp
//
//  Created by Pannu on 19/08/16.
//  Copyright © 2016 Pannu. All rights reserved.
//

import UIKit

protocol HamburgerscreenInvestorCellProtocol {
    func CellButtonClicked(_ cell:HamburgerTableViewCustomCellTableViewCell)
}

class HamburgerTableViewCustomCellTableViewCell: UITableViewCell {
    
    //MARK: Outlets & Properties

    @IBOutlet var cellLbl: UILabel!
    var delegate:HamburgerscreenInvestorCellProtocol?

    //MARK: View life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Button Actions
    
    @IBAction func cellBtnAction(_ sender: UIButton) {
        self.delegate!.CellButtonClicked(self)
    }
}
