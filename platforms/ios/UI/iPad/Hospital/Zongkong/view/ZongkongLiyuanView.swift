//
//  ZongkongLiyuanView.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit

class ZongkongLiyuanView: UIView
{
    @IBOutlet weak var countView : UIView!
    @IBOutlet weak var countLabel : UILabel!
    
    @IBOutlet weak var leftPersonView : ZongkongLiyuanLeftPersonView!
    @IBOutlet weak var rightItemView : ZongkongLiyuanRightItemView!
    
    override func awakeFromNib()
    {
        let request = FetchZongkongLiyuanRequest()
        request.execute()
        request.finished = {[weak self] (params) in
            self?.relaodData()
        }
        
        self.relaodData()
        
        self.leftPersonView.personSelected = {[weak self] person in
            self?.rightItemView.person = person
        }
    }
    
    func relaodData()
    {
        self.leftPersonView.relaodData()
        self.countLabel.text = String("顾客名单 (\(self.leftPersonView.persons.count))")
    }
}
