//
//  QianTaiFenzhenMainViewController.swift
//  meim
//
//  Created by jimmy on 2017/5/27.
//
//

import UIKit

class QianTaiFenzhenMainViewController: ICCommonViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var selectTimeView : QiantaiFenzhenEditRoomView!
    @IBOutlet weak var commonView : QiantaiFenzhenCommonView!
    var selectTimeVC : QiantaiFenzhenSelectTimeViewController!
    var selectedMember : CDMember?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        searchBar.layer.borderColor = RGB(r: 237, g: 237, b: 237).cgColor
        searchBar.backgroundImage = UIImage(named: "pad_background_white_color")?.imageResizable(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12))
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "pad_member_search_field")?.imageResizable(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12)), for: .normal)
        
        self.commonView.didItemMoveFinished = {[weak self] (room, book) in
            print("room.is_recycle = \(String(describing: room.is_recycle))")
            if let r = room.is_recycle, r.boolValue
            {
                let request = EditHQiantiFenzhenRoomRequest()
                request.params["reservation_id"] = book.book_id
                request.params["room_id"] = room.room_id
                request.execute()
            }
            else
            {
                print("咨询室使用状态\(room.state)")
                //咨询室使用状态Optional("使用中")

                
                self?.selectTimeView.show()
                self?.selectTimeVC.book = book
                self?.selectTimeView.edidRoomFinsihed = {
                    let info = self?.selectTimeVC.selectInfo
                    if info?.shejishi == 0
                    {
                        let v = UIAlertView(title: "", message: "请选择设计师", delegate: nil, cancelButtonTitle: "好的")
                        v.show()
                    }
                    else
                    {
                        let request = EditHQiantiFenzhenRoomRequest()
                        request.params["reservation_id"] = book.book_id
                        request.params["designers_id"] = info?.shejishi
                        request.params["director_employee_id"] = info?.shejizongjian
                        request.params["customer_state"] = info?.state
                        request.params["start_time"] = info?.date
                        request.params["room_id"] = room.room_id
                        request.execute()
                        
                        //                    if room.state == "使用中" {
                        //                        print("咨询室使用状态是 \(room.state)")
                        //                    }else {
                        //                        request.execute()
                        //                    }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"HideFenZhen"), object: nil)

                        self?.selectTimeVC.clear()
                    }
                   
                }
            }
        }
        
        self.commonView.didDaodianButtonPressed = {[weak self] (member) in
            self?.selectedMember = member
        }
        
        self.commonView.wanshanxinxiButtonPressed = {[weak self] (member) in
            self?.wanshanxinxi(member)
        }
        
        FetchHQiantaiFenzhenReservationsRequest().execute()
        FetchHQiantaiFenzhenRoomRequest().execute()
        FetchQiantaiZixunRequest().execute()

        self.registerNofitification(forMainThread: kEditZixunRoomResponse)
        self.registerNofitification(forMainThread: kQiantaiBookSignResponse)
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kEditZixunRoomResponse )
        {
            if let result = notification.userInfo?["rc"] as? Int, result == 0
            {
                
            }
            else
            {
                //print(notification.userInfo!["rm"])
                //Optional(房间使用中无法进入)
                //填了时间 就不会有提示
                CBMessageView(title: notification.userInfo?["rm"] as! String).show()
            }
            
            FetchHQiantaiFenzhenReservationsRequest().execute()
            FetchHQiantaiFenzhenRoomRequest().execute()
            FetchQiantaiZixunRequest().execute()

        }
        else if ( notification.name.rawValue == kQiantaiBookSignResponse )
        {
            if let result = notification.userInfo?["rc"] as? Int, result == 0
            {
                let v = UIAlertView(title: "", message: "是否现在完善客户信息", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
                v.show()
            }
            else
            {
                CBMessageView(title: notification.userInfo?["rm"] as! String).show()
            }
            
            FetchHQiantaiFenzhenReservationsRequest().execute()
            FetchHQiantaiFenzhenRoomRequest().execute()
            
            CBLoadingView.share().hide()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            wanshanxinxi(self.selectedMember)
        }
    }
    
    func wanshanxinxi(_ member : CDMember?)
    {
        var viewController : PadMemberCreateViewController!
        if let m = member
        {
            if let name = member?.memberName, name.characters.count > 0
            {
                viewController = PadMemberCreateViewController(member: m)
            }
            else
            {
                CBLoadingView.share().show()
                let request = BSFetchMemberDetailRequest(member: m)
                request?.onlyMemberInfo = true
                request?.finished = { [weak self] dict in
                    CBLoadingView.share().hide()
                    if let name = m.memberName, name.characters.count > 0
                    {
                        self?.wanshanxinxi(m)
                    }
                    else
                    {
                        CBMessageView(title: "获取会员信息失败").show()
                    }
                }
                request?.execute()
                return
            }
        }
        else
        {
            viewController = PadMemberCreateViewController()
        }
        
        let maskView = PadMaskView(frame: self.view.bounds)
        self.view.addSubview(maskView)
        viewController.maskView = maskView
        maskView.navi = CBRotateNavigationController(rootViewController: viewController)
        maskView.navi.isNavigationBarHidden = true
        maskView.navi.view.frame = self.view.bounds
        maskView.addSubview(maskView.navi.view)
        maskView.show();
    }
    
    @IBAction func didCreateBookPressed(_ sender: UIButton)
    {
        let vc = PadBookMainViewController(nibName: "PadBookMainViewController", bundle: nil)
        vc.isCloseButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.commonView.didSearchBarTextChanged(searchBar.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //if segue.destination is QiantaiFenzhenSelectTimeViewController 也可以
        if segue.destination.isKind(of: QiantaiFenzhenSelectTimeViewController.self)
        {
            self.selectTimeVC = segue.destination as! QiantaiFenzhenSelectTimeViewController
        }
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
}
