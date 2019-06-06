//
//  ZixunViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class ZixunViewController: ICCommonViewController
{
    @IBOutlet weak var inRoomView : ZixunInRoomView!
    @IBOutlet weak var todayView : ZixunTodayView!
    @IBOutlet weak var allView : ZixunAllView!
    @IBOutlet weak var tabImage: UIImageView!
    @IBOutlet weak var createView : ZixunCreateView!
    var createTableView : ZixunCreateTableViewController!
    var newzixunid:Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        

        self.inRoomView.didZixunItemPressed = {[weak self] zixun in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "zixunDetail") as! ZixunDetailContainerViewController
            vc.zixun = zixun
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.todayView.didZixunItemPressed = {[weak self] zixun in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "zixunDetail") as! ZixunDetailContainerViewController
            vc.zixun = zixun
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.allView.didZixunItemPressed = {[weak self] zixun in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "zixunDetail") as! ZixunDetailContainerViewController
            vc.zixun = zixun
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.registerNofitification(forMainThread: kEditZixunRoomResponse)
        self.registerNofitification(forMainThread: kAddZixunRoomResponse)
        self.registerNofitification(forMainThread: kFetchZixunResponse)
        FetchQiantaiZixunRequest().execute()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotification(onMainThread: kEditZixunRoomResponse)
        self.removeNotification(onMainThread: kAddZixunRoomResponse)
        self.removeNotification(onMainThread: kFetchZixunResponse)
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kEditZixunRoomResponse )
        {
            
        }
        else if ( notification.name.rawValue == kAddZixunRoomResponse )
        {
            FetchQiantaiZixunRequest().execute()
            newzixunid = (notification.userInfo!["data"] as! Dictionary<String, Any>)["advisory_id"] as! Int
        }
        else if ( notification.name.rawValue == kFetchZixunResponse )
        {
            if (newzixunid != 0) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "zixunDetail") as! ZixunDetailContainerViewController
                let zixunList = BSCoreDataManager.current().fetchAllZixun(withType: nil, keyword: nil, memberID: nil, zixunID: NSNumber(value: newzixunid))
                for newZixun in zixunList
                {
                    if (newZixun.zixun_id?.intValue == newzixunid)
                    {
                        vc.zixun = newZixun
                        newzixunid = 0
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ZixunCreateTableViewController
        {
            self.createTableView = segue.destination as? ZixunCreateTableViewController
        }
    }
    
    @IBAction func didInRoomViewPressed(_ sender : UIButton)
    {
        self.inRoomView.isHidden = false
        self.todayView.isHidden = true
        self.allView.isHidden = true
        self.tabImage.image = #imageLiteral(resourceName: "fenzhen_list_0.png")
    }
    
    @IBAction func didTodayViewPressed(_ sender : UIButton)
    {
        self.inRoomView.isHidden = true
        self.todayView.isHidden = false
        self.allView.isHidden = true
        self.tabImage.image = #imageLiteral(resourceName: "fenzhen_list_1.png")
        FetchQiantaiZixunRequest().execute()
    }
    
    @IBAction func didAllViewPressed(_ sender : UIButton)
    {
        self.inRoomView.isHidden = true
        self.todayView.isHidden = true
        self.allView.isHidden = false
        self.tabImage.image = #imageLiteral(resourceName: "fenzhen_list_2.png")
        FetchQiantaiZixunRequest().execute()
    }
    
    @IBAction func didMenuButtonPressed(_ sender : UIButton)
    {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    @IBAction func close(segue:UIStoryboardSegue)
    {
        for vc in self.childViewControllers {
            
            if vc is ZixunDetailContainerViewController {
               //vc.removeFromParentViewController()
            }
        }
        
    }
    
    @IBAction func didCreateButtonPressed(_ sender : UIButton)
    {
        self.createView.createTableView = createTableView
        self.createView.createTableView.clear()
        self.createView.isHidden = false
    }
}
