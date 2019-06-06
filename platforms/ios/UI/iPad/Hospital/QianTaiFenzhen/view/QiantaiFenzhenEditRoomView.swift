//
//  QiantaiFenzhenEditRoomView.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class QiantaiFenzhenEditRoomView: UIView {

    var room : CDZixunRoom?
    var edidRoomFinsihed: ((Void) -> Void)?
    
    public func show()
    {
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        })
        self.registerNofitification(forMainThread: "HideFenZhen")
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "HideFenZhen" )
        {
            self.hide()
        }
    }
    
    public func hide()
    {
        UIView.animate(withDuration: 0.2, animations: { 
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
    }
    
    @IBAction func didConfirmButtonPressed(_ sender: UIButton)
    {
        self.edidRoomFinsihed?()
    }
    
    @IBAction func didCloseButtonPressed(_ sender: UIButton)
    {
        hide()
    }
}
