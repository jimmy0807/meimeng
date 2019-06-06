//
//  VCommon.swift
//  ExandsWorldTradeMall
//
//  Created by VincentX on 10/6/16.
//  Copyright © 2016 Exands. All rights reserved.
//

import Foundation
import UIKit

func RGB (r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor
{
    return RGBA(r: r, g: g, b: b, a: 1)
}

func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor
{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
