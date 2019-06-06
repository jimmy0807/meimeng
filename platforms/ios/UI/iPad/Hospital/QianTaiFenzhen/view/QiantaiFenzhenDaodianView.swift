//
//  QiantaiFenzhenDaodianView.swift
//  meim
//
//  Created by jimmy on 2017/5/27.
//
//

import UIKit

class QiantaiFenzhenDaodianView: UIView, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView : UITableView!
    var itemList1 : [CDZixunBook] = []
    var itemList2 : [CDZixunBook] = []
    var daodianCountChange : ((_ count : Int)->Void)?
    public var didItemMoveFinished : ((_ point : CGPoint, _ book : CDZixunBook?) -> Void)?
    public var wanshanxinxiButtonPressed : ((_ member : CDMember?) -> Void)?
    
    var snapShotView : UIView?
    var gestureStartPoint : CGPoint!
    var snapShotViewOrinalPoint : CGPoint!
    var gestureBook : CDZixunBook?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero);
        self.reloadData()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didCellLongPressed(_:)))
        self.tableView.addGestureRecognizer(longPressGesture);
        
        self.registerNofitification(forMainThread: kFetchZixunBookResponse)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            FetchHQiantaiFenzhenReservationsRequest().execute()
            FetchHQiantaiFenzhenRoomRequest().execute()
        })
    }
    
    func didCellLongPressed(_ gestureRecognizer : UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == .began
        {
            let location = gestureRecognizer.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: location)
            self.gestureBook = nil
            if let path = indexPath, path.section == 0, let cell = self.tableView.cellForRow(at: path)
            {
                self.gestureBook = self.itemList1[path.row]
                let snapshot = cell.contentView.snapshot()!
                snapshot.frame = cell.convert(cell.bounds, to: nil)
                snapshot.alpha = 1;
                snapshot.layer.shadowRadius = 8.0;
                snapshot.layer.shadowOpacity = 0.0;
                snapshot.layer.shadowOffset = CGSize.zero;
                snapshot.layer.shadowPath = UIBezierPath(rect: snapshot.layer.bounds).cgPath
                
                self.snapShotView = snapshot
                self.gestureStartPoint = gestureRecognizer.location(in: self.superview)
                self.snapShotViewOrinalPoint = snapshot.frame.origin
                UIApplication.shared.keyWindow?.addSubview(snapshot)
                
                UIView.animate(withDuration: 0.3, animations: {
                    snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                })
            }
        }
        else if gestureRecognizer.state == .changed
        {
            if let snapshot = self.snapShotView
            {
                let location = gestureRecognizer.location(in: self.superview)
                snapshot.frame.origin =  CGPoint(x: self.snapShotViewOrinalPoint.x + location.x - self.gestureStartPoint.x, y: self.snapShotViewOrinalPoint.y + location.y - self.gestureStartPoint.y)
            }
        }
        else if gestureRecognizer.state == .ended
        {
            if let _ = self.snapShotView
            {
                let location = gestureRecognizer.location(in: self.superview?.superview)
                
                self.didItemMoveFinished?(location, self.gestureBook)
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.snapShotView?.alpha = 0
                }, completion: { _ in
                    self.snapShotView?.removeFromSuperview()
                })
            }
        }
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchZixunBookResponse )
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                self.reloadData()
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    func reloadData(_ searchText : String? = nil)
    {
        self.itemList1 = BSCoreDataManager.current().fetchDaodianZixunBook1(searchText)
        self.itemList2 = BSCoreDataManager.current().fetchDaodianZixunBook2(searchText)
        self.tableView.reloadData()
        
        if let text = searchText, text.characters.count > 0
        {
            return
        }
        
        self.daodianCountChange?(self.itemList1.count + self.itemList2.count)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return self.itemList1.count
        }
        else
        {
            return self.itemList2.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QianTaiFenzhenDaodianTableViewCell") as! QianTaiFenzhenDaodianTableViewCell
        if indexPath.section == 0
        {
            let book = self.itemList1[indexPath.row]
            cell.book = book
            //cell.paiduiLabel.text = "排队\(indexPath.row + 1)号"
        }
        else
        {
            let book = self.itemList2[indexPath.row]
            cell.book = book
            //cell.paiduiLabel.text = "排队\(indexPath.row + 1)号"
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 1
        {
            return 23
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 23))
        view.backgroundColor = RGB(r: 232, g: 239, b: 239)
        
        let titleLabel = UILabel(frame: CGRect(x: 19, y: 0, width: 200, height: 23))
        view.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = RGB(r: 132, g: 157, b: 156)
        if ( section == 1 )
        {
            titleLabel.text = "已咨询顾客"
        }
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 95
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let rowAction = UITableViewRowAction(style: .normal, title: "完善\n信息") {[weak self] (action, indexPath) in
            if indexPath.section == 0
            {
                if let book = self?.itemList1[indexPath.row]
                {
                    let member = BSCoreDataManager.current().uniqueEntity(forName: "CDMember", withValue: book.member_id, forKey: "memberID") as? CDMember
                    self?.wanshanxinxiButtonPressed?(member)
                }
            }
            else
            {
                if let book = self?.itemList2[indexPath.row]
                {
                    let member = BSCoreDataManager.current().uniqueEntity(forName: "CDMember", withValue: book.member_id, forKey: "memberID") as? CDMember
                    self?.wanshanxinxiButtonPressed?(member)
                }
            }
            
        }
        rowAction.backgroundColor = RGB(r: 251, g: 198, b: 9)
        
        return [rowAction];
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func didSearchTextChanged(_ searchText : String?)
    {
        self.reloadData(searchText)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
