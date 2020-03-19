
//
//  HealthReminderCustomCell.swift
//  GlucoGenius
//
//  Created by i mark on 10/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

protocol HealthReminderScreenCellProtocol {
    func healthReminderCellButtonClicked(_ cell:HealthReminderCustomCell)
}

class HealthReminderCustomCell: UITableViewCell {

    //MARK:- Outlets & Properties

    var delegate:HealthReminderScreenCellProtocol!

    @IBOutlet weak var cellLblReminderType: UILabel!
    @IBOutlet weak var cellLblMedication: UILabel!
    @IBOutlet weak var cellBtnReminderTime: UIButton!
    
    //MARK:- Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Button Actions

    @IBAction func reminderBtnAction(_ sender: UIButton) {
        
        self.delegate.healthReminderCellButtonClicked(self)
    }
}
