//
//  QiantaiFenzhenYuyueView.swift
//  meim
//
//  Created by jimmy on 2017/5/27.
//
//

import UIKit

class QiantaiFenzhenYuyueView: UIView, UITableViewDataSource, UITableViewDelegate 
{
    @IBOutlet weak var tableView : UITableView!
    var snapShotView : UIView?
    var gestureStartPoint : CGPoint!
    var snapShotViewOrinalPoint : CGPoint!
    var gestureBook : CDZixunBook?
    
    public var didItemMoveFinished : ((_ point : CGPoint, _ book : CDZixunBook?) -> Void)?
    public var didDaodianButtonPressed : ((_ member : CDMember?) -> Void)?
    
    var yuyueCountChange : ((_ count : Int)->Void)?
    
    var itemList : [CDZixunBook] = []
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero);
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didCellLongPressed(_:)))
        self.tableView.addGestureRecognizer(longPressGesture);
        
        self.reloadData()
        
        self.registerNofitification(forMainThread: kFetchZixunBookResponse)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            FetchHQiantaiFenzhenReservationsRequest().execute()
            FetchHQiantaiFenzhenRoomRequest().execute()
        })
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
        self.itemList = BSCoreDataManager.current().fetchYuyueZixunBook(searchText)
        //print("self.itemList=\(self.itemList)")
        self.tableView.reloadData()
        
        if let text = searchText, text.characters.count > 0
        {
            return
        }
        
        self.yuyueCountChange?(self.itemList.count)
    }
    
    func didCellLongPressed(_ gestureRecognizer : UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == .began
        {
            let location = gestureRecognizer.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: location)
            self.gestureBook = nil
            if let path = indexPath, let cell = self.tableView.cellForRow(at: path)
            {
                self.gestureBook = self.itemList[path.row]
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
            let location = gestureRecognizer.location(in: self.superview?.superview)
            
            self.didItemMoveFinished?(location, self.gestureBook)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.snapShotView?.alpha = 0
            }, completion: { _ in
                self.snapShotView?.removeFromSuperview()
            })
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.itemList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QiantaiFenzhenYuyueTableViewCell") as! QiantaiFenzhenYuyueTableViewCell
        cell.book = self.itemList[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 72
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let rowAction = UITableViewRowAction(style: .normal, title: "到院") {[weak self] (action, indexPath) in
            if let book = self?.itemList[indexPath.row]
            {
                let request = HQiantaiFenzhenSignInRequest()
                request.params["reservation_id"] = book.book_id
                request.execute()
                
                CBLoadingView.share().show()
                
                let member = BSCoreDataManager.current().uniqueEntity(forName: "CDMember", withValue: book.member_id, forKey: "memberID") as? CDMember
                self?.didDaodianButtonPressed?(member)
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
