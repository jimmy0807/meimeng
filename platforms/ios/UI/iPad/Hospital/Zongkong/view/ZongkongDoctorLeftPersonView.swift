//
//  ZongkongDoctorLeftPersonView.swift
//  meim
//
//  Created by 波恩公司 on 2017/10/9.
//

import UIKit

class ZongkongDoctorLeftPersonView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collectionView : UICollectionView!
    var doctorSelected : ((_ doctor : CDZongkongDoctorPerson) -> Void)?
    var timer : Timer?
    var selectedItemIndex = -1
    
    var doctors: [CDZongkongDoctorPerson] = []
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            let request = FetchZongkongDoctorRequest()
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
        for cell in self.collectionView.visibleCells as! [ZongkongDoctorPersonCollectionViewCell]
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
        self.doctors = BSCoreDataManager.current().fetchAllDoctorPerson()
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
        return self.doctors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZongkongDoctorPersonCollectionViewCell", for: indexPath) as! ZongkongDoctorPersonCollectionViewCell
        
        cell.doctor = self.doctors[indexPath.row]
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
        let doctor = self.doctors[indexPath.row]
        self.doctorSelected?(doctor)
        
        selectedItemIndex = indexPath.row
        collectionView.reloadData()
    }
}

