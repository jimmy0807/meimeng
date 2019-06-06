//
//  VLSAutolayoutTextField.swift
//  VLiveShowSwift
//
//  Created by VincentX on 8/2/16.
//  Copyright © 2016 vipabc. All rights reserved.
//

import UIKit

class UIAutoLayoutTextField: UITextField
{
    override var intrinsicContentSize: CGSize
    {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 8, height: size.height)
    }
}
