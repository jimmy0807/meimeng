//
//  WenZhenChufangView.swift
//  meim
//
//  Created by 波恩公司 on 2018/4/26.
//

import UIKit

class WenZhenChufangView: UIView, UITableViewDelegate, UITableViewDataSource, PadProjectDetailViewControllerDelegate
{
    public var chufangType:String!
    public var yaopinArray:NSArray!
    public var wash:CDPosWashHand!
    public var pos:CDPosOperate!
    var currentChangeProduct:CDPosProduct!
    var tableView:UITableView!
    var posList = NSMutableArray()
    func initView()
    {
        self.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        let maskView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        maskView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
        self.addSubview(maskView)

        let centerView = UIView(frame: CGRect(x: 150, y: 0, width: 724, height: 768))
        centerView.backgroundColor = UIColor.white
        let naviView = UIImageView(frame: CGRect(x: 0, y: 0, width: 724, height: 75))
        naviView.image = #imageLiteral(resourceName: "pad_navi_background.png")
        centerView.addSubview(naviView)
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        closeButton.setImage(#imageLiteral(resourceName: "pad_navi_close_n.png"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeView), for: .touchUpInside)
        centerView.addSubview(closeButton)
        let titleLabel = UILabel(frame: CGRect(x: 200, y: 0, width: 324, height: 75))
        titleLabel.text = chufangType
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = RGB(r: 37, g: 37, b: 37)
        titleLabel.textAlignment = .center
        centerView.addSubview(titleLabel)
        let submitButton = UIButton(frame: CGRect(x: 649, y: 0, width: 75, height: 72))
        submitButton.addTarget(self, action: #selector(self.submit), for: .touchUpInside)
        submitButton.setTitle("提交", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = RGB(r: 96, g: 211, b: 212)
        centerView.addSubview(submitButton)
        
        let mainView = UIView(frame: CGRect(x: 0, y: 75, width: 724, height: 693))
        mainView.backgroundColor = RGB(r: 242, g: 245, b: 245)
        let yongyaoLabel = UILabel(frame: CGRect(x: 33, y: 28, width: 158, height: 16))
        yongyaoLabel.text = chufangType
        yongyaoLabel.textColor = RGB(r: 149, g: 171, b: 171)
        yongyaoLabel.font = UIFont.systemFont(ofSize: 16)
        mainView.addSubview(yongyaoLabel)
        let addMubanButton = UIButton(frame: CGRect(x: 625, y: 28, width: 72, height: 16))
        addMubanButton.setTitle("选择模板", for: .normal)
        addMubanButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addMubanButton.setTitleColor(RGB(r: 47, g: 143, b: 255), for: .normal)
        addMubanButton.addTarget(self, action: #selector(self.addMuban), for: .touchUpInside)
        mainView.addSubview(addMubanButton)
        tableView = UITableView(frame: CGRect(x: 32, y: 60, width: 660, height: 633))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        mainView.addSubview(tableView)
        
        centerView.addSubview(mainView)
        self.addSubview(centerView)
        
        self.registerNofitification(forMainThread: "WenzhenChufangSelectFinished")
    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == "WenzhenChufangSelectFinished" )
        {
            if yaopinArray.count == 0
            {
                yaopinArray = NSArray(array: notification.userInfo?["Chufang"] as! NSArray)
                pos = notification.userInfo?["POS"] as! CDPosOperate
                let mutableSet = NSMutableOrderedSet(array: yaopinArray as! [Any])
                let newPos = BSCoreDataManager.current().insertEntity("CDPosOperate") as! CDPosOperate
                newPos.products = mutableSet
                BSCoreDataManager.current().delete(pos)
                BSCoreDataManager.current().save()
                pos = newPos
            }
            else
            {
                let newArray = NSMutableArray()
                for yaopin in yaopinArray
                {
                    newArray.add(yaopin)
                }
                for yao in notification.userInfo?["Chufang"] as! NSArray
                {
                    newArray.add(yao)
                }
                yaopinArray = newArray
                let mutableSet = NSMutableOrderedSet(array: newArray as! [Any])
                let newPos = notification.userInfo?["POS"] as! CDPosOperate
                newPos.products = mutableSet
                BSCoreDataManager.current().delete(pos)
                BSCoreDataManager.current().save()
                pos = newPos
            }
            
            print(yaopinArray)
            tableView.reloadData()
        }
        
    }
    
    func closeView()
    {
        self.removeFromSuperview()
    }
    
    func submit()
    {
        if yaopinArray.count == 0
        {
            return
        }
        let request = WenZhenKaichufangRequest()
        request.params["operate_id"] = wash.operate_id
        let array = NSMutableArray()
        for  product  in yaopinArray
        {
            let item = BSCoreDataManager.current().findEntity("CDProjectItem", withValue: (product as! CDPosProduct).product_id, forKey: "itemID") as! CDProjectItem
            let params = NSMutableDictionary();
            params.setValue((product as! CDPosProduct).product_qty, forKey: "qty")
            params.setValue(item.is_prescription, forKey: "is_prescription")
            params.setValue((product as! CDPosProduct).product_id, forKey: "product_id")
            params.setValue((product as! CDPosProduct).product_price, forKey: "price_unit")
            params.setValue(item.uomID, forKey: "uom_id")
            array.add(params)
        }
        
        let s = array.toJsonString()
        request.params["prescriptions"] = s
        
        if chufangType == "手术用药"
        {
            request.params["type"] = "operate"
        }
        else if chufangType == "院内用药"
        {
            request.params["type"] = "hospital"
        }
        else if chufangType == "回家用药"
        {
            request.params["type"] = "home"
        }
        request.execute()
        BSCoreDataManager.current().delete(pos)
        BSCoreDataManager.current().save()
        self.removeFromSuperview()
    }
    
    func addMuban()
    {
        let returnItemViewController = HPatientRecipeTempletViewController(memberCard: nil, couponCard: nil)
        returnItemViewController?.type = "WenzhenChufangMuban"
        let maskView = PadMaskView(frame: self.bounds)
        self.addSubview(maskView)
        returnItemViewController?.maskView = maskView
        maskView.navi = CBRotateNavigationController(rootViewController: returnItemViewController!)
        maskView.navi.isNavigationBarHidden = true
        maskView.navi.view.frame = CGRect(x: 150, y: 0, width: 724, height: 768)
        maskView.addSubview(maskView.navi.view)
        maskView.show();
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yaopinArray.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "WenzhenChufangCell")
        cell.selectionStyle = .none
        if indexPath.row == 0
        {
            let topLine = UIView(frame: CGRect(x: 0, y: 0, width: 660, height: 1))
            topLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
            cell.addSubview(topLine)
            let addImage = UIImageView(frame: CGRect(x: 20, y: 19, width: 20, height: 20))
            addImage.image = #imageLiteral(resourceName: "pos_add.png")
            cell.addSubview(addImage)
            let addLabel = UILabel(frame: CGRect(x: 52, y: 18, width: 80, height: 22))
            addLabel.text = "添加"
            addLabel.textColor = RGB(r: 155, g: 155, b: 155)
            addLabel.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(addLabel)
        }
        else
        {
            let deleteImage = UIImageView(frame: CGRect(x: 20, y: 19, width: 20, height: 20))
            deleteImage.image = #imageLiteral(resourceName: "pad_delete_n.png")
            cell.addSubview(deleteImage)
            let deleteButton = UIButton(frame: CGRect(x: 20, y: 19, width: 20, height: 20))
            deleteButton.tag = indexPath.row - 1
            deleteButton.addTarget(self, action: #selector(self.deleteYaopin(_:)), for: .touchUpInside)
            let yaopinLabel = UILabel(frame: CGRect(x: 52, y: 18, width: 280, height: 22))
            let prod = yaopinArray[indexPath.row-1] as! CDPosProduct
            print(prod)
            yaopinLabel.text = "\(prod.product_name ?? "")  x\(prod.product_qty ?? 0)"
            yaopinLabel.textColor = RGB(r: 155, g: 155, b: 155)
            yaopinLabel.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(yaopinLabel)
            cell.addSubview(deleteButton)
        }
        let leftLine = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 58))
        leftLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(leftLine)
        let rightLine = UIView(frame: CGRect(x: 659, y: 0, width: 1, height: 58))
        rightLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(rightLine)
        let bottomLine = UIView(frame: CGRect(x: 0, y: 57, width: 660, height: 1))
        bottomLine.backgroundColor = RGB(r: 236, g: 237, b: 237)
        cell.addSubview(bottomLine)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            let returnItemViewController = HPatientRecipeTempletViewController(memberCard: nil, couponCard: nil)
            returnItemViewController?.type = "WenzhenChufang"
            let maskView = PadMaskView(frame: self.bounds)
            self.addSubview(maskView)
            returnItemViewController?.maskView = maskView
            maskView.navi = CBRotateNavigationController(rootViewController: returnItemViewController!)
            maskView.navi.isNavigationBarHidden = true
            maskView.navi.view.frame = CGRect(x: 150, y: 0, width: 724, height: 768)
            maskView.addSubview(maskView.navi.view)
            maskView.show();
        }
        else
        {
            currentChangeProduct = yaopinArray[indexPath.row-1] as! CDPosProduct
            let viewController = PadProjectDetailViewController(posProduct: currentChangeProduct, detailType: kPadProjectDetailCurrentCashier)
            viewController?.isFromProject = false
            viewController?.delegate = self
            viewController?.member = pos.member
            let maskView = PadMaskView(frame: self.bounds)
            self.addSubview(maskView)
            viewController?.maskView = maskView
            maskView.navi = CBRotateNavigationController(rootViewController: viewController!)
            maskView.navi.isNavigationBarHidden = true
            maskView.navi.view.frame = CGRect(x: 150, y: 0, width: 724, height: 768)
            maskView.addSubview(maskView.navi.view)
            maskView.show();
        }
    }
    
    func didPadPosProductConfirm(_ product:CDPosProduct)
    {
        print("\(product)")
        currentChangeProduct = product
        tableView.reloadData()
    }
    
    func didPadPosProductDelete(_ product: CDPosProduct!)
    {
        let newArray = NSMutableArray(array: self.yaopinArray)
        newArray.remove(product)
        self.yaopinArray = NSArray(array: newArray)
        self.tableView.reloadData()
    }
    
    func deleteYaopin(_ button:UIButton)
    {
        let newArray = NSMutableArray(array: self.yaopinArray)
        newArray.removeObject(at: button.tag)
        self.yaopinArray = NSArray(array: newArray)
        self.tableView.reloadData()
    }
}
