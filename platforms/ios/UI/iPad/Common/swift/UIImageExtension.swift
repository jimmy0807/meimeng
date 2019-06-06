//
//  UIImageExtension.swift
//  ExandsMaintenance
//
//  Created by jimmy on 16/11/4.
//  Copyright © 2016年 Vintest. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    func scaleToSize(_ size : CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    func scaleToMaxWidth(_ maxWidth : CGFloat) -> UIImage
    {
        let sourceImageWidth = self.size.width;
        let sourceImageHeight = self.size.height;
        
        var destImageWidth = sourceImageWidth;
        var destImageHeight = sourceImageHeight;
        if ( sourceImageWidth > maxWidth )
        {
            destImageWidth = maxWidth;
            destImageHeight = (destImageWidth) * sourceImageHeight / sourceImageWidth;
        }
        
        return scaleToSize(CGSize(width: destImageWidth, height: destImageHeight))
    }
}

