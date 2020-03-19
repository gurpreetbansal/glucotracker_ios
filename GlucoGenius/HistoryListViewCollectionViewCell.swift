//
//  HistoryListViewCollectionViewCell.swift
//  Vigori Diary
//
//  Created by i mark on 06/10/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

protocol HistoryListViewCellProtocol {
    func deleteButtonCellTapped(_ cell:HistoryListViewCollectionViewCell)
}

class HistoryListViewCollectionViewCell: UICollectionViewCell {

    //MARK:- Outlets & Properties
    
    var delegate:HistoryListViewCellProtocol?

    @IBOutlet weak var cellLblDate: UILabel!
    @IBOutlet weak var cellLblTime: UILabel!
    @IBOutlet weak var cellLblResult: UILabel!
    @IBOutlet weak var cellLblDiet: UILabel!
    @IBOutlet weak var cellLblMedi: UILabel!
    @IBOutlet weak var cellLblDelete: UILabel!
    @IBOutlet weak var cellImgViewMedi: UIImageView!
    @IBOutlet weak var cellImgViewDiet: UIImageView!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK:- Button Actions

    @IBAction func deleteBtnAction(_ sender: UIButton) {
        self.delegate?.deleteButtonCellTapped(self)
    }
}
