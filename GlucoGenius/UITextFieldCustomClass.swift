//
//  UITextFieldCustomClass.swift
//  SureshotGPS
//
//  Created by Piyush Gupta on 8/31/16.
//  Copyright © 2016 Piyush Gupta. All rights reserved.
//

import UIKit

@IBDesignable class UITextFieldCustomClass: UITextFieldFont {

    @IBInspectable var placeholderColor: UIColor = UIColor.black {
        didSet {
            if let placeholder = self.placeholder {
                let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            }
        }
    }
}
