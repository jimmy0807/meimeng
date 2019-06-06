//
//  SelectDeviceView.swift
//  meim
//
//  Created by 波恩公司 on 2017/11/21.
//

import Foundation
import WILLDevices

class SelectDeviceView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inkDeviceInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId:String = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell (style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        cell?.textLabel?.text = inkDeviceInfoArr[indexPath.row].name
        cell?.contentView.backgroundColor = UIColor.init(red: 96/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1)
        cell?.textLabel?.textColor = UIColor.white
        cell?.isUserInteractionEnabled = false
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath)
        
    }
    
    var inkDeviceInfoArr = [InkDeviceInfo]()
    
    @IBOutlet weak var inkDeviceTableView: UITableView!
    
    @IBOutlet weak var nextStepBtn: UIButton!
    
    override func awakeFromNib() {

        print(inkDeviceInfoArr.count)
        inkDeviceTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    
}
