//
//  MeasurementRecordCustomCell.swift
//  Vigori Diary
//
//  Created by i mark on 24/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

protocol MeasurementRecordCellProtocol {
    func measurementRecordDelBtnClicked(_ cell:MeasurementRecordCustomCell)
}

class MeasurementRecordCustomCell: UITableViewCell {

    //MARK: Outlets & Properties

    @IBOutlet weak var lblGlucose: UILabel!
    @IBOutlet weak var lblGlucUnit: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDiet: UILabel!
    @IBOutlet weak var lblMedication: UILabel!
    @IBOutlet weak var glucoseView: UIView!
    var delegate:MeasurementRecordCellProtocol?

    //MARK: View life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        self.glucoseView.layer.cornerRadius = self.glucoseView.frame.width*0.5
        self.glucoseView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK:- Button Actions

    @IBAction func deleteBtnAction(_ sender: UIButton) {
        self.delegate?.measurementRecordDelBtnClicked(self)
    }
    
}
