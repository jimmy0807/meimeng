//
//  ZixunCreateView.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/25.
//

import UIKit

class ZixunCreateView : UIView {
    
    var createTableView : ZixunCreateTableViewController!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    @IBAction func closeButtonPressed(_ sender:UIButton)
    {
        self.isHidden = true
    }
    
    @IBAction func saveButtonPressed(_ sender:UIButton)
    {
        if createTableView.selectInfo.member == nil {
            let alert = UIAlertController(title: nil, message: "请选择会员", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        if createTableView.selectInfo.zixunroom == nil {
            let alert = UIAlertController(title: nil, message: "请选择咨询室", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        if createTableView.selectInfo.state == nil {
            let alert = UIAlertController(title: nil, message: "请选择顾客状态", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
//        if createTableView.selectInfo.shejishi == nil {
//            let alert = UIAlertController(title: nil, message: "请选择设计师", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
//            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
//            return
//        }
//        if createTableView.selectInfo.shejizongjian == nil {
//            let alert = UIAlertController(title: nil, message: "请选择设计总监", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
//            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
//            return
//        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SaveCreateZixun"), object: nil)
            self.isHidden = true
    }
    
}
