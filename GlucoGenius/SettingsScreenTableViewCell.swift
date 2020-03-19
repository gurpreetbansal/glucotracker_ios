//
//  SettingsScreenTableViewCell.swift
//  GlucoGenius
//
//  Created by i mark on 08/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class SettingsScreenTableViewCell: UITableViewCell {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet weak var cellFieldLbl: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var mySwitch2:SevenSwitch!
    
    //MARK:- View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mySwitch2 = SevenSwitch(frame: CGRect(x: self.bounds.width-100, y: 10, width: 120, height: 40))
        mySwitch2.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        mySwitch2.onTintColor = UIColor(red: 68/255, green: 108/255, blue: 178/255, alpha: 1)
        mySwitch2.thumbTintColor = UIColor(red: 68/255, green: 108/255, blue: 178/255, alpha: 1)
        mySwitch2.thumbImageView.image = UIImage(named: "check.png")
        mySwitch2.isRounded = true
        mySwitch2.setOn(true, animated: true)
        cellView.addSubview(mySwitch2)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Switch Action
    
    @objc func switchChanged(_ sender: SevenSwitch) {
        
        if sender.on{
            mySwitch2.thumbTintColor = UIColor(red: 68/255, green: 108/255, blue: 178/255, alpha: 1)
            mySwitch2.thumbImageView.image = UIImage(named: "check.png")
        }
        else{
            mySwitch2.thumbTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            mySwitch2.thumbImageView.image = UIImage(named: "cross.png")
        }
    }
    
    
}
