//
//  ManageAccountsVcCustomCell.swift
//  Vigori Diary
//
//  Created by i mark on 04/08/17.
//  Copyright © 2017 i mark. All rights reserved.
//

import UIKit

class ManageAccountsVcCustomCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var checkBoxImage: UIImageView!
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
