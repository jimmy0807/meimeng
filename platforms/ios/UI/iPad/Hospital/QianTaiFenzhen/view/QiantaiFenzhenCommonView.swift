//
//  QiantaiFenzhenCommonView.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit

class QiantaiFenzhenCommonView: UIView
{
    @IBOutlet weak var yuyueView : QiantaiFenzhenYuyueView!
    @IBOutlet weak var daodianView : QiantaiFenzhenDaodianView!
    @IBOutlet weak var middleInfoView : QiantaiFenzhenLeftMiddleInfoView!
    @IBOutlet weak var roomView : QiantaiFenzhenRightRoomView!
    @IBOutlet weak var longInfoView : UIView!
    
    public var didItemMoveFinished : ((_ room : CDZixunRoom, _ book : CDZixunBook) -> Void)?
    public var didDaodianButtonPressed : ((_ member : CDMember?) -> Void)?
    public var wanshanxinxiButtonPressed : ((_ member : CDMember?) -> Void)?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.yuyueView.yuyueCountChange = {[weak self] count in
            self?.middleInfoView.yuyueCount = count
        }
        
        self.daodianView.daodianCountChange = {[weak self] count in
            self?.middleInfoView.daodianCount = count
        }
        
        self.yuyueView.didItemMoveFinished = {[weak self] (point, book) in
            if let book = book, let room = self?.roomView.findRoomItem(point)
            {
                self?.didItemMoveFinished?(room, book)
            }
        }
        
        self.yuyueView.didDaodianButtonPressed = {[weak self] (member) in
            self?.didDaodianButtonPressed?(member)
        }
        
        self.daodianView.wanshanxinxiButtonPressed = {[weak self] (member) in
            self?.wanshanxinxiButtonPressed?(member)
        }
        
        self.daodianView.didItemMoveFinished = {[weak self] (point, book) in
            if let book = book, let room = self?.roomView.findRoomItem(point)
            {
                self?.didItemMoveFinished?(room, book)
            }
        }
        
        var frame = self.longInfoView.frame
        frame.origin.y = 0 - self.yuyueView.frame.size.height;
        self.longInfoView.frame = frame
        self.middleInfoView.isShowdaodianView = false
    }
    
    func didSearchBarTextChanged(_ searchText : String?)
    {
        if self.middleInfoView.isShowdaodianView
        {
            self.daodianView.didSearchTextChanged(searchText)
        }
        else
        {
            self.yuyueView.didSearchTextChanged(searchText)
        }
    }
    
    @IBAction func didLongInfoViewPressed(_ sender: UIButton)
    {
        if self.middleInfoView.isShowdaodianView
        {
            UIView.animate(withDuration: 0.2) {
                var frame = self.longInfoView.frame
                frame.origin.y = 0 - self.yuyueView.frame.size.height;
                self.longInfoView.frame = frame
            }
        }
        else
        {
            UIView.animate(withDuration: 0.2) {
                var frame = self.longInfoView.frame
                frame.origin.y = 0;
                self.longInfoView.frame = frame
            }
        }
        
        self.middleInfoView.isShowdaodianView = !self.middleInfoView.isShowdaodianView
    }
}
