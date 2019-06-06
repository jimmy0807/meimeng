//
//  ZongkongDoctorView.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/9.
//

import UIKit

class ZongkongDoctorView: UIView
{
    @IBOutlet weak var personView : ZongkongDoctorLeftPersonView!
    @IBOutlet weak var memberView : ZongkongDoctorRightMemberView!
    
    override func awakeFromNib()
    {
        let request = FetchZongkongDoctorRequest()
        request.execute()
        request.finished = {[weak self] (params) in
            self?.relaodData()
        }
        
        self.relaodData()
        
        self.personView.doctorSelected = {[weak self] doctor in
            self?.memberView.doctor = doctor
        }
    }
    
    func relaodData()
    {
        self.personView.relaodData()
    }
}

