//
//  ZongkongShoushuView.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit

class ZongkongShoushuView: UIView
{
    @IBOutlet weak var roomView : ZongkongShoushuLeftRoomView!
    @IBOutlet weak var memberView : ZongkongShoushuRightMemberView!
    
    override func awakeFromNib()
    {
        let request = FetchZongkongShoushuRoomRequest()
        request.execute()
        request.finished = {[weak self] (params) in
            self?.relaodData()
        }
        
        self.relaodData()
        
        self.roomView.roomSelected = {[weak self] room in
            self?.memberView.room = room
        }
    }
    
    func relaodData()
    {
        self.roomView.relaodData()
    }
}
