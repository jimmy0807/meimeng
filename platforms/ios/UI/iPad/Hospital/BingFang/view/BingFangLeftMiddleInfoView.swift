//
//  BingFangLeftMiddleInfoView.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/11.
//

import UIKit

class BingFangLeftMiddleInfoView: UIView
{
    @IBOutlet weak var arrowButton : UIButton!
    @IBOutlet weak var personCountLabel : UILabel!
    @IBOutlet weak var detailLabel : UILabel!
    @IBOutlet weak var topLineImageView : UIImageView!
    @IBOutlet weak var bottomLineImageView : UIImageView!
    //到店 = 已分配， 预约 = 未分配
    var isShowdaodianView : Bool = true
    {
        didSet
        {
            if isShowdaodianView
            {
                self.detailLabel.text = "未分配病房\(yuyueCount)人"
                self.personCountLabel.text = "+\(yuyueCount)"
                
                UIView.animate(withDuration: 0.3) {
                    self.arrowButton.transform = CGAffineTransform(rotationAngle: 0)
                }
                
                self.topLineImageView.isHidden = false
                self.bottomLineImageView.isHidden = true
            }
            else
            {
                self.detailLabel.text = "已分配病房\(daodianCount)人"
                self.personCountLabel.text = "+\(daodianCount)"
                
                UIView.animate(withDuration: 0.3) {
                    self.arrowButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
                
                self.topLineImageView.isHidden = true
                self.bottomLineImageView.isHidden = false
            }
        }
    }
    
    var daodianCount = 0
    {
        didSet
        {
            if !isShowdaodianView
            {
                self.detailLabel.text = "已分配病房\(daodianCount)人"
                self.personCountLabel.text = "+\(daodianCount)"
            }
        }
    }
    
    var yuyueCount = 0
    {
        didSet
        {
            if isShowdaodianView
            {
                self.detailLabel.text = "未分配病房\(yuyueCount)人"
                self.personCountLabel.text = "+\(yuyueCount)"
            }
        }
    }
}
