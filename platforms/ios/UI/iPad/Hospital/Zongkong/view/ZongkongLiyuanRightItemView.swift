//
//  ZongkongLiyuanRightItemView.swift
//  meim
//
//  Created by jimmy on 2017/6/21.
//
//

import UIKit

class ZongkongLiyuanRightItemView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView : UITableView!
    var personSelected : ((_ room : CDZongkongLiyuanPerson) -> Void)?
    
    var items : [CDZongkongLiyuanItem] = []
    
    var person: CDZongkongLiyuanPerson?
    {
        didSet
        {
            self.items = []
            if let person = self.person, let list = person.item
            {
                self.items = list.array as! [CDZongkongLiyuanItem]
            }
            self.relaodData()
        }
    }
    
    func relaodData()
    {
        self.tableView.reloadData()
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.tableView.estimatedRowHeight = 92
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            if let _ = self.person
            {
                return 1
            }
            else
            {
                return 0
            }
        }
        else
        {
        
            return self.items.count
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ZongKongLiYuanRightMemberTableViewCell") as! ZongKongLiYuanRightMemberTableViewCell
            cell.person = self.person
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ZongKongLiYuanRightInfoTableViewCell") as! ZongKongLiYuanRightInfoTableViewCell
            
            cell.item = self.items[indexPath.row]
            
            return cell
        }
    }
}
