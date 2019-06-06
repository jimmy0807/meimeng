//
//  ZixunTodayView.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

class ZixunTodayView: UIView , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var emptyIconImageView : UIImageView!
    
    var zixunList : [CDZixun] = []
    var didZixunItemPressed : ((_ item : CDZixun) -> Void)?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        searchBar.backgroundImage = UIImage(named: "pad_background_white_color")?.imageResizable(withCapInsets: UIEdgeInsetsMake(12, 12, 12, 12))
        
        self.registerNofitification(forMainThread: kFetchZixunResponse)
        self.reloadData()
        
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            FetchQiantaiZixunRequest().execute()
        })
    }
    
    func reloadData(_ keyword : String? = nil)
    {
        self.zixunList = BSCoreDataManager.current().fetchAllZixun(withType: "today", keyword: keyword, memberID: nil, zixunID: nil)
        self.collectionView.reloadData()
        self.emptyIconImageView.isHidden = self.zixunList.count > 0
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchZixunResponse )
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                self.reloadData()
                self.collectionView.mj_header.endRefreshing()
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 324, height: 110)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(10, 16, 10, 16)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.zixunList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZixunTodayCollectionViewCell", for: indexPath) as! ZixunTodayCollectionViewCell
        cell.zixun = self.zixunList[indexPath.row]
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.didZixunItemPressed?(self.zixunList[indexPath.row])
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.reloadData(searchBar.text)
    }
}
