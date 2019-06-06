//
//  BingFangRightRoomViewController.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/9.
//

import UIKit

class BingFangRightRoomView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var collectionView : UICollectionView!
    var roomList : [CDBingfangRoom] = []
    var bingfangList : [NSDictionary] = []
    var timer : Timer?
    var roomDetailView : BingFangDetailViewController?
    var daodianList : [CDBingFangBook] = []
    var detailList : [CDBingFangBook] = []
    var selectIndex = -1
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.reloadData()
        
        //        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didCellLongPressed(_:)))
        //        self.collectionView.addGestureRecognizer(longPressGesture);
        
        //self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setTimeLabelText), userInfo: nil, repeats: true)
        
        self.registerNofitification(forMainThread: "BingfangRoomsFetchResponse")

        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            FetchBingfangRoomsRequest().execute()
        })
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BingFangHeader")
        
    }
    
    //    func didCellLongPressed(_ gestureRecognizer : UILongPressGestureRecognizer)
    //    {
    //
    //    }
    
    func getRoomAndBed()
    {
        bingfangList.removeAll()
        for room in roomList
        {
            var isExistRoom = false
            for bingfang in bingfangList
            {
                if "\(bingfang.object(forKey: "ward_name") ?? "")" == room.ward_name
                {
                    isExistRoom = true
                    let array = bingfang.object(forKey: "ward_rooms") as! NSMutableArray
                    array.add(room)
                    break;
                }
            }
            if isExistRoom
            {

            }
            else
            {
                let dict = NSMutableDictionary()
                dict.setValue(room.ward_name, forKey: "ward_name")
                let array = NSMutableArray(object: room)
                dict.setValue(array, forKey: "ward_rooms")
                bingfangList.append(dict)
            }
        }
        print("\(bingfangList)")
    }
    
    func setTimeLabelText()
    {
        var i = 0
        for cell in self.collectionView.visibleCells as! [BingFangRightRoomCollectionViewCell]
        {
            //print(self.roomList[i])
            cell.room = self.roomList[(self.collectionView.indexPath(for: cell)?.row)!]
            i = i+1
            cell.setTimeLabelText()
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?)
    {
        if newSuperview == nil
        {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "BingfangRoomsFetchResponse" )
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                self.reloadData()
                self.collectionView.mj_header.endRefreshing()
            }
        }
    }
    
    func reloadData()
    {
        self.roomList = BSCoreDataManager.current().fetchAllBingfangRoom()
        self.daodianList = BSCoreDataManager.current().fetchDaodianBingfangBook1("")
        self.getRoomAndBed()
        self.detailList.removeAll()
        self.collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 320, height: 140)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(15, 15, 15, 15)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return bingfangList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let bedList = bingfangList[section].object(forKey: "ward_rooms") as! NSArray
        return bedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 300, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            
            //let headView = InkPictureHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: 132, height: 48))
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BingFangHeader", for: indexPath as IndexPath)
//            if downImgDateArr.count == 0 {
//
//            }
//            else {
//                headView.titleLabel.text = downImgDateArr[indexPath.section]
//
//            }
            for view in headView.subviews
            {
                view.removeFromSuperview()
            }
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 20, width: 300, height: 20))
            titleLabel.text = "\(bingfangList[indexPath.section].object(forKey: "ward_name") ?? "")"
            titleLabel.textColor = RGB(r: 112, g: 109, b: 110)
            headView.addSubview(titleLabel)
            reusableView = headView
            
        }
        return reusableView
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BingFangRightRoomCollectionViewCell", for: indexPath) as! BingFangRightRoomCollectionViewCell
        let room = (bingfangList[indexPath.section].object(forKey: "ward_rooms") as! NSArray)[indexPath.row] as? CDBingfangRoom
        cell.room = room
        var count = 0
        for i in self.daodianList
        {
            if i.room_id?.intValue == room?.room_id?.intValue
            {
                count += 1
            }
        }
        cell.memberCount = count
        if self.selectIndex == indexPath.row
        {
            cell.layer.borderColor = RGB(r: 96, g: 211, b: 212).cgColor
            cell.layer.cornerRadius = 6.0
            cell.layer.borderWidth = 1
        }
        else
        {
            cell.layer.borderWidth = 0
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 18
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 6
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
//        self.detailList.removeAll()
//        for i in self.daodianList
//        {
//            if i.room_id?.intValue == self.roomList[indexPath.row].room_id?.intValue
//            {
//                if self.roomList[indexPath.row].member_id?.intValue == i.member_id?.intValue
//                {
//                    self.detailList.insert(i, at: 0)
//                }
//                else
//                {
//                    self.detailList.append(i)
//                }
//            }
//
//        }
//        print(self.detailList)
//        if detailList.count == 0
//        {
//            return
//        }
//        if (self.roomDetailView != nil)
//        {
//            self.roomDetailView?.removeFromSuperview()
//            self.roomDetailView = nil
//        }
//        self.roomDetailView = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 768))
//        self.roomDetailView?.backgroundColor = UIColor.white
//        self.roomDetailView?.layer.shadowOffset = CGSize.init(width: 0, height: 3)
//        self.roomDetailView?.layer.shadowRadius = 3;
//        self.roomDetailView?.layer.shadowOpacity = 0.1;
//        self.roomDetailView?.layer.shadowColor = UIColor.black.cgColor
//
//        let closeButton = UIButton(frame: CGRect(x: 260, y: 2.5, width: 70, height: 70))
//        closeButton.setImage(UIImage(named: "pad_navi_close_n"), for: .normal)
//        closeButton.addTarget(self, action: #selector(QiantaiFenzhenRightRoomView.closeDetail), for: .touchUpInside)
//        self.roomDetailView?.addSubview(closeButton)
//
//        let titleLabel = UILabel(frame: CGRect(x: 60, y: 2.5, width: 220, height: 70))
//        titleLabel.text = self.roomList[indexPath.row].name
//        titleLabel.font = UIFont.systemFont(ofSize: 18)
//        titleLabel.textColor = RGB(r: 37, g: 37, b: 37)
//        titleLabel.textAlignment = .center
//        self.roomDetailView?.addSubview(titleLabel)
//
//        let tableView = UITableView(frame: CGRect(x: 0, y: 72, width: 340, height: 693), style: .grouped)
//        tableView.backgroundColor = UIColor.white
//        tableView.separatorStyle = .none
//        tableView.delegate = self
//        tableView.dataSource = self
//        self.roomDetailView?.addSubview(tableView)
//        self.selectIndex = indexPath.row
//        UIApplication.shared.keyWindow?.addSubview(self.roomDetailView!)
        let room = (bingfangList[indexPath.section].object(forKey: "ward_rooms") as! NSArray)[indexPath.row] as? CDBingfangRoom
        if let member = room?.member_name, member.characters.count > 0
        {
            let detailView = BingFangDetailViewController(nibName: "BingFangDetailViewController", bundle: nil)
            detailView.hospitalized_id = room?.hospitalized_id
            detailView.member_id = room?.member_id
            detailView.operateId = room?.operate_id
            self.viewController().navigationController?.pushViewController(detailView, animated: true)
        }
    }
    
    public func findRoomItem(_ point : CGPoint) -> CDBingfangRoom?
    {
        let p = self.collectionView.convert(point, from: self.superview)
        if let indexPath =  self.collectionView.indexPathForItem(at: p)
        {
            return (bingfangList[indexPath.section].object(forKey: "ward_rooms") as! NSArray)[indexPath.row] as? CDBingfangRoom
        }
        
        return nil
    }
    
    func closeDetail()
    {
//        self.roomDetailView?.removeFromSuperview()
//        self.roomDetailView = nil
//        self.selectIndex = -1
//        self.collectionView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.detailList.count > 1
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else
        {
            return self.detailList.count-1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 32))
        view.backgroundColor = RGB(r: 242, g: 245, b: 245)
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 140, height: 32))
        if section == 0
        {
            titleLabel.text = "咨询顾客"
        }
        else
        {
            titleLabel.text = "其他顾客(\(self.detailList.count-1)人)"
        }
        titleLabel.textColor = RGB(r: 149, g: 171, b: 171)
        view.addSubview(titleLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "DaodianDetailViewCell")
        cell.selectionStyle = .none
        let avatarImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        let nameLabel = UILabel(frame: CGRect(x: 70, y: 20, width: 200, height: 20))
        nameLabel.textColor = RGB(r: 43, g: 45, b: 58)
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        let designerLabel = UILabel(frame: CGRect(x: 70, y: 45, width: 200, height: 14))
        designerLabel.textColor = RGB(r: 153, g: 153, b: 153)
        designerLabel.font = UIFont.systemFont(ofSize: 12)
        let directorLabel = UILabel(frame: CGRect(x: 70, y: 63, width: 200, height: 14))
        directorLabel.textColor = RGB(r: 153, g: 153, b: 153)
        directorLabel.font = UIFont.systemFont(ofSize: 12)
        let numberLabel = UILabel(frame: CGRect(x: 220, y: 20, width: 100, height: 22))
        numberLabel.textColor = RGB(r: 96, g: 211, b: 212)
        numberLabel.font = UIFont.systemFont(ofSize: 16)
        numberLabel.textAlignment = .right
        let timeLabel = UILabel(frame: CGRect(x: 220, y: 45, width: 100, height: 14))
        timeLabel.textColor = RGB(r: 255, g: 72, b: 72)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textAlignment = .right
        
        var index = 0
        if indexPath.section == 0
        {
            index = 0
            if self.detailList.count == 1
            {
                let line = UIView(frame: CGRect(x: 0, y: 109, width: 340, height: 1))
                line.backgroundColor = RGB(r: 234, g: 234, b: 234)
                cell.addSubview(line)
            }
        }
        else
        {
            index = indexPath.row+1
            let line = UIView(frame: CGRect(x: 0, y: 109, width: 340, height: 1))
            line.backgroundColor = RGB(r: 234, g: 234, b: 234)
            cell.addSubview(line)
        }
//        let zixunBook:CDBingFangBook = self.detailList[index]
//        let memberList = BSCoreDataManager.current().fetchMemberCard(withMemberID: zixunBook.member_id)
//        if memberList != nil
//        {
//            let card = memberList![0] as! CDMemberCard
//            print(card)
//            avatarImageView.setImageWithName("\(card.member?.memberID ?? 0)_\(card.member?.memberName ?? "")", tableName: "born.member", filter: card.member?.memberID, fieldName: "image", writeDate: card.member?.lastUpdate, placeholderString:"pad_avatar_big", cacheDictionary: nil)
//            nameLabel.text = card.member?.memberName
//        }
//        designerLabel.text = "设计师：\(zixunBook.designer_name ?? "")"
//        directorLabel.text = "设计总监：\(zixunBook.director_name ?? "")"
//        numberLabel.text = "\(zixunBook.queue_no_name ?? "")号"
//        timeLabel.text = zixunBook.consume_date
//        cell.addSubview(avatarImageView)
//        cell.addSubview(nameLabel)
//        cell.addSubview(designerLabel)
//        cell.addSubview(directorLabel)
//        cell.addSubview(numberLabel)
//        cell.addSubview(timeLabel)
//        self.collectionView.reloadData()
        return cell
    }
    
    func viewController () -> (UIViewController){
        
        /* 方法1.
         //1.通过响应者链关系，取得此视图的下一个响应者
         var next:UIResponder?
         next = self.nextResponder()!
         while next != nil {
         //2.判断响应者对象是否是视图控制器类型
         if ((next as?UIViewController) != nil) {
         return (next as! UIViewController)
         
         }else {
         next = next?.nextResponder()
         }
         }
         
         return UIViewController()
         */
        
        //1.通过响应者链关系，取得此视图的下一个响应者
        var next:UIResponder?
        next = self.next!
        repeat {
            //2.判断响应者对象是否是视图控制器类型
            if ((next as?UIViewController) != nil) {
                return (next as! UIViewController)
                
            }else {
                next = next?.next
            }
            
        } while next != nil
        
        return UIViewController()
    }
}
