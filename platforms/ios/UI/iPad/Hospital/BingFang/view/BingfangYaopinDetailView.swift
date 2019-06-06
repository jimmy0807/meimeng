//
//  BingfangYaopinDetailView.swift
//  meim
//
//  Created by 波恩公司 on 2018/5/10.
//

import UIKit

class BingfangYaopinDetailView: UIView, UITableViewDelegate, UITableViewDataSource
{
    var tableView:UITableView!
    var centerView:UIView!
    var titleName:String!
    {
        didSet
        {
            let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 72))
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.text = titleName
            self.centerView.addSubview(titleLabel)
        }
    }
    var yaopinArray:NSArray = NSArray()
    {
        didSet
        {
            self.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
            self.centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
            self.centerView.backgroundColor = UIColor.white
            let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
            naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
            self.centerView.addSubview(naviView)
            
            let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
            closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: UIControlState.normal)
            closeButton.addTarget(self, action:#selector(self.closeMask), for: UIControlEvents.touchUpInside)
            self.centerView.addSubview(closeButton)
            
            let bgView = UIView(frame: CGRect(x: 0, y: 75, width: 724, height: 693))
            bgView.backgroundColor = RGB(r: 242, g: 245, b: 245)
            
            
            tableView = UITableView(frame: CGRect(x: 32, y: 32, width: 660, height: 661))
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = UIColor.clear
            tableView.separatorStyle = .none
            tableView.bounces = false
            tableView.reloadData()
            bgView.addSubview(tableView)
            
            centerView.addSubview(bgView)
            self.addSubview(centerView)
        }
    }
    
    func closeMask()
    {
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yaopinArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ZhuyuanInfoTableViewCell")
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        if indexPath.row == yaopinArray.count - 1
        {
            let bottomLine = UIView(frame: CGRect(x: 0, y: 59, width: 660, height: 1))
            bottomLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
            cell.addSubview(bottomLine)
        }
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: 660, height: 1))
        topLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(topLine)
        let leftLine = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 60))
        leftLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(leftLine)
        let rightLine = UIView(frame: CGRect(x: 659, y: 0, width: 1, height: 1))
        rightLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(rightLine)
        
        print(yaopinArray[indexPath.row])
        let dict = yaopinArray[indexPath.row] as! NSDictionary
        let text = "\(dict.object(forKey:"product_name") as? String ?? "")"
        let leftLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 300, height: 20))
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textColor = RGB(r: 37, g: 37, b: 37)
        leftLabel.text = text + "   \(dict.object(forKey:"qty") as? Int ?? 0)" + "\(dict.object(forKey:"uom_name") as? String ?? "")"
        cell.addSubview(leftLabel)
        let rightLabel = UILabel(frame: CGRect(x: 340, y: 20, width: 300, height: 20))
        rightLabel.font = UIFont.systemFont(ofSize: 16)
        rightLabel.textAlignment = .right
        rightLabel.textColor = RGB(r: 37, g: 37, b: 37)
        rightLabel.text = "\(dict.object(forKey:"note") as? String ?? "")"
        cell.addSubview(rightLabel)
        return cell
    }
}
