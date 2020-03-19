//
//  UILabelFontSize.swift
//  SureshotGPS
//
//  Created by Piyush Gupta on 9/12/16.
//  Copyright © 2016 Piyush Gupta. All rights reserved.
//

import UIKit

class UILabelFontSize: UILabel {
    
    override func awakeFromNib() {
        changeSize()
    }
    
    private func changeSize() {
        let currentSize = self.font.pointSize
        if (UIScreen.mainScreen().bounds.height != 736){
            self.font = self.font.fontWithSize(currentSize-3)
        }
    }
}
