//
//  QiantaiFenzhenLeftMiddleInfoView.swift
//  meim
//
//  Created by jimmy on 2017/5/27.
//
//

import UIKit

class QiantaiFenzhenLeftMiddleInfoView: UIView
{
    @IBOutlet weak var arrowButton : UIButton!
    @IBOutlet weak var personCountLabel : UILabel!
    @IBOutlet weak var detailLabel : UILabel!
    @IBOutlet weak var topLineImageView : UIImageView!
    @IBOutlet weak var bottomLineImageView : UIImageView!
    
    var isShowdaodianView : Bool = true
    {
        didSet
        {
            if isShowdaodianView
            {
                self.detailLabel.text = "预约客户\(yuyueCount)人"
                self.personCountLabel.text = "+\(yuyueCount)"
                
                UIView.animate(withDuration: 0.3) {
                    self.arrowButton.transform = CGAffineTransform(rotationAngle: 0)
                }
                
                self.topLineImageView.isHidden = false
                self.bottomLineImageView.isHidden = true
            }
            else
            {
                self.detailLabel.text = "到店客户\(daodianCount)人"
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
                self.detailLabel.text = "到店客户\(daodianCount)人"
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
                self.detailLabel.text = "预约客户\(yuyueCount)人"
                self.personCountLabel.text = "+\(yuyueCount)"
            }
        }
    }
}
