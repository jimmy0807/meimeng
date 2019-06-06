//
//  ZongkongLiyuanLeftPersonView.swift
//  meim
//
//  Created by jimmy on 2017/6/21.
//
//

import UIKit

class ZongkongLiyuanLeftPersonView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView : UITableView!
    var personSelected : ((_ room : CDZongkongLiyuanPerson) -> Void)?
    
    var persons : [CDZongkongLiyuanPerson] = []
    
    func relaodData()
    {
        self.persons = BSCoreDataManager.current().fetchAllZongkongLiyuanPersons()
        self.tableView.reloadData()
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.persons.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZongKongLiYuanMemberTableViewCell") as! ZongKongLiYuanMemberTableViewCell
        
        cell.person = self.persons[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 73
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.personSelected?(self.persons[indexPath.row])
    }
}
