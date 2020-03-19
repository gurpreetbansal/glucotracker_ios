//
//  UITextFieldFont.swift
//  Vigori Diary
//
//  Created by i mark on 08/12/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit

class UITextFieldFont: UITextField {
    
    override func awakeFromNib() {
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.font?.pointSize//self.font.pointSize
        if (UIScreen.main.bounds.height > 736){
            self.font = self.font!.withSize(currentSize!+8)
        }
    }
}
