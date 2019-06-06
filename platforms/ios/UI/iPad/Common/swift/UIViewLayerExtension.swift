//
//  CALayerExtension.swift
//  VLiveShowSwift
//
//  Created by VincentX on 7/19/16.
//  Copyright © 2016 vipabc. All rights reserved.
//

import UIKit

extension  UIView {
    
    @IBInspectable var layerMaskToBounds: Bool
        {
        set {
            self.layer.masksToBounds = newValue
        }
        get
        {
            return self.layer.masksToBounds
        }
    }
    
    @IBInspectable var layerBorderColor: UIColor?
    {
        set {
            self.layer.borderColor = newValue!.cgColor
        }
        get
        {
            if let color = self.layer.borderColor
            {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var layerBorderWidth: CGFloat
    {
        set {
            self.layer.borderWidth = newValue
        }
        get
        {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var layerCornerRadius: CGFloat
    {
        set {
            self.layer.cornerRadius = newValue
        }
        get
        {
            return self.layer.cornerRadius
        }
    }
    
}

@IBDesignable class UIExtButton: UIButton
{
    @IBInspectable var textLeftInsect: CGFloat = 0
        {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    @IBInspectable var textRightInsect: CGFloat = 0
        {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    
    override var intrinsicContentSize: CGSize
    {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textLeftInsect + textRightInsect, height: size.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = super.sizeThatFits(size)
        return CGSize(width: size.width + textLeftInsect + textRightInsect, height: size.height)
    }
}

@IBDesignable class UIExtLabel: UILabel
{
    @IBInspectable var textLeftInsect: CGFloat = 0
    {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    @IBInspectable var textRightInsect: CGFloat = 0
        {
        didSet
        {
            self.layoutIfNeeded()
        }
    }
    
    override var intrinsicContentSize: CGSize
    {
        get
        {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + textLeftInsect + textRightInsect, height: size.height)
        }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect
    {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: textLeftInsect, bottom: 0, right: textRightInsect))
    }

    override func drawText(in rect: CGRect)
    {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: textLeftInsect, bottom: 0, right: textRightInsect)))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = super.sizeThatFits(size)
        return CGSize(width: size.width + textLeftInsect + textRightInsect, height: size.height)
    }
}

extension UITextField
{
    @IBInspectable var placeholderColor: UIColor?
    {
        set
        {
            self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
        get
        {
            return self.value(forKeyPath: "_placeholderLabel.textColor") as? UIColor
        }
    }
    
    func isEmpty() -> Bool
    {
        guard let text = self.text, !text.isEmpty else
        {
            return true
        }
        
        return false
    }
}

extension UILabel
{
    @IBInspectable var autoAdjustsFontSize: Bool
    {
        set
        {
            self.adjustsFontSizeToFitWidth = newValue
        }
        get
        {
            return self.adjustsFontSizeToFitWidth
        }
    }
    
    func isEmpty() -> Bool
    {
        guard let text = self.text, !text.isEmpty else
        {
            return true
        }
        
        return false
    }
}
