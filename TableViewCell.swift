//
//  TableViewCell.swift
//  GlucoGenius
//
//  Created by i mark on 06/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //MARK: Outlets & Properties

    @IBOutlet weak var cellLbl: UILabel!
    
    //MARK: Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
