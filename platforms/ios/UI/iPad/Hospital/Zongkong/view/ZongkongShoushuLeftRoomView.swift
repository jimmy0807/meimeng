//
//  ZongkongShoushuLeftRoomView.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit

class ZongkongShoushuLeftRoomView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collectionView : UICollectionView!
    var roomSelected : ((_ room : CDZongkongShoushuRoom) -> Void)?
    var timer : Timer?
    var selectedItemIndex = -1
    
    var rooms: [CDZongkongShoushuRoom] = []
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            let request = FetchZongkongShoushuRoomRequest()
            request.execute()
            request.finished = {[weak self] (params) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
                {
                    self?.relaodData()
                    self?.collectionView.mj_header.endRefreshing()
                }
            }
        })
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setTimeLabelText), userInfo: nil, repeats: true)
    }
    
    func setTimeLabelText()
    {
        for cell in self.collectionView.visibleCells as! [ZongKongShoushuRoomCollectionViewCell]
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
    
    func relaodData()
    {
        self.rooms = BSCoreDataManager.current().fetchAllZongkongRoom()
        self.collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 324, height: 140)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(26, 26, 26, 26)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.rooms.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZongKongShoushuRoomCollectionViewCell", for: indexPath) as! ZongKongShoushuRoomCollectionViewCell

        cell.room = self.rooms[indexPath.row]
        cell.isItemSelected = selectedItemIndex == indexPath.row
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let room = self.rooms[indexPath.row]
        self.roomSelected?(room)
        
        selectedItemIndex = indexPath.row
        collectionView.reloadData()
    }
}
