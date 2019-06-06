//
//  YimeiHistoryDetailRightRemarkViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/29.
//
//

import UIKit

class YimeiHistoryDetailRightRemarkViewController: ICTableViewController
{
    @IBOutlet weak var zhifuTextView : KMPlaceholderTextView!
    @IBOutlet weak var remarkTextView : KMPlaceholderTextView!
    @IBOutlet weak var noteTextView : KMPlaceholderTextView!
    @IBOutlet weak var isUpdateAddOperateSwitch : UISwitch!
    
    var history : CDYimeiHistory?
    {
        didSet
        {
            if let history = self.history
            {
                self.zhifuTextView.text = history.statements
                self.remarkTextView.text = history.remark
                self.noteTextView.text = history.note
                self.isUpdateAddOperateSwitch.isOn = history.is_update_add_operate?.boolValue ?? false
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    public func textViewDidChange(_ textView: UITextView)
    {
        if textView === remarkTextView
        {
            self.history?.remark = textView.text
        }
        else if textView === noteTextView
        {
            self.history?.note = textView.text
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch)
    {
        self.history?.is_update_add_operate = sender.isOn as NSNumber
    }
}
