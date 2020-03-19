//
//  UIButtonFont.swift
//  Vigori Diary
//
//  Created by i mark on 08/12/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class UIButtonFont: UIButton {
    
    override func awakeFromNib() {
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.titleLabel?.font.pointSize
        if (UIScreen.main.bounds.height > 736){
            self.titleLabel?.font = (self.titleLabel?.font.withSize(currentSize!+8))! //self.font.fontWithSize(currentSize+10)
        }
    }
}

