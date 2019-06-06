//
//  UILabelExtension.swift
//  ExandsMaintenance
//
//  Created by jimmy on 16/11/7.
//  Copyright © 2016年 Vintest. All rights reserved.
//

import UIKit

extension UILabel
{
    open func setAttributeString(_ string : String, colorString : String, textColor : UIColor?, textFont : UIFont?) -> Void
    {
        let attributeString = NSMutableAttributedString(string:string)
        let text = string as NSString
        let colorRange = text.range(of: colorString)
        if let color = textColor
        {
            attributeString.addAttribute(NSForegroundColorAttributeName, value: color, range: colorRange)
        }
        
        if let font = textFont
        {
            attributeString.addAttribute(NSFontAttributeName, value: font, range: colorRange)
        }
        
        self.attributedText = attributeString;
    }
}
