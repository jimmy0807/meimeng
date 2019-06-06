//
//  GuadanTableViewCell.swift
//  meim
//
//  Created by jimmy on 2017/7/25.
//
//

import UIKit

class GuadanTableViewCell: UITableViewCell
{
    @IBOutlet weak var noLabel : UILabel!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var detaillabel : UILabel!
    @IBOutlet weak var detaillabel2 : UILabel!
    @IBOutlet weak var statelabel : UILabel!
    
    var guadan : CDHGuadan?
    {
        didSet
        {
            if let guadan = self.guadan
            {
                self.noLabel.text = guadan.no
                self.titleLabel.text = "\(guadan.member_name ?? "")"
                self.detaillabel.text = "科室:\(guadan.departments_name ?? "") 医生:\(guadan.doctor_name ?? "") 设计总监:\(guadan.director_employee_name ?? "") 设计师:\(guadan.designers_name ?? "")"
                self.detaillabel2.text = guadan.display_note
                self.statelabel.text = guadan.state
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

}
