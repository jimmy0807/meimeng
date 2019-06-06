//
//  H9AnPaiCollectionViewCell.swift
//  meim
//
//  Created by jimmy on 2017/8/2.
//
//

import UIKit

class H9AnPaiCollectionViewCell: UICollectionViewCell
{
    enum DayType
    {
        case last(count : Int, isSelected : Bool)
        case today(count : Int, isSelected : Bool)
        case next(count : Int, isSelected : Bool)
    }
    
    var dayType : DayType?
    {
        didSet
        {
            if let type = dayType
            {
                switch type
                {
                case .last(let count, let isSelected):
                    if isSelected
                    {
                        setSelectedLabel()
                    }
                    else
                    {
                        self.dayLabel.textColor = UIColor.black
                        self.bgImageView.backgroundColor = UIColor.white
                        self.nongliLabel.textColor = RGB(r: 163, g: 174, b: 174)
                    }
                    
                    if count > 0
                    {
                        self.iconImageView.isHidden = false
                        self.iconImageView.backgroundColor = RGB(r: 163, g: 174, b: 174)
                    }
                    else
                    {
                        self.iconImageView.isHidden = true
                    }
                    
                case .today(let count, let isSelected):
                    if isSelected
                    {
                        self.dayLabel.textColor = UIColor.white
                        self.bgImageView.backgroundColor = RGB(r: 255, g: 72, b: 72)
                        self.nongliLabel.textColor = UIColor.white
                        if count > 0
                        {
                            self.iconImageView.isHidden = false
                            self.iconImageView.backgroundColor = UIColor.white
                        }
                        else
                        {
                            self.iconImageView.isHidden = true
                        }
                    }
                    else
                    {
                        self.dayLabel.textColor = RGB(r: 255, g: 72, b: 72)
                        self.bgImageView.backgroundColor = UIColor.white
                        self.nongliLabel.textColor = RGB(r: 255, g: 72, b: 72)
                        if count > 0
                        {
                            self.iconImageView.isHidden = false
                            self.iconImageView.backgroundColor = RGB(r: 255, g: 72, b: 72)
                        }
                        else
                        {
                            self.iconImageView.isHidden = true
                        }
                    }
                case .next(let count, let isSelected):
                    if isSelected
                    {
                        setSelectedLabel()
                    }
                    else
                    {
                        self.dayLabel.textColor = UIColor.black
                        self.bgImageView.backgroundColor = UIColor.white
                        self.nongliLabel.textColor = RGB(r: 163, g: 174, b: 174)
                    }
                    
                    if count > 0
                    {
                        self.iconImageView.isHidden = false
                        self.iconImageView.backgroundColor = RGB(r: 221, g: 42, b: 51)
                    }
                    else
                    {
                        self.iconImageView.isHidden = true
                    }
                }
            }
        }
    }
    
    private func setSelectedLabel()
    {
        self.dayLabel.textColor = UIColor.white
        self.bgImageView.backgroundColor = UIColor.black
        self.nongliLabel.textColor = UIColor.white
    }
    
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var dayLabel : UILabel!
    @IBOutlet weak var nongliLabel : UILabel!
    @IBOutlet weak var iconImageView : UIImageView!
    @IBOutlet weak var bgImageView : UIImageView!
}
