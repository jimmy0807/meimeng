//
//  BingfangZhuyuanListView.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/30.
//

import UIKit

class BingfangZhuyuanListView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var zhuyuanListTableView: UITableView!
    var productArray: NSArray = NSArray()
    var zhuyuanListDict : NSDictionary = NSDictionary()
    {
        didSet
        {
            print(zhuyuanListDict)
            productArray = zhuyuanListDict.object(forKey: "product_list") as? NSArray ?? NSArray()
            zhuyuanListTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict = productArray.object(at: section) as! NSDictionary
        let array = dict.object(forKey: "lines") as! NSArray
        return array.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dict = productArray.object(at: section) as! NSDictionary
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 47))
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: 380, height: 16))
        label.text = "单号：\(dict.object(forKey: "name") ?? "")"
        label.textColor = RGB(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(label)
        let timeLabel = UILabel(frame: CGRect(x: 400, y: 21, width: 260, height: 16))
        timeLabel.text = "\(dict.object(forKey: "create_date") ?? "")"
        timeLabel.textAlignment = .right
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = RGB(r: 153, g: 153, b: 153)
        timeLabel.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        view.addSubview(timeLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = productArray.object(at: indexPath.section) as! NSDictionary
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ZhuyuanListTableViewCell\(indexPath.section)\(indexPath.row)")
        //最后一行
        let line = dict.object(forKey: "lines") as? NSArray ?? NSArray()
        if indexPath.row == line.count
        {
            let label = UILabel(frame: CGRect(x: 250, y: 20, width: 50, height: 20))
            label.text = "小计："
            label.textColor = RGB(r: 153, g: 153, b: 153)
            label.font = UIFont.systemFont(ofSize: 16)
            //cell.addSubview(label)
            let amount = UILabel(frame: CGRect(x: 410, y: 20, width: 100, height: 20))
            amount.text = "￥\(dict.object(forKey: "revenue_amount") ?? 0)"
            amount.textColor = RGB(r: 37, g: 37, b: 37)
            amount.font = UIFont.systemFont(ofSize: 18)
            amount.textAlignment = .right
            //cell.addSubview(amount)
            let button = UIButton(frame: CGRect(x: 556, y: 0, width: 104, height: 60))
            button.tag = dict.object(forKey: "operate_id") as? Int ?? 0
            //未支付
            if dict.object(forKey: "is_checkout") as! Bool //?? false
            {
                button.setTitle("已支付", for: .normal)
                button.backgroundColor = RGBA(r: 96, g: 211, b: 212, a: 0.5)
            }
            //已支付
            else
            {
                button.setTitle("待支付", for: .normal)
                button.backgroundColor = RGB(r: 96, g: 211, b: 212)
            }
            cell.addSubview(button)
        }
        else
        {
            let lineDict = line.object(at: indexPath.row) as! NSDictionary
            let name = UILabel(frame: CGRect(x: 20, y: 20, width: 300, height: 20))
            name.text = "\(lineDict.object(forKey: "name") ?? "")"
            name.textColor = RGB(r: 37, g: 37, b: 37)
            name.font = UIFont.systemFont(ofSize: 18)
            cell.addSubview(name)
            let amount = UILabel(frame: CGRect(x: 500, y: 20, width: 140, height: 20))
            //print("\(dict.object(forKey: "price") as? NSNumber)")
            amount.text = "￥\((lineDict.object(forKey: "price") as? NSNumber)?.floatValue ?? 0)"
            amount.textColor = RGB(r: 37, g: 37, b: 37)
            amount.textAlignment = .right
            amount.font = UIFont.systemFont(ofSize: 18)
            //cell.addSubview(amount)
            let line = UIView(frame: CGRect(x: 0, y: 59, width: 659, height: 1))
            line.backgroundColor = RGB(r: 224, g: 224, b: 224)
            cell.addSubview(line)
            
        }
        return cell
        
    }
    
    func goPayment(_ sender:UIButton)
    {
        
    }
}
