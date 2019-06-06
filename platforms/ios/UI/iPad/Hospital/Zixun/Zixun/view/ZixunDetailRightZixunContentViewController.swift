//
//  ZixunDetailRightZixunContentViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit
import WILLDevices
import WILLDevicesCore
import WILLInk

///验证拖入的imgurl唯一性
var hadDragImgUrl : Bool = false
var DragImgUrlString : String?
var realTimeFinishUrlString : String?

class ZixunDetailRightZixunContentViewController: ICTableViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    var isConnected = false

    ///保存写字本图片url的数组
    var inkImageUrlArray:[String]! = []
    
    ///传输状态数组
    var inkUploadStatusArray:[Bool]! = []

    ///path数据存储 一次书写的结果
    var currentBezierPathArr = [UIBezierPath]()
    
    var filetotalArr = [[UIBezierPath]]()
    
    @IBOutlet weak var prodButton: UIButton!
    @IBOutlet weak var remarkText: UITextView!
    @IBOutlet weak var prodText: UITextView!
    @IBOutlet weak var suggestionText: UITextView!
    @IBOutlet weak var buyProdView: UIView!

    var buyProdNameArray = [String]()
    var buyProdLine = 0
    var buyProdIdArray = [NSNumber]()
    var buyArray = [NSNumber]()
    var useArray = [NSNumber]()
    ///手写本图片数据view
    @IBOutlet weak var ziXunContentCollectionView: UICollectionView!
    
    //ziXunContentCollectionView的布局
    @IBOutlet weak var ziXunCollectionViewLayout: UICollectionViewFlowLayout!
    
    ///手写本下载相关属性:
    /// Holds the current device details
    struct DeviceDetails {
        var name: String
        var ESN: String
        var width: String
        var height: String
        var point: String
        var battery: String
        var type: String
    }
    
    /// The connected ink device
    weak var inkDevice: InkDevice?
    
    /// The file transfer service provided by the device
    var fileService: FileTranserService?
    
    public var deviceWidth: CGFloat = 100.0
    public var deviceHeight: CGFloat = 100.0
    
    /// The list of downloaded documents from the device
    var downloadedDocuments = [InkDocument]()
    
    /// Background download queue
    let downloadQueue = DispatchQueue(label: "download")
    
    /// Flag to stop spamming when we are polling for files 当我们轮询文件时，标记停止垃圾邮件
    internal var showFinishedPrompt = true
    
    /// Flag to see if we should be polling for new files
    internal var pollForNewFiles = true
    
    /// Should we rotate the recevied files to match orientation 我们是否应该旋转接收的文件以匹配方向
    internal var shouldRotateImages = true
    
    /// Cached list of current device details
    var currentDeviceDetails = DeviceDetails(name: "N/A", ESN: "N/A", width: "N/A", height: "N/A", point: "N/A", battery: "N/A", type: "N/A")
    
    var selectVC : SeletctListViewController?
    var selectIndexSet : NSMutableOrderedSet = NSMutableOrderedSet()
    var zixunID : NSNumber?
    ///zixunListAPI请求结束会走这里
    var zixun : CDZixun?
    {
        didSet
        {
            if let zixun = self.zixun
            {
//                BSFetchMemberRequest(keyword: self.zixun?.member_name).execute()
                if let memberID = self.zixun?.member_id
                {
                    BSFetchMemberDetailRequestN(memberID: self.zixun?.member_id).execute()
                }
                
                self.zixunID = NSNumber(value: (zixun.zixun_id?.intValue ?? 0))
                //print("zixun didSet = \(zixun.image_urls)")
                self.remarkText.text = zixun.condition
                //self.suggestionText.text = zixun.advice
                
                if let ids = zixun.product_ids
                {
                    //let array3 = ids.components(separatedBy: ",")
                    let itemArray = BSCoreDataManager.current().fetchProjectItems(with: kProjectItemDefault, bornCategorys: [kPadBornCategoryProject.rawValue], categoryIds: [], existItemIds: [], keyword: "", priceAscending: true) as! [CDProjectItem]
                    var params : Dictionary<Int,Int> = [:]
                    for (index, item) in itemArray.enumerated()
                    {
                        params[item.itemID as! Int] = index
                    }
                    let array = ids.characters.split(separator: ",").map(String.init)
                    self.selectIndexSet = NSMutableOrderedSet()
                    for id in array
                    {
                        if let index = params[Int(id)!]
                        {
                            self.selectIndexSet.add(index)
                        }
                    }
                    self.prodText.text = self.zixun?.product_names
                    if (self.zixun?.select_product_names ?? "").lengthOfBytes(using: .utf8) > 0
                    {
                        buyProdNameArray.removeAll()
                        buyProdIdArray.removeAll()
                        for view in buyProdView.subviews
                        {
                            view.removeFromSuperview()
                        }
                        let nameArray = self.zixun?.select_product_names?.components(separatedBy: ",")
                        for i in nameArray!
                        {
                            buyProdNameArray.append(i)
                        }
                        let idArray = self.zixun?.select_product_ids?.components(separatedBy: ",")
                        for i in idArray!
                        {
                            buyProdIdArray.append(NSNumber(value: Int(i)!))
                        }
                        var originX:CGFloat = 0
                        var originY:CGFloat = 0
                        buyProdLine = 0
                        let size = CGSize();
                        for i in 0..<buyProdNameArray.count
                        {
                            let buttonWidth = (buyProdNameArray[i]).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading, attributes: nil, context: nil).width / 12 * 16 + 70
                            if (originX + buttonWidth > 560)
                            {
                                originX = 0
                                originY = originY + 40
                                buyProdLine = buyProdLine + 1
                            }
                            let prodLabel = UILabel(frame: CGRect(x: originX, y: originY, width: buttonWidth, height: 30))
                            prodLabel.text = "   \(buyProdNameArray[i])"
                            prodLabel.clipsToBounds = true
                            prodLabel.textColor = RGB(r: 96, g: 211, b: 212)
                            prodLabel.backgroundColor = RGB(r: 241, g: 241, b: 243)
                            prodLabel.layer.cornerRadius = 15
                            
                            self.buyProdView.addSubview(prodLabel)
                            let deleteProdButton = UIButton(frame: CGRect(x: originX+buttonWidth-19-10, y: originY+9-10, width: 32, height: 32))
                            deleteProdButton.setImage(#imageLiteral(resourceName: "pad_emenu_cross_small.png"), for: .normal)
                            deleteProdButton.tag = i
                            deleteProdButton.addTarget(self, action: #selector(self.deleteProd(_:)), for: .touchUpInside)
                            self.buyProdView.addSubview(deleteProdButton)
                            originX = originX + buttonWidth + 10
                        }
                        //                if (i == 0 && self.prodText.text.lengthOfBytes(using: .utf8) > 0)
                        //                {
                        //                    self.prodText.text = self.prodText.text + ","
                        //                }
                        //                if (i != nameArray.count - 1)
                        //                {
                        //                    self.prodText.text = self.prodText.text + "\(nameArray[i])" + ","
                        //                }
                        //                else
                        //                {
                        //                    self.prodText.text = self.prodText.text + "\(nameArray[i])"
                        //                }
                    }
                }
                ///获取绑定到咨询单的写字本图片
                print("inkImageUrlArray处理前=\(zixun.image_urls)")
                if let tmpInkImageUrlArray = zixun.image_urls?.components(separatedBy: ","){
                    print("tmpInkImageUrlArray = \(tmpInkImageUrlArray)")
                    ///如果inkImageUrlArray中有该url 则不用add
                    for imgUrlString in dealImageUrl(imageUrlArray: tmpInkImageUrlArray) {
                        ///防止重复添加
                        if !inkImageUrlArray.contains(imgUrlString) {
                            inkImageUrlArray.append(imgUrlString)
                        }
                        
                    }
                    
                    print("zixun didSet \(inkImageUrlArray.count)")
                    doSomeDeleteTask()
                }
            }
        }
    }
    
    func doSomwDeleteTask(imgUrlArr : [String]) {
        print("doSomwDeleteTask")
        var willDeleteIDsArr = [String]()
        for imgUrl in imgUrlArr {
            if UserDefaults.standard.string(forKey: "imgID-\(imgUrl)") != nil {
                 willDeleteIDsArr.append(UserDefaults.standard.string(forKey: "imgID-\(imgUrl)")!)
            }
            
            inkImageUrlArray = inkImageUrlArray.filter({ (str) -> Bool in
                return imgUrl != str
            })
        }
        
        let request = HZixunUpdate2()
        request.params["advisory_id"] = ziXunIdForAPI
        
        ///此处不能用inkImageUrlArray 因为这里面可能包含写字本下载的图片
//        var paramsInkImageUrlArray = [String]()
        
        ///防止发了不是http开头的图片
//        for url in inkImageUrlArray {
//            if url.hasPrefix("http") {
//                paramsInkImageUrlArray.append(url)
//            }
//        }
        
//        let imageStr = paramsInkImageUrlArray.joined(separator: ",")
//        request.params["image_urls"] = imageStr
        request.params["is_writing_board"] = true
        request.params["del_img_list"] = willDeleteIDsArr.joined(separator: ",")
        
        request.execute()
        print("doSomwDeleteTask\(request.params)")
        
        ziXunContentCollectionView.reloadData()
    }
    
    func reloadFisetRowData(_ isConnected : Bool)
    {
        self.isConnected = isConnected
        self.tableView.reloadData()
    }
    
    //@IBAction func didInProdViewPressed(_ sender : UIButton)
    func didInProdViewPressed()
    {
        let ePadMenu = EPadMenuViewController()
        print(self.zixunID)
        print(self.zixun?.member_id)
        print(BSCoreDataManager.current().fetchMemberCard(withMemberID: self.zixun?.member_id ?? NSNumber(value: 0)))
        if let memberID = self.zixun?.member_id
        {
            ePadMenu.memberCard = BSCoreDataManager.current().fetchMemberCard(withMemberID: self.zixun?.member_id ?? NSNumber(value: 0)).first as! CDMemberCard
        }
        
        let alreadySelectIDArray = NSMutableArray()
        if let idArray = self.zixun?.select_product_ids?.components(separatedBy: ",")
        {
            for id in idArray
            {
                alreadySelectIDArray.add(NSNumber(value: Int(id as! String)!))
            }
        }
        
        ePadMenu.alreadySelectIDArray = alreadySelectIDArray
        ePadMenu.zixunID = self.zixun?.zixun_id

        self.navigationController?.pushViewController(ePadMenu, animated: true)
        
        /*
        self.selectVC = SeletctListViewController(nibName: "SeletctListViewController", bundle: nil)
        self.selectVC?.multiSelect = true
        
        let itemArray = BSCoreDataManager.current().fetchProjectItems(with: kProjectItemDefault, bornCategorys: [kPadBornCategoryProject.rawValue], categoryIds: [], existItemIds: [], keyword: "", priceAscending: true) as! [CDProjectItem]
        
        self.selectVC?.countOfTheList = {
            return itemArray.count
        }
        
        self.selectVC?.nameAtIndex = { index in
            let item = itemArray[index]
            return item.itemName
        }
        
        self.selectVC?.multiSelectFinish = {[weak self] set in
            self?.prodText.text = ""
            self?.selectIndexSet = NSMutableOrderedSet()
            for (i,index) in (set?.array as! [NSInteger]).enumerated()
            {
                let item = itemArray[index]
                self?.prodText.text = (self?.prodText.text ?? "") + item.itemName!
                if let count = set?.count, i != count - 1
                {
                    self?.prodText.text = (self?.prodText.text!)! + ","
                }
                
                self?.selectIndexSet.add(index)
            }
            
            self?.zixun?.product_ids = ""
            for (i, index) in (self?.selectIndexSet.array as! [Int]).enumerated()
            {
                let item = itemArray[index]
                self?.zixun?.product_ids = (self?.zixun?.product_ids ?? "") + "\(item.itemID ?? 0)"
                if i != (self?.selectIndexSet.array as! [Int]).count - 1
                {
                    self?.zixun?.product_ids = (self?.zixun?.product_ids!)! + ","
                }
            }
            
            self?.zixun?.product_names = self?.prodText.text
            
            let request = HZixunUpdate()
            request.params["advisory_id"] = self?.zixunId
            request.params["product_ids"] = self?.zixun?.product_ids
            request.execute()
        }
        
        self.selectVC?.isSelected = {[weak self] index in
            if let order = self?.selectIndexSet, order.contains(index)
            {
                return true
            }
            
            return false
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.selectVC!.view)
        self.selectVC?.showWithAnimation();
    */
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if textView === self.remarkText
        {
            self.zixun?.condition = self.remarkText.text
        }
        else if textView === self.suggestionText
        {
            self.zixun?.advice = self.suggestionText.text
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        return super.tableView(tableView,numberOfRowsInSection:section)
    }
    
    //MARK: - tableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && !self.isConnected
        {
            if inkImageUrlArray.count == 0
            {
                return 0
            }
        }
        else if indexPath.row == 1 && buyProdLine > 2
        {
            return super.tableView(tableView, heightForRowAt: indexPath) + (CGFloat)(40 * (buyProdLine - 2))
        }
        else if indexPath.row == 2
        {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if (indexPath.row == 1)
        {
            didInProdViewPressed()
        }
    }
    
    /// 一张图片的格式 @后面是判断是否是写字本图片
    /// id@http://devimg.we-erp.com/a3ab90888b52ecff47f64bc5a9b4e1c3@t
    func dealImageUrl(imageUrlArray:[String]) -> [String] {
        var tmpImageUrlArray = [String]()
        ///处理图片url
        for pictureUrl in imageUrlArray {
            let substringArry = pictureUrl.components(separatedBy: "@")
            
            if substringArry.last == "t" {
                
                tmpImageUrlArray.append(substringArry[1])
                //将img-id存入UserDefault
                UserDefaults.standard.set(substringArry[0], forKey: "imgID-\(substringArry[1])")
                UserDefaults.standard.synchronize()
                
            }
        }
        
        return tmpImageUrlArray
    }
    
    override func viewDidLoad() {
       
        ziXunContentCollectionView.delegate = self
        ziXunContentCollectionView.dataSource = self
        self.bgTableView.delegate = self
        //水平间隔
        self.ziXunCollectionViewLayout.minimumInteritemSpacing = 5.0
        //垂直行间距
        self.ziXunCollectionViewLayout.minimumLineSpacing = 5.0
        
        //设置单元格宽度和高度
        self.ziXunCollectionViewLayout.itemSize = CGSize(width:124, height:124)
        
        //注册cell
        ziXunContentCollectionView.register(UINib.init(nibName: "ZixunPictureCell", bundle: nil), forCellWithReuseIdentifier: "pictureCell")
        ziXunContentCollectionView.register(UINib.init(nibName: "ZixunPictureDefaultCell", bundle: nil), forCellWithReuseIdentifier: "ZixunPictureDefaultCell")
        //ZixunSelectedCell
        ziXunContentCollectionView.register(UINib.init(nibName: "ZixunSelectedCell", bundle: nil), forCellWithReuseIdentifier: "ZixunSelectedCell")
        
        //注册通知 监听是否cell被选择
        let inkDeviceCellDidSelected = Notification.Name.init(rawValue: "InkDeviceCellDidSelected")
        self.registerNofitification(forMainThread: inkDeviceCellDidSelected.rawValue)
        self.registerNofitification(forMainThread: "EPadSelectFinished")

        let moveOffLineImgItemFinished = Notification.Name.init(rawValue: "moveOffLineImgItemFinished")
        self.registerNofitification(forMainThread: moveOffLineImgItemFinished.rawValue)
        
        let RealTimeButtonDidPressedNoti = Notification.Name.init(rawValue: "RealTimeButtonDidPressedNoti")
        self.registerNofitification(forMainThread: RealTimeButtonDidPressedNoti.rawValue)
        
        let deleteImgFinished = Notification.Name.init(rawValue: "deleteImgFinished")
        self.registerNofitification(forMainThread: deleteImgFinished.rawValue)
        
        self.registerNofitification(forMainThread: kHZixunStartResponse)
        
        //kHGetInkImgIdResponse
        self.registerNofitification(forMainThread: kHGetInkImgIdResponse)
        
        ///监听键盘的升降
        self.registerNofitification(forMainThread: NSNotification.Name.UIKeyboardWillShow.rawValue)
        
        self.registerNofitification(forMainThread: NSNotification.Name.UIKeyboardWillHide.rawValue)
        
        if BSCoreDataManager.current().fetchMemberCard(withMemberID: self.zixun?.member_id ?? NSNumber(value: 0)).first == nil
        {
            let request = BSFetchMemberDetailRequestN(memberID: self.zixun?.member_id ?? NSNumber(value: 0))
            request?.execute()
            BSCoreDataManager.current().save()
        }
    }
    override func viewWillAppear(_ animated: Bool){
       
    }
    override func viewDidAppear(_ animated: Bool){
        print("Detail Right VC viewDidAppear zixunId = \(self.zixun?.zixun_id)")
        if (self.zixun?.zixun_id == nil)
        {
            self.zixun = BSCoreDataManager.current().uniqueEntity(forName: "CDZixun", withValue: self.zixunID, forKey: "zixun_id") as! CDZixun
        }
    }
    override func viewWillDisappear(_ animated: Bool){
        
        print("Detail Right VC viewWillDisappear zixunId = \(self.zixun?.zixun_id)")
        //InkDeviceCellDidSelected
        //deleteImgFinished
        NotificationCenter.default.removeNotification(onMainThread: "InkDeviceCellDidSelected")
        NotificationCenter.default.removeNotification(onMainThread: "deleteImgFinished")
        
        //移出该通知 防止拖动的item重复添加到咨询单
        NotificationCenter.default.removeNotification(onMainThread: "moveOffLineImgItemFinished")
        //移出该通知 防止控制器切换未被释放 接受重复的通知
        NotificationCenter.default.removeNotification(onMainThread: "RealTimeButtonDidPressedNoti")
    }
    
    func doSomeDeleteTask() {
        ///TODO：如果是实时模式写完准备删除但是没删掉的 在这里删掉 待删的imgUrl不要往inkImageUrlArray添加
        if  UserDefaults.standard.object(forKey: "willDeleteButNotHaveImgID") != nil {
            
            let imgUrlArr = UserDefaults.standard.object(forKey: "willDeleteButNotHaveImgID") as! [String]
            
            ///删除操作
            doSomwDeleteTask(imgUrlArr: imgUrlArr)
            ///清空willDeleteButNotHaveImgID
            UserDefaults.standard.removeObject(forKey: "willDeleteButNotHaveImgID")
            UserDefaults.standard.synchronize()
            
            for imgUrl in imgUrlArr {
                inkImageUrlArray = inkImageUrlArray.filter({ (str) -> Bool in
                    return imgUrl != str
                })
            }
            
        }
        ///删写完 浏览大图时想删 但是没删掉的图
        if  UserDefaults.standard.object(forKey: "willDeleteButNotHaveImgID2") != nil {
            
            let imgUrlArr = UserDefaults.standard.object(forKey: "willDeleteButNotHaveImgID2") as! [String]
            
            ///删除操作
            doSomwDeleteTask(imgUrlArr: imgUrlArr)
            ///清空willDeleteButNotHaveImgID
            UserDefaults.standard.removeObject(forKey: "willDeleteButNotHaveImgID2")
            UserDefaults.standard.synchronize()
            for imgUrl in imgUrlArr {
                inkImageUrlArray = inkImageUrlArray.filter({ (str) -> Bool in
                    return imgUrl != str
                })
            }
        }
        print("willDeleteButNotHaveImgID之后\(inkImageUrlArray)")
        self.ziXunContentCollectionView.reloadData()
    }
    
    ///设置inkPicture下载参数
    func setUpInkDownloadParams() {
        ///设置下载功能的必要参数
        FileTransferManger.shared.inkDevice = BSWILLManager.shared.connectingInkDevice
        FileTransferManger.shared.deviceWidth = 29700
        FileTransferManger.shared.deviceHeight = 21000
        FileTransferManger.shared.hasDevice()
        FileTransferManger.shared.startDownload(tileSize: 490)
    }
    
    ///当连接成功需要下载离线文件时 显示一个阻塞UI的View
    var downLoadingAlertView = UIView()
    
    func joinDownLoadMode() {
        
        self.setUpInkDownloadParams()
        
        FileTransferManger.shared.downloadFinished =  { (isfinished,currentBezierpathArr) -> () in
            ///点链接按钮连接成功之后会走这里
            print("下载完成了吗=\(isfinished,currentBezierpathArr)")
            
            if isfinished {
                
                //下载到离线区
                InkFileManager.shared.saveDownLoadOffLineImage(bezierPathArr: currentBezierpathArr)
              
            }
        }
    }
    
    func dealBezierPathArr(bezierPathArr:[UIBezierPath]) {
        
        let cellImg = self.creatCellImage(bezierPathsArr: bezierPathArr)
        
        let v = UploadPicToZimg()
        v.uploadPic(cellImg, finished: { (ret, urlString) in
            print("处理实时模式的图片上传后台ret = \(ret) -- url = \(String(describing: urlString))")
            //写字板图片上传后台ret = true -- url = Optional("http://devimg.we-erp.com/671bf81fea9e6589a2d866a1aebb40df")
            if (ret) {
                self.inkImageUrlArray?.append(urlString!)
                ///保存图片creatDate
                UserDefaults.standard.set(self.dateConvertString(date: Date()), forKey: "imgCreatDate-\(urlString!)")
                UserDefaults.standard.synchronize()
                SDWebImageManager.shared().saveImage(toCache: cellImg, for: URL.init(string: urlString!))
                
                let list = urlString!.split(separator: "/")
                
                let tag = list.last
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
                var filePath = path+"/BezierPath"
                if tag != nil
                {
                    filePath = filePath+"-\(tag!)"
                }
                //归档
                NSKeyedArchiver.archiveRootObject(bezierPathArr, toFile: filePath)
                self.ziXunContentCollectionView.reloadData()
                    
                if realTimeFinishUrlString != urlString! {
                    realTimeFinishUrlString = urlString!
                    print("绑定图片时当前imgArrCount = \(self.inkImageUrlArray.count)")
                    self.bindDragImgToCurrentZiXun(dragImgUrlStr: urlString!)
                }
            }
            else
            {
                let alert = UIAlertController(title: "图片上传失败", message: "", preferredStyle: UIAlertControllerStyle.alert)
                let okaction = UIAlertAction(title: "好的", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)
            }
        })

    }
    
    func dateConvertString(date:Date) -> String {
        
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年MM月dd日"
        
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
    func creatCellImage(bezierPathsArr : [UIBezierPath]) -> UIImage {
        
        ///绘制手写本内容: 因为这里下载的是大图尺寸 所以先画到一个UIImageView上 再缩放成小图添加到cell上
        let bigImageView:UIImageView = UIImageView.init(frame: CGRect.init(x: 270, y: 80, width: 490, height: 693))
        
        bigImageView.image = UIImage.init(named: "ink_moban2.jpg")
        
        ///把写字板里的笔迹放到UIView上
        if let sublayers = bigImageView.layer.sublayers {
            for l in sublayers {
                if l is CAShapeLayer {
                    l.removeFromSuperlayer()
                }
            }
        }
        //let currentBezierPathsArr = FileTransferManger.shared.filetotalArr[indexPath.row]
        for bezPath in bezierPathsArr {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezPath.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            //shapeLayer.lineWidth = 3
            bigImageView.layer.addSublayer(shapeLayer)
        }
        
        ///UIView转UIImage
        UIGraphicsBeginImageContextWithOptions(bigImageView.bounds.size, false, 0.0 )
        bigImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return img
    }
    
    var zixunId : NSNumber? {
        didSet{
            print("right VC zixunId = \(zixunId)")
        }
    }
    
    var selectCollectionViewStatus : String!
    
    func bindDragImgToCurrentZiXun(dragImgUrlStr: String) {
        print("zhixun-update 参数 advisory_id 0 = \(zixunId)")
        print("zhixun-update 参数 advisory_id = \(self.zixun?.zixun_id)")
        
//        let request = HZixunUpdate2()
//        request.params["advisory_id"] = ziXunIdForAPI
//
//        request.params["image_urls"] = dragImgUrlStr
//        request.params["is_writing_board"] = true
//        request.execute()
//        print("HZixunUpdate参数=\(request.params)")
        
        
        //HGetInkImgIdRequest
        let request = HGetInkImgIdRequest()
        request.params["advisory_id"] = ziXunIdForAPI
        request.params["image_url"] = dragImgUrlStr
        request.params["is_writing_board"] = true
        request.execute()
        print("HGetInkImgIdRequest参数=\(request.params)")
       
    }
    
    func bindImgToCurrentZiXun() {
        
        let request = HZixunUpdate()
        request.params["advisory_id"] = ziXunIdForAPI
        
        ///此处不能用inkImageUrlArray 因为这里面可能包含写字本下载的图片
        var paramsInkImageUrlArray = [String]()
        for url in inkImageUrlArray {
            if url.hasPrefix("http") {
                paramsInkImageUrlArray.append(url)
            }
        }
        let imageStr = paramsInkImageUrlArray.joined(separator: ",")
        request.params["image_urls"] = imageStr
        request.params["is_writing_board"] = true
        request.execute()
        print("HZixunUpdate参数=\(request.params)")
    }
    
    var willDeleteImgIDArr = [String]()
    
    ///UICollectionView代理
    //返回多少个组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("filetotalArr.count=\(filetotalArr.count)")
        ///默认4个cell 点了可进入实时模式
        return (inkImageUrlArray.count == 0) ? 1 : (inkImageUrlArray.count + 1)
 
    }
    
    //返回自定义的cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if inkImageUrlArray.count == 0 {
            ///默认cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZixunPictureDefaultCell", for: indexPath) as! ZixunPictureDefaultCell
            ///如果导航栏选择按钮被点击 隐藏添加cell
            if selectCollectionViewStatus=="选择" {
                cell.isHidden = true
            } else{
                cell.isHidden = false
            }

            return cell
        }
        else {
            
            //手写本图片cell + 一个默认cell
            if indexPath.row < inkImageUrlArray.count {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! ZixunPictureCell
               
                ///边框
                cell.layer.borderColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1).cgColor
                cell.layer.borderWidth = 1;
                
                print("刷新到cell的图片=\(inkImageUrlArray[indexPath.row])")
                cell.smallImageView.sd_setImage(with: URL(string: inkImageUrlArray[indexPath.row] ))
                
                cell.smallImageView.tag = indexPath.row
                
                if inkImageUrlArray[indexPath.row].hasPrefix("http") {
                    
                } else {
                    
                    ///图片未和咨询绑定
                    ///将图片传给后台获取后台生成的url
                    let v = UploadPicToZimg()
                    v.uploadPic(cell.smallImageView.image, finished: { (ret, urlString) in
                        print("写字板图片上传后台ret = \(ret) -- url = \(String(describing: urlString))")
                        //写字板图片上传后台ret = true -- url = Optional("http://devimg.we-erp.com/671bf81fea9e6589a2d866a1aebb40df")
                        if (ret) {
                            
                            let key = self.inkImageUrlArray[indexPath.row]
                         SDWebImageManager.shared().imageCache.removeImage(forKey: key, fromDisk: true)
                            
                            self.inkImageUrlArray[indexPath.row] = urlString!
                            
                            cell.inkImageUrlArray = self.inkImageUrlArray
 
                        }
                        
                    })
                }
                
                cell.inkImageUrlArray = self.inkImageUrlArray
                //cell.select = false
                
                if selectedCellArr.contains(inkImageUrlArray[indexPath.row]) {
                    //print("已选择的cell...")
                    cell.select = true
                } else{
                    cell.select = false
                }

                cell.smallImageView.tintColor = UIColor.orange
                return cell
            }
            else {
                //默认cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZixunPictureDefaultCell", for: indexPath) as! ZixunPictureDefaultCell
                ///如果导航栏选择按钮被点击 隐藏添加cell
                if selectCollectionViewStatus=="选择" {
                    cell.isHidden = true
                }else{
                    cell.isHidden = false
                }
                return cell
            }
     
        }
    
    }
      //item 的尺寸
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 124, height: 124)
        
    }
    //var realTimeVC = RealtimeInkViewController()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        //如果是默认cell 点击了去实时界面
        if cell is ZixunPictureDefaultCell {
            if isInkDeviceConnected
            {
                ///进入实时模式 等待转圈写在实时界面
                let realTimeVC = RealtimeInkViewController()
                self.navigationController?.pushViewController(realTimeVC, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "", message: "请连接设备", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            
            ///如果navi “选择”点击了 那么做选中合并或者移出操作
            if selectCollectionViewStatus=="选择" {
                ///因为存在某个imgUrl对应的本地没有内容 所以选择时判断一下 没有存储内容就给个提示
                let currentImgCellUrl = self.inkImageUrlArray[indexPath.row]

                print("(cell as! ZixunPictureCell).select = \((cell as! ZixunPictureCell).select)")

                ///将cell选中状态置反 这句代码位置不可改 不然影响其他地方的逻辑
                (cell as! ZixunPictureCell).select = !(cell as! ZixunPictureCell).select

                let selectedCellNotiName = Notification.Name.init(rawValue: "selectedCellNotiName")
                
                if (cell as! ZixunPictureCell).select {
                    
                    NotificationCenter.default.post(name: selectedCellNotiName, object: self, userInfo: ["cellImgUrl":currentImgCellUrl,"select":"true"])
                } else{
                    
                    NotificationCenter.default.post(name: selectedCellNotiName, object: self, userInfo: ["cellImgUrl":currentImgCellUrl,"select":"false"])
                }
            
            }
            else{
                //如果是下载的小图 则去大图界面
                
                ///直接打开图片浏览 不考虑笔迹拆分 合并
                ///.....
                //viewTheBigImage(zixunPictureCell: cell as! ZixunPictureCell)
                print("-------------------------------------------------")
                print("浏览 \(self.inkImageUrlArray)中第 \(indexPath.row)张")
                print("浏览地址是=\(self.inkImageUrlArray[indexPath.row])")
                print("-------------------------------------------------")
                let imgBrowserVC = ZixunImgBrowserVC()
                imgBrowserVC.lookImgFrom = "ZixunDetailRightZixunContentViewController"
                imgBrowserVC.iconArray = self.inkImageUrlArray
                imgBrowserVC.index = indexPath.row
                
            
                ///拆分完成点拆分按钮回调
                imgBrowserVC.splitFinished = {(leftArr,rightArr,key) in
                    //1.删除原图
                    for (index,item) in self.inkImageUrlArray.enumerated() {
                        if item == key {
                            self.inkImageUrlArray.remove(at: index)
                        }
                    }
                    
                    //删除UserDefault中的内容
                    BezierPathManager.sharedInstance().removeBezierPathArr(key)
                    self.willDeleteImgIDArr.append("\(key ?? "")")
                    self.doSomwDeleteTask(imgUrlArr: self.willDeleteImgIDArr)
                    //2.添加新图
                    self.dealBezierPathArr(bezierPathArr: leftArr as! [UIBezierPath])
                    
                    //防止url一样
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.dealBezierPathArr(bezierPathArr: rightArr as! [UIBezierPath])
                    }
                    
                    
                }
                self.navigationController?.pushViewController(imgBrowserVC, animated: true)
                
            }
        }
        
    }
    
    ///截取UIImageView
    func snapshot(iv:UIImageView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(iv.bounds.size, true, 0)
        iv.drawHierarchy(in: iv.bounds, afterScreenUpdates: true)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func getNowDateString() -> String {
        //获取当前时间
        let now = NSDate()
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
        //print("当前日期时间：\(dformatter.string(from: now as Date))")
        return dformatter.string(from: now as Date)
        
    }
    
    ///因为图片要传给后台 后台返回来时是白色背景 所以用此方法渲染一下
    func tintedImageWithColor(color: UIColor, originalityImage: UIImage!) -> UIImage {
        //创建图片位置大小
        let imageRect = CGRect(x: 0.0, y: 0.0, width: originalityImage.size.width, height: originalityImage.size.height)
        
        //设置绘制图片上下文
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, originalityImage.scale)
        //得到上下文
        let context = UIGraphicsGetCurrentContext()
        //绘制图片
        originalityImage.draw(in: imageRect)
        //设置渲染颜色
        context!.setFillColor(color.cgColor)

        //UIColor.black.set()
        
        //设置透明度(值可根据需求更改)
        context!.setAlpha(0.8)
        //设置混合模式
        context!.setBlendMode(CGBlendMode.sourceAtop)
        //设置位置大小
        context!.fill(imageRect)
        
        //绘制图片
        let imageRef = context!.makeImage()
        let darkImage = UIImage.init(cgImage: imageRef!, scale: originalityImage.scale, orientation: originalityImage.imageOrientation)
        
        //完成绘制
        UIGraphicsEndImageContext()
        return darkImage
    }
    
    func ziXunUpDateAPI(willDeleteImgIDsArr:[String]) {
        
        let request = HZixunUpdate2()
        request.params["advisory_id"] = ziXunIdForAPI
        
//        ///此处不能用inkImageUrlArray 因为这里面可能包含写字本下载的图片
//        var paramsInkImageUrlArray = [String]()
//
//        ///防止发了不是http开头的图片
//        for url in self.inkImageUrlArray {
//            if url.hasPrefix("http") {
//                paramsInkImageUrlArray.append(url)
//            }
//        }
//
//        let imageStr = paramsInkImageUrlArray.joined(separator: ",")
//        request.params["image_urls"] = imageStr
        
        request.params["is_writing_board"] = true
        request.params["del_img_list"] = willDeleteImgIDsArr.joined(separator: ",")
        //request.params["del_img_list"] = "\("716"),\("718"),\("719"),\("720")"

        print("将要删除的img = \(willDeleteImgIDsArr.joined(separator: ","))")
        request.execute()
        
        willDeleteImgIDArr.removeAll()
    }
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchZixunResponse )
        {
            bgTableView.reloadData()
        }
        else if (notification.name.rawValue == "InkDeviceCellDidSelected") {
            ///写一个方法 传入是否是选择状态 如果是就不要ZixunPictureDefaultCell 如果不是就要ZixunPictureDefaultCell
            ///设置选中状态标志
            selectCollectionViewStatus = (notification.userInfo!["select"] as! String)
            
            self.ziXunContentCollectionView.reloadData()
        }
        else if (notification.name.rawValue == "moveOffLineImgItemFinished") {

            ///防止重复绑定
            if hadDragImgUrl {
                
                hadDragImgUrl = true
                
                return
            }
            ///DragImgUrlString用来保证一张img只绑定了一次 注意移出或者删除时将DragImgUrlString置空
            if DragImgUrlString != (notification.object as! String) {
                DragImgUrlString = notification.object as? String
                ///不要重复绑定之前的 只绑定这次拖动的
                bindDragImgToCurrentZiXun(dragImgUrlStr: notification.object as! String)
                
            }
            inkImageUrlArray.append(notification.object as! String)
            ziXunContentCollectionView.reloadData()
            
            ///检查是否有待删除的图片
            if  UserDefaults.standard.object(forKey: "willDeleteButNotHaveImgID") != nil {
                
                var imgUrlArr = UserDefaults.standard.object(forKey: "willDeleteButNotHaveImgID") as! [String]
                imgUrlArr = imgUrlArr.filter({ (str) -> Bool in
                    return (notification.object as! String) != str
                })
                
                //重置待删数组
                UserDefaults.standard.set(imgUrlArr, forKey: "willDeleteButNotHaveImgID")
                UserDefaults.standard.synchronize()
                
            }
            
        }
        else if (notification.name.rawValue == "RealTimeButtonDidPressedNoti") {
            
            dealBezierPathArr(bezierPathArr: notification.userInfo!["bezierPathArr"] as! [UIBezierPath])
        }
        else if (notification.name.rawValue == "deleteImgFinished") {
            
            /// 此处加个判断是为了防止接受多次通知 重复调用
            if ziXunIdForAPI == self.zixunId {
                
                print("准备删除的imgUrl = \(notification.object as! String)")
                
                let willDeleteImgUrl = notification.object as! String
                //let willDeleteIndex = notification.object as! String
                
                let imgID = UserDefaults.standard.string(forKey: "imgID-\(willDeleteImgUrl)")
                
                if imgID != nil {
                    willDeleteImgIDArr.append("\(imgID!)")
                    ziXunUpDateAPI(willDeleteImgIDsArr: willDeleteImgIDArr)
                }
                else {
                    ///准备删除但是没有imgID的图片 先保存到UserDefault 等待下次进入该咨询单时删除
                    willDeleteButNotHaveImgID.append(willDeleteImgUrl)
                    
                }
                self.inkImageUrlArray = self.inkImageUrlArray.filter({ (str) -> Bool in
                    return willDeleteImgUrl != str
                })
                
                self.ziXunContentCollectionView.reloadData()
                
                UserDefaults.standard.set(willDeleteButNotHaveImgID, forKey: "willDeleteButNotHaveImgID2")
                UserDefaults.standard.synchronize()
            }
            
            
        }
        else if ( notification.name.rawValue == kHGetInkImgIdResponse )
        {
            if notification.userInfo!["image_url"] != nil {
                let getImgIDUrl = notification.userInfo!["image_url"]!
                //imgID-
                UserDefaults.standard.set(notification.userInfo!["data"], forKey: "imgID-\(getImgIDUrl)")
                UserDefaults.standard.synchronize()
            }
      
        }
        else if (notification.name.rawValue == NSNotification.Name.UIKeyboardWillShow.rawValue) {
            
            if !self.isConnected
            {
                if inkImageUrlArray.count == 0
                {
                    return
                }
            }
            
            let userInfo = (notification as NSNotification).userInfo!
            //键盘尺寸
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]
                as! NSValue).cgRectValue
            print("keyboardSize = \(keyboardSize)")//keyboardSize = (0.0, 768.0, 1024.0, 398.0)
            UIView.animate(withDuration: 0.4, animations: {
                self.bgTableView.mj_y = -398
            })
           
        }
        else if (notification.name.rawValue == NSNotification.Name.UIKeyboardWillHide.rawValue) {
            UIView.animate(withDuration: 0.4, animations: {
                self.bgTableView.mj_y = 0
            })
            
        }
        else if (notification.name.rawValue == "EPadSelectFinished")
        {
            
            if let zixunID = notification.userInfo?["zixunID"] as? NSNumber
            {
                if zixunID.intValue != self.zixun?.zixun_id?.intValue
                {
                    return;
                }
            }
            
            for subView in buyProdView.subviews
            {
                subView.removeFromSuperview()
            }
            //let historyArray = notification.userInfo?["History"] as! NSArray
            //self.prodText.text = historyArray.componentsJoined(by: ",")
            //self.zixun?.product_names = self.prodText.text
            //let historyIDArray = notification.userInfo?["HistoryID"] as! NSArray
            //self.zixun?.product_ids = historyIDArray.componentsJoined(by: ",")
            let nameArray = notification.userInfo?["Name"] as! NSArray
            let idArray = notification.userInfo?["ID"] as! NSArray
            for i in notification.userInfo?["BuyID"] as! [NSNumber]
            {
                buyArray.append(i)
            }
            for i in notification.userInfo?["UseID"] as! [NSNumber]
            {
                useArray.append(i)
            }
//            buyArray.append(notification.userInfo?["Buy"] as! [NSNumber])
//            useArray.append(notification.userInfo?["Use"] as! [NSNumber])
            for i in 0..<nameArray.count
            {
                buyProdNameArray.append(nameArray[i] as! String)
                buyProdIdArray.append(idArray[i] as! NSNumber)
            }
            self.zixun?.select_product_names = ""
            for name in buyProdNameArray
            {
                if (self.zixun?.select_product_names ?? "").lengthOfBytes(using: .utf8) == 0
                {
                    self.zixun?.select_product_names = name
                }
                else
                {
                    self.zixun?.select_product_names = (self.zixun?.select_product_names ?? "") + "," + name
                }
            }
            self.zixun?.select_product_ids = ""
            for prodId in buyProdIdArray
            {
                if (self.zixun?.select_product_ids ?? "").lengthOfBytes(using: .utf8) == 0
                {
                    self.zixun?.select_product_ids = "\(prodId)"
                }
                else
                {
                    self.zixun?.select_product_ids = "\(self.zixun?.select_product_ids ?? "")" + "," + "\(prodId)"
                }
            }
            updateBuyView()
            
            //self.zixun?.select_product_ids = idArray.componentsJoined(by: ",")
//            print("\(self.zixun?.product_ids)")
//            for i in 0..<idArray.count
//            {
//                if (i == 0 && self.zixun?.product_ids?.lengthOfBytes(using: .utf8) ?? 0 > 0)
//                {
//                    self.zixun?.product_ids = (self.zixun?.product_ids ?? "") + ","
//                }
//                if (i != idArray.count - 1)
//                {
//                    self.zixun?.product_ids = (self.zixun?.product_ids ?? "") + "\(idArray[i])" + ","
//                }
//                else
//                {
//                    self.zixun?.product_ids = (self.zixun?.product_ids ?? "") + "\(idArray[i])"
//                }
//                print("\(self.zixun?.product_ids)")
//            }
            //self.zixun?.product_ids =
            let request = HZixunUpdate()
            request.params["advisory_id"] = self.zixunId
            //request.params["product_ids"] = self.zixun?.product_ids
            //request.params["product_names"] = self.zixun?.product_names
            request.params["select_product_ids"] = self.zixun?.select_product_ids
            //request.params["select_product_names"] = self.zixun?.select_product_names
            request.execute()
        }
    }
    
    @IBOutlet var bgTableView: UITableView!
    var willDeleteButNotHaveImgID = [String]()
    
    func deleteProd(_ sender : UIButton)
    {
        if (  sender.tag >= buyProdIdArray.count )
        {
            return
        }
        
        let number = buyProdIdArray[sender.tag] as! NSNumber
        if buyArray.contains(number)
        {
            let numIndex = buyArray.index(of: number)!
            buyArray.remove(at: numIndex)
        }
        if useArray.contains(number)
        {
            let numIndex = useArray.index(of: number)!
            useArray.remove(at: numIndex)
        }
        buyProdNameArray.remove(at: sender.tag)
        buyProdIdArray.remove(at: sender.tag)
        self.zixun?.select_product_ids = ""
        for prodId in buyProdIdArray
        {
            if (self.zixun?.select_product_ids ?? "").lengthOfBytes(using: .utf8) == 0
            {
                self.zixun?.select_product_ids = "\(prodId)"
            }
            else
            {
                self.zixun?.select_product_ids = "\(self.zixun?.select_product_ids ?? "")" + "," + "\(prodId)"
            }
        }
        if buyProdIdArray.count == 0
        {
            
        }
        let request = HZixunUpdate()
        request.params["advisory_id"] = self.zixunId
        //request.params["product_ids"] = self.zixun?.product_ids
        //request.params["product_names"] = self.zixun?.product_names
        if buyProdIdArray.count == 0
        {
            request.params["select_product_ids"] = "-1"
        }
        else
        {
            request.params["select_product_ids"] = self.zixun?.select_product_ids
        }
        //request.params["select_product_names"] = self.zixun?.select_product_names
        request.execute()
        updateBuyView()
    }
    
    func updateBuyView()
    {
        var originX:CGFloat = 0
        var originY:CGFloat = 0
        let size = CGSize()
        buyProdLine = 0
        for view in buyProdView.subviews
        {
            view.removeFromSuperview()
        }
        for i in 0..<buyProdNameArray.count
        {
            let buttonWidth = (buyProdNameArray[i]).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading, attributes: nil, context: nil).width / 12 * 16 + 70
            if (originX + buttonWidth > 560)
            {
                originX = 0
                originY = originY + 40
                buyProdLine = buyProdLine + 1
            }
            let prodLabel = UILabel(frame: CGRect(x: originX, y: originY, width: buttonWidth, height: 30))
            prodLabel.text = "   \(buyProdNameArray[i])"
            prodLabel.textColor = RGB(r: 96, g: 211, b: 212)
            prodLabel.clipsToBounds = true
            prodLabel.backgroundColor = RGB(r: 241, g: 241, b: 243)
            prodLabel.layer.cornerRadius = 15
            
            self.buyProdView.addSubview(prodLabel)
            let deleteProdButton = UIButton(frame: CGRect(x: originX+buttonWidth-19-10, y: originY+9-10, width: 32, height: 32))
            deleteProdButton.setImage(#imageLiteral(resourceName: "pad_emenu_cross_small.png"), for: .normal)
            deleteProdButton.tag = i
            deleteProdButton.addTarget(self, action: #selector(self.deleteProd(_:)), for: .touchUpInside)
            self.buyProdView.addSubview(deleteProdButton)
            originX = originX + buttonWidth + 10
            //                if (i == 0 && self.prodText.text.lengthOfBytes(using: .utf8) > 0)
            //                {
            //                    self.prodText.text = self.prodText.text + ","
            //                }
            //                if (i != nameArray.count - 1)
            //                {
            //                    self.prodText.text = self.prodText.text + "\(nameArray[i])" + ","
            //                }
            //                else
            //                {
            //                    self.prodText.text = self.prodText.text + "\(nameArray[i])"
            //                }
        }
        bgTableView.reloadData()
    }
    
    deinit {
        print("")
    }
    
}

extension String {
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        else {
            if len > self.lengthOfBytes(using: String.Encoding.utf8)
            {
                return self
            }
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}

