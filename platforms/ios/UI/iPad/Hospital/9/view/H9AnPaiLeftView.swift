//
//  H9AnPaiLeftView.swift
//  meim
//
//  Created by jimmy on 2017/8/2.
//
//

import UIKit

class H9AnPaiLeftView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collectionView : UICollectionView!
    var ssapList : [CDH9SSAP] = []
    
    var startIndex = 0
    var dayLength = 0
    var chineseOneMonth : [String] = []
    var todayInMonthIndex = 0
    var selectIndex : Int = -1
    
    var didSelectItem : ((_ year_month_day : String?) -> Void)?
    var year_month = ""
    
    func reloadData(with date : Date)
    {
        year_month = date.dateTo("yyyy-MM")
        let request = FetchH9SSAPRequest()
        request.year_month = year_month
        request.execute()
        request.finished = {[weak self] dict in
            self?.ssapList = BSCoreDataManager.current().fetchH9SSAP(self?.year_month)
            self?.collectionView.reloadData()
        }
        
        ssapList = BSCoreDataManager.current().fetchH9SSAP(year_month)
        
        startIndex = date.weekDayIndex() ?? 0
        dayLength = date.monthLength()
        chineseOneMonth = date.chineseOneMonthComponents()
        todayInMonthIndex = date.todayInMonth() - 1
        if ( todayInMonthIndex > 0 )
        {
            selectIndex = todayInMonthIndex + startIndex
            self.didSelectItem?(year_month + String.init(format: "-%02d", todayInMonthIndex + 1))
        }
        else
        {
            selectIndex = -1
            self.didSelectItem?(nil)
        }
        
        self.collectionView.reloadData()
    }
    
    func reloadDataToDay(with date : Date)
    {
        year_month = date.dateTo("yyyy-MM")
        let request = FetchH9SSAPRequest()
        request.year_month = year_month
        request.execute()
        request.finished = {[weak self] dict in
            self?.ssapList = BSCoreDataManager.current().fetchH9SSAP(self?.year_month)
            self?.collectionView.reloadData()
        }
        
        ssapList = BSCoreDataManager.current().fetchH9SSAP(year_month)
        
        startIndex = date.weekDayIndex() ?? 0
        dayLength = date.monthLength()
        chineseOneMonth = date.chineseOneMonthComponents()
        let dayInMonthIndex = date.dayInMonth(date: date) - 1
        todayInMonthIndex = date.todayInMonth() - 1
        selectIndex = date.dayInMonth(date: date) - 1 + startIndex
        self.didSelectItem?(year_month + String.init(format: "-%02d", dayInMonthIndex + 1))        
        self.collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 90, height: 90)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 42
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "H9AnPaiCollectionViewCell", for: indexPath) as! H9AnPaiCollectionViewCell
        if ssapList.count > 0 && indexPath.row >= startIndex && indexPath.row - startIndex < dayLength
        {
            let ssap = ssapList[indexPath.row - startIndex]
            cell.bgView.isHidden = false
            cell.dayLabel.text = "\(indexPath.row - startIndex + 1)"
            cell.nongliLabel.text = chineseOneMonth[indexPath.row - startIndex]
            
            if indexPath.row - startIndex == todayInMonthIndex
            {
                cell.dayType = H9AnPaiCollectionViewCell.DayType.today(count: (ssap.count as? Int) ?? 0, isSelected: indexPath.row == selectIndex)
            }
            else if indexPath.row - startIndex < todayInMonthIndex
            {
                cell.dayType = H9AnPaiCollectionViewCell.DayType.last(count: (ssap.count as? Int) ?? 0, isSelected: indexPath.row == selectIndex)
                
            }
            else
            {
                cell.dayType = H9AnPaiCollectionViewCell.DayType.next(count: (ssap.count as? Int) ?? 0, isSelected: indexPath.row == selectIndex)
            }
        }
        else
        {
            cell.bgView.isHidden = true
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectIndex = indexPath.row
        collectionView.reloadData()
        if ssapList.count > 0 && indexPath.row >= startIndex && indexPath.row - startIndex < dayLength
        {
            self.didSelectItem?(year_month + String.init(format: "-%02d", indexPath.row - startIndex + 1))
        }
    }
}
