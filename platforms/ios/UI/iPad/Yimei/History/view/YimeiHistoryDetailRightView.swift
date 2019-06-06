//
//  YimeiHistoryDetailRightView.swift
//  meim
//
//  Created by jimmy on 2017/6/29.
//
//

import UIKit

class YimeiHistoryDetailRightView: UIView
{
    var history : CDYimeiHistory?
    {
        didSet
        {
            if let history = self.history
            {
                
            }
        }
    }
    
    @IBAction func didConfirmButtonPressed(_ sender : UIButton)
    {
        if let history = self.history
        {
            BSYimeiEditPosOperateRequest(posOperateID: history.operate_id!, params: ["remark": history.remark ?? "", "note": history.note ?? "", "is_update_add_operate": history.is_update_add_operate?.boolValue ?? ""]).execute()
        }
    }
    
    @IBAction func didPrintButtonPressed(_ sender : UIButton)
    {
        if let history = self.history
        {
            let request = BSPrintPosOperateRequestNew()
            request.operateID = history.operate_id
            request.openCashBox = false
            request.isAfterPayment = true;
            request.execute()
        }
    }
}
