//
//  QiantaiFenzhenRightRoomView.swift
//  meim
//
//  Created by jimmy on 2017/5/31.
//
//

import UIKit

class QiantaiFenzhenRightRoomView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var collectionView : UICollectionView!
    var roomList : [CDZixunRoom] = []
    var timer : Timer?
    var roomDetailView : UIView?
    var daodianList : [CDZixunBook] = []
    var detailList : [CDZixun] = []
    var selectIndex = -1
    var zixunList : [CDZixun] = []
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.reloadData()
        
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didCellLongPressed(_:)))
//        self.collectionView.addGestureRecognizer(longPressGesture);
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setTimeLabelText), userInfo: nil, repeats: true)
        
        self.registerNofitification(forMainThread: kFetchZixunRoomResponse)
        
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            FetchHQiantaiFenzhenReservationsRequest().execute()
            FetchHQiantaiFenzhenRoomRequest().execute()
            FetchQiantaiZixunRequest().execute()
        })
    }
    
//    func didCellLongPressed(_ gestureRecognizer : UILongPressGestureRecognizer)
//    {
//        
//    }
    
    func setTimeLabelText()
    {
        for cell in self.collectionView.visibleCells as! [QiantaiFenzhenRightRoomCollectionViewCell]
        {
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
        if ( notification.name.rawValue == kFetchZixunRoomResponse )
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
        self.roomList = BSCoreDataManager.current().fetchAllZixunRoom()
        self.daodianList = BSCoreDataManager.current().fetchDaodianZixunBook("")
        self.zixunList = BSCoreDataManager.current().fetchAllZixun(withType: nil, keyword: nil, memberID: nil, zixunID: nil)
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
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.roomList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QiantaiFenzhenRightRoomCollectionViewCell", for: indexPath) as! QiantaiFenzhenRightRoomCollectionViewCell
        cell.room = self.roomList[indexPath.row]
        var count = 0
        for i in self.daodianList
        {
            if i.room_id?.intValue == self.roomList[indexPath.row].room_id?.intValue
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
        self.detailList.removeAll()
        for i in self.zixunList
        {
            if i.state ?? ""  == "done"
            {
                continue
            }
            if i.room_id?.intValue == self.roomList[indexPath.row].room_id?.intValue
            {
                if self.roomList[indexPath.row].member_id?.intValue == i.member_id?.intValue
                {
                    self.detailList.insert(i, at: 0)
                }
                else
                {
                    self.detailList.append(i)
                }
            }
            
        }
        print(self.detailList)
        if detailList.count == 0
        {
            return
        }
        if (self.roomDetailView != nil)
        {
            self.roomDetailView?.removeFromSuperview()
            self.roomDetailView = nil
        }
        self.roomDetailView = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 768))
        self.roomDetailView?.backgroundColor = UIColor.white
        self.roomDetailView?.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.roomDetailView?.layer.shadowRadius = 3;
        self.roomDetailView?.layer.shadowOpacity = 0.1;
        self.roomDetailView?.layer.shadowColor = UIColor.black.cgColor
        
        let closeButton = UIButton(frame: CGRect(x: 260, y: 2.5, width: 70, height: 70))
        closeButton.setImage(UIImage(named: "pad_navi_close_n"), for: .normal)
        closeButton.addTarget(self, action: #selector(QiantaiFenzhenRightRoomView.closeDetail), for: .touchUpInside)
        self.roomDetailView?.addSubview(closeButton)
        
        let titleLabel = UILabel(frame: CGRect(x: 60, y: 2.5, width: 220, height: 70))
        titleLabel.text = self.roomList[indexPath.row].name
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = RGB(r: 37, g: 37, b: 37)
        titleLabel.textAlignment = .center
        self.roomDetailView?.addSubview(titleLabel)
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 72, width: 340, height: 693), style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        self.roomDetailView?.addSubview(tableView)
        self.selectIndex = indexPath.row
        UIApplication.shared.keyWindow?.addSubview(self.roomDetailView!)
    }
    
    public func findRoomItem(_ point : CGPoint) -> CDZixunRoom?
    {
        let p = self.collectionView.convert(point, from: self.superview)
        if let indexPath =  self.collectionView.indexPathForItem(at: p)
        {
            return self.roomList[indexPath.row]
        }
        
        return nil
    }
    
    func closeDetail()
    {
        self.roomDetailView?.removeFromSuperview()
        self.roomDetailView = nil
        self.selectIndex = -1
        self.collectionView.reloadData()
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
        let timeLabel = UILabel(frame: CGRect(x: 210, y: 45, width: 120, height: 14))
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
        let zixunBook:CDZixun = self.detailList[index]
        let selectedRoom = roomList[selectIndex]
        let memberList = BSCoreDataManager.current().fetchMemberCard(withMemberID: zixunBook.member_id)
        if memberList != nil && (memberList?.count ?? 0) > 0
        {
            let card = memberList![0] as! CDMemberCard
            print(card)
            avatarImageView.setImageWithName("\(card.member?.memberID ?? 0)_\(card.member?.memberName ?? "")", tableName: "born.member", filter: card.member?.memberID, fieldName: "image", writeDate: card.member?.lastUpdate, placeholderString:"pad_avatar_default", cacheDictionary: nil)
            nameLabel.text = card.member?.memberName
        }
        else
        {
            avatarImageView.setImageWithName("\(zixunBook.member_id ?? 0)_\(zixunBook.member_name ?? "")", tableName: "born.member", filter: zixunBook.zixun_id, fieldName: "image", writeDate: nil, placeholderString:"pad_avatar_default", cacheDictionary: nil)
            nameLabel.text = zixunBook.member_name
        }
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        designerLabel.text = "\(selectedRoom.designers_name ?? "")"
        directorLabel.text = "\(selectedRoom.director_employee_name ?? "")"
        numberLabel.text = "\(zixunBook.queue_no ?? "")号"
        timeLabel.text = zixunBook.advisory_start_date
        cell.addSubview(avatarImageView)
        cell.addSubview(nameLabel)
        cell.addSubview(designerLabel)
        cell.addSubview(directorLabel)
        cell.addSubview(numberLabel)
        cell.addSubview(timeLabel)
        self.collectionView.reloadData()
        return cell
    }
}
