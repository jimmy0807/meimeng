//
//  ZixunDetailContainerViewController.swift
//  meim
//
//  Created by jimmy on 2017/6/6.
//
//

import UIKit
import WILLDevices
import CoreBluetooth

 let selectedCellNotiName = "selectedCellNotiName"
 let lookCloundVCImgNotiName = "lookCloundVCImgNotiName"
 let connectDeviceCatchNotiName = "connectDeviceCatchNotiName"
 let setUpFileDataReceiverFaildNotiName = "setUpFileDataReceiverFaildNotiName"
 let inkDeviceHasConnectedNotiName = "inkDeviceHasConnectedNotiName"
 let inkDevicePowerChangeNotiName = "inkDevicePowerChangeNotiName"
//inkDeviceDidReconnectedNotification
 let inkDeviceDidReconnectedNotification = "inkDeviceDidReconnectedNotification"

 let inkDeviceDidReDisConnectedNotification = "inkDeviceDidReDisConnectedNotification"

var isInkDeviceConnected : Bool = false

var selectedCellArr = [String]()

///咨询upDateAPI专用zixunId
var ziXunIdForAPI : NSNumber?

class ZixunDetailContainerViewController: ICCommonViewController,CBCentralManagerDelegate
{
   
    @IBOutlet weak var leftLongInfoView : ZixunLeftLongView!
    @IBOutlet weak var rightContentView : ZixunDetailRightContentView!
    @IBOutlet weak var rightHistoryView : ZixunDetailRightHistoryView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pingCeButton: UIButton!
    @IBOutlet weak var questionView: QuestionMainView!
    
    @IBOutlet weak var startButton: UIButton!
    var startDate = ""
    var timer : Timer?
    
    
    @IBOutlet weak var startButtonBgView: UIView!
    
    var zixunList : [CDZixun] = []
    var zixunId : NSNumber?
    var zixun : CDZixun?
    var zixunRightContentVC : ZixunDetailRightZixunContentViewController?
    
    var zixunQuestionPIds : [Int] = []
    var zixunQuestionPNames : [String] = []
 
    ///当连接成功需要下载离线文件时 显示一个阻塞UI的View
    var downLoadingAlertView = UIView()
    
    var currentInkDevice: InkDevice?
    
    override func willMove(toParentViewController parent: UIViewController?)
    {
        if parent == nil
        {
            let request = HZixunUpdate()
            request.params["advisory_id"] = self.zixun?.zixun_id
            request.params["condition"] = self.zixun?.condition
            request.params["advice"] = self.zixun?.advice
            request.params["designers_id"] = self.zixun?.designer_id
            request.params["director_employee_id"] = self.zixun?.director_id
            print("\(self.zixun?.select_product_ids)")
            if (self.zixun?.select_product_ids ?? "").lengthOfBytes(using: .utf8) > 0
            {
                request.params["select_product_ids"] = self.zixun?.select_product_ids
            }
            else
            {
                request.params["select_product_ids"] = "-1"
            }
            request.execute()
            
            self.timer?.invalidate()
            self.timer = nil
        }
        if self.rightHistoryView != nil
        {
            self.rightHistoryView.remNotification()
        }
    }
    
    func test() {
        if (UserDefaults.standard.string(forKey: "InkDeviceName") != nil) {
            if !PersisitentTool.shared.hasRetConnectedDevice && !UserDefaults.standard.bool(forKey: "hasStepFirstConnected") && !cloundButton.isHidden {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
                pushInkDeviceButtonView = PushInkDeviceButtonView.loadNibNamed("PushInkDeviceButtonView")
                pushInkDeviceButtonView.frame = self.view.bounds
                //self.view.addSubview(pushInkDeviceButtonView)
                let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
                pushInkDeviceButtonView.addGestureRecognizer(singleTap)
                
                checkoutInkDeviceLostTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (t) in
                    if !PersisitentTool.shared.hasRetConnectedDevice {
                        /// 10s未响应 则认为设备被其他pad连去了
                        self.pushInkDeviceButtonView.removeFromSuperview()
                        self.reConnectedView = ReConnectedView.loadNibNamed("ReConnectedView")
                        self.reConnectedView.frame = self.view.bounds
                        self.view.addSubview(self.reConnectedView)
                        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
                        self.reConnectedView.addGestureRecognizer(singleTap)
                        self.reConnectedView.reConnectNowBtn.addTarget(self, action: #selector(self.needToReconnectInkDevice), for: UIControlEvents.touchUpInside)
                    }
                    else {
                        self.pushInkDeviceButtonView.removeFromSuperview()
                    }
                })
            }
            else {
                
            }
        }
    }
    
    var isInkDeviceClosedTimer = Timer()
    
    var powerOffView = PowerOffView()
    
    func checkOutInkDeviceIsPowerOff() {
        
        /**TODO:
         ///数位本关闭了 无法直接知道 那么只能判断一段时间后
         // 没有走no more file 这个方法
         // 也不在reciveFile
         // 并且不在实时模式
         */
        //这个bool值只有在设备已连接 然后关闭设备电源时才会检测到false 如果一开始没连接上 就一直是fasle 所以这个定时器启动的前提是设备连接了
        if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
            print("isInkDeviceClosedTimer.isValid = \(isInkDeviceClosedTimer.isValid)")
            if isInkDeviceClosedTimer.isValid == false {
                
                isInkDeviceClosedTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (t) in
                    print("数位本是否关闭了呢=\(SmartpadManager.sharedInstance.isSmartpadConnected())")
                    
                    if SmartpadManager.sharedInstance.isSmartpadConnected() == false && self.isLongPressed == false{
                        ///看下当前界面是否有连接stepView界面 还有就是要在长按step之后重置该定时器
                        //这个变量是为了重新打开电源时移出powerOffView
                        isInkDeviceConnected = false
                        self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
                        self.zixunRightContentVC?.reloadFisetRowData(false)
                        self.powerOffView = PowerOffView.loadNibNamed("PowerOffView")
                        self.powerOffView.frame = self.view.bounds
                        self.view.addSubview(self.powerOffView)
                        
                        if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
                            ///取UserDefault中的name和时间
                            self.powerOffView.namelabel.text = UserDefaults.standard.string(forKey: "InkDeviceName")
                            let InkDeviceDiscovered = UserDefaults.standard.object(forKey: "InkDeviceDiscovered")
                            
                            self.powerOffView.connectTimeLabel.text = self.dateConvertString(date: InkDeviceDiscovered as! Date)
                        }
                        
                        self.powerOffView.pairBtn.addTarget(self, action: #selector(self.needToReconnectInkDevice), for: UIControlEvents.touchUpInside)
                        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
                        self.powerOffView.addGestureRecognizer(singleTap)
                        self.isInkDeviceClosedTimer.invalidate()
                        
                    }
                })
            }
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //print("ZixunDetailContainerViewController.swift")
        let newZixun = BSCoreDataManager.current().uniqueEntity(forName: "CDZixun", withValue: self.zixun?.zixun_id, forKey: "zixun_id") as! CDZixun
        self.zixunRightContentVC?.zixun = newZixun
        
        self.leftLongInfoView.didContentButtonPressed = {[weak self] in
            if self?.rightContentView != nil
            {
                self?.rightContentView.isHidden = false
            }
            self?.rightHistoryView.isHidden = true
            self?.rightHistoryView.remNotification()
            self?.titleLabel.text = "咨询内容"
        }
        
        self.leftLongInfoView.didHistoryButtonPressed = {[weak self] in
            if self?.rightContentView != nil
            {
                self?.rightContentView.isHidden = true
            }
            self?.rightHistoryView.isHidden = false
            self?.rightHistoryView.regNotification()
            self?.rightHistoryView.zixun = self?.zixun
            self?.titleLabel.text = "历史咨询单"
            //self?.startButtonDidpressed()
            self?.zixunStartView.removeFromSuperview()
        }
        
        self.leftLongInfoView.didAvatarButtonPressed = {[weak self] in
            let memberWebView = PadMemberWebViewController(memberID: self?.zixun?.member_id)
            self?.navigationController?.pushViewController(memberWebView!, animated: true)
        }
        
        self.rightHistoryView.didZixunItemPressed = {[weak self] zixun in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "zixunDetail") as! ZixunDetailContainerViewController
            vc.zixun = zixun
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.leftLongInfoView.zixun = zixun
        
        checkState()
        //self.zixunId = (self.zixun?.zixun_id)!
        self.zixunId = (self.zixun?.zixun_id) ?? 0
        //print("DetailVC viewDidLoad zixunId = \(self.zixun?.zixun_id)")
        ///赋值给zixunRightContentVC 因为请求要用
        self.zixunRightContentVC?.zixunId = self.zixunId
        //print("zixunRightContentVC zixunId = \(self.zixunRightContentVC?.zixunId)")
       
        ziXunIdForAPI = self.zixun?.zixun_id
        
        //let member = BSCoreDataManager.current().uniqueEntity(forName: "CDMember", withValue: self.zixun?.member_id, forKey: "memberID") as? CDMember
        //BSFetchMemberDetailRequest(member: member).execute()
       
         //创建一个中央对象
         self.bluetoothManager = CBCentralManager(delegate: self, queue: nil)
         //peripheralManager = CBPeripheralManager(delegate: self, queue: DispatchQueue.main)
        
        ///TODO : 调试连接
        let alertVC : UIAlertController = UIAlertController.init(title: "\(PersisitentTool.shared.hasRetConnectedDevice)", message: "", preferredStyle: .alert)
        let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in

        }
        alertVC.addAction(comfirmAction)
        //self.present(alertVC, animated: true, completion: nil)
        
//        ///TODO : 调试InkDevice被别人连走了
//        BSWILLManager.shared.startScan()
//        ///是否扫描到设备
//        BSWILLManager.shared.findDeviceHandler = { (arr) -> Void in
//
//            let alertVC : UIAlertController = UIAlertController.init(title: "\(arr.count)", message: "", preferredStyle: .alert)
//            let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
//
//            }
//            alertVC.addAction(comfirmAction)
//            self.present(alertVC, animated: true, completion: nil)
//        }
        if blueToothStatus == "poweredOn"
        {
            checkOutInkDeviceIsPowerOff()
        }
        test()
        self.registerNofitification(forMainThread: "EPadSelectFinished")
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        ///TODO : 通知写在这里不要改
        
        if !cloundButton.isHidden {
            ///再判断设备是否连接
            if isInkDeviceConnected {
                self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
                self.zixunRightContentVC?.reloadFisetRowData(true)
            }
            else {
                self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
                self.zixunRightContentVC?.reloadFisetRowData(false)
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        registerSomeNoti()

        //隐藏合并 移出 删除 3个按钮
        combileButton.isHidden=true
        removeButton.isHidden=true
        deleteButton.isHidden=true
        
        ///如果在UserDefault中存储过写字本信息 就直接隐藏连接按钮
        let InkDeviceName = UserDefaults.standard.string(forKey: "InkDeviceName")
        if InkDeviceName != nil {
            //connectInkDeviceButton.isHidden=true
        }
        else {
            if !cloundButton.isHidden {
                if !PersisitentTool.shared.hasRetConnectedDevice {
                    
                    connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
                }
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //print("CntentVC-viewWillDisappear")
        //print("DetailVC viewWillDisappear zixunId = \(self.zixun?.zixun_id)")
        //必须先关闭 传输模式 再进入实时模式
        //FileTransferManger.shared.stopDownload()
        
        //关闭检查连接默认InkDeivce定时器
        //connectDeviceTimer.invalidate()
        
        //PersisitentTool.shared.hasRetConnectedDevice = false
        
        ///注销尝试连接的通知
        //NotificationCenter.default.removeObserver(self)
        self.removeSomeNoti()
        self.rightContentView = nil
        
    }
    var pushInkDeviceButtonView = PushInkDeviceButtonView()
    var checkoutInkDeviceLostTimer = Timer()
    var reConnectedView = ReConnectedView()
    
    func needToReconnectInkDevice() {
        firstConnected = false
        PersisitentTool.shared.hasRetConnectedDevice = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.reConnectedView.alpha = 0
            self.powerOffView.alpha = 0
        }) { (ret) in
            self.reConnectedView.removeFromSuperview()
            self.powerOffView.removeFromSuperview()
            
            //删除UserDefault中的InkDevice数据 重新走连接步骤
            self.deleteUserDefaultInkDeviceData()
            self.startConnectInkDeviceFirstStep()
        }
   
    }
    
    func deleteUserDefaultInkDeviceData() {
        UserDefaults.standard.removeObject(forKey: "InkDeviceName")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "InkDevicedeviceID")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "InkDeviceDiscovered")
        UserDefaults.standard.synchronize()
    }
    
    func noMoreFileReConnect() {
        print("noMoreFileReConnect")
        PersisitentTool.shared.connect()
    }
    
    func registerSomeNoti() {

        self.registerNofitification(forMainThread: selectedCellNotiName)

        self.registerNofitification(forMainThread: lookCloundVCImgNotiName)

        self.registerNofitification(forMainThread: connectDeviceCatchNotiName)

        self.registerNofitification(forMainThread: setUpFileDataReceiverFaildNotiName)

        self.registerNofitification(forMainThread: inkDeviceHasConnectedNotiName)

        self.registerNofitification(forMainThread: inkDevicePowerChangeNotiName)

        //inkDeviceDidReconnectedNotification
        self.registerNofitification(forMainThread: inkDeviceDidReconnectedNotification)
        
        //点一下重新连接 设备自动断开蓝牙
        self.registerNofitification(forMainThread: inkDeviceDidReDisConnectedNotification)
        
        self.registerNofitification(forMainThread: kFetchZixunResponse)
    }
    
    func removeSomeNoti() {
        self.removeNotification(onMainThread: selectedCellNotiName)
        self.removeNotification(onMainThread: lookCloundVCImgNotiName)
        self.removeNotification(onMainThread: connectDeviceCatchNotiName)
        self.removeNotification(onMainThread: setUpFileDataReceiverFaildNotiName)
        self.removeNotification(onMainThread: inkDeviceHasConnectedNotiName)
        self.removeNotification(onMainThread: inkDevicePowerChangeNotiName)
        self.removeNotification(onMainThread: inkDeviceDidReconnectedNotification)
        self.removeNotification(onMainThread: inkDeviceDidReDisConnectedNotification)
        self.removeNotification(onMainThread: kFetchZixunResponse)
    }
    
    func connectDefaultDeviceTask() {
        //为了一定能连接默认设备 定时3秒监听是否要连接 如果连接上了就不必执行重复任务
        connectDeviceTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            
            if PersisitentTool.shared.hasRetConnectedDevice == false {
                //print("每3s检查一次定时任务.....")
                //self.connectDefaultDevice()
            }
        })
    }
    
    var connectDeviceTimer = Timer();

    ///设置inkPicture下载参数
    func setUpInkDownloadParams() {
        ///监听连接丢失回调
        BSWILLManager.shared.connectingInkDevice?.deviceDisconnected = {() in
            print("deviceDisconnected")
        }
        //print("设置下载功能的必要参数\(BSWILLManager.shared.connectingInkDevice)")
        //Optional(<WILLDevices.SmartPadInkDevice: 0x1c43448e0>)
        ///设置下载功能的必要参数
        FileTransferManger.shared.inkDevice = BSWILLManager.shared.connectingInkDevice
        FileTransferManger.shared.deviceWidth = 29700
        FileTransferManger.shared.deviceHeight = 21000
        FileTransferManger.shared.hasDevice()
        FileTransferManger.shared.startDownload(tileSize: 490)
    }
    
    ///写字本离线时写入的文件数组
    var offLinetotalFileArr = [[UIBezierPath]]()
    var indicator = UIActivityIndicatorView()
    var indicatorBg = UIView()
    
    @IBOutlet weak var naviHeaderView: UIView!
  
    func joinDownLoadMode() {
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.setUpInkDownloadParams()
        
        FileTransferManger.shared.downloadFinished =  { (isfinished,currentBezierpathArr) -> () in
            
            print("下载完成了吗=\(isfinished)")
            
            if isfinished {
                
                //下载到离线区
                InkFileManager.shared.saveDownLoadOffLineImage(bezierPathArr: currentBezierpathArr)
                
            }
            
        }
    
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

        for bezPath in bezierPathsArr {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezPath.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            bigImageView.layer.addSublayer(shapeLayer)
        }
        
        ///UIView转UIImage
        UIGraphicsBeginImageContextWithOptions(bigImageView.bounds.size, false, 0.0 )
        bigImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return img
    }
    
    var persistentInkDeviceInfo = InkDeviceInfo()
    
    ///提示开始咨询按钮view
    func startButtonDidpressed() {
        
        ///开始咨询了 显示云朵按钮
        self.cloundButton.isHidden = false
        
        ///显示开始计时按钮和时间
        self.startButtonBgView.isHidden = false
        
        zixunStartView.removeFromSuperview()
        
        self.selectButton.isHidden = false
        
        self.connectInkDeviceButton.isHidden = false
        
        ///改变左下角开始按钮状态
        resetStartButtonStatus()
        
        if !cloundButton.isHidden {
            
            ///再判断设备是否连接
            if UserDefaults.standard.object(forKey: "InkDeviceName") != nil {
                self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
                self.zixunRightContentVC?.reloadFisetRowData(true)
            }
            else {
                
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
                self.zixunRightContentVC?.reloadFisetRowData(false)
            }
        }
        
    }
    
    func resetStartButtonStatus() {
        if self.zixun?.state == "draft"
        {
            startDate = Date().dateTo("yyyy-MM-dd HH:mm:ss")
            self.zixun?.client_date = startDate
            let request = HZixunStartRequest()
            request.params["advisory_id"] = self.zixun?.zixun_id
            request.params["client_date"] = self.zixun?.client_date
            request.execute()
            request.finished = { [weak self](params) in
                if let result = params?["rc"] as? Int, result == 0
                {
                    self?.zixun?.state = "doing"
                    self?.zixun?.client_date = self?.startDate
                    FetchQiantaiZixunRequest().execute()
                    self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self?.setTimeLabelText), userInfo: nil, repeats: true)
                }
                else
                {
                    CBMessageView(title: params?["rm"] as! String).show()
                }
            }
            
            self.timeLabel.text = "00:00:00";
            
            self.startButton.setTitle("结束", for: .normal)
        }
    }
    
    var zixunStartView = ZixunStartButtonView()
    
    func setUpStartButtonView() {
        if self.rightContentView == nil
        {
            return
        }
        ///隐藏开始计时按钮和时间
        self.startButtonBgView.isHidden = true
        
        ///咨询单未开始 右边显示一个开始咨询引导界面
        zixunStartView = ZixunStartButtonView.loadNibNamed("ZixunStartButtonView")
        zixunStartView.startButton.addTarget(self, action: #selector(startButtonDidpressed), for: UIControlEvents.touchUpInside)
        zixunStartView.frame = self.rightContentView.bounds
        self.rightContentView.addSubview(zixunStartView)
        self.selectButton.isHidden = true
        //self.connectInkDeviceButton.isHidden = true
    }
    
    func checkState()
    {
        if self.zixun?.state == "draft"
        {
            self.startButton.setTitle("开始", for: .normal)
            self.cloundButton.isHidden = true
            setUpStartButtonView()
        }
        else if self.zixun?.state == "done" || self.zixun?.state == "visit"
        {
            self.startButton.setTitle("开单", for: .normal)
            self.timeLabel.text = "咨询完成";
        }
        else if self.zixun?.state == "doing"
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setTimeLabelText), userInfo: nil, repeats: true)
            if (self.zixun?.select_product_ids ?? "").lengthOfBytes(using: .utf8) == 0 || Int(self.zixun?.select_product_ids ?? "0") == 0
            {
                self.startButton.setTitle("咨询完成", for: .normal)
            }
            else
            {
                self.startButton.setTitle("开单", for: .normal)
            }
            self.setTimeLabelText()
        }
    }
    
    @IBAction func didPingCeViewPressed(_ sender : UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectMore") as! ZixunPopupSelectMoreViewController
        vc.zixun = zixun
        let popver = UIPopoverController(contentViewController: vc)
        popver.contentSize = CGSize(width: 313, height: 664)
        popver.backgroundColor = UIColor.white
        popver.present(from: sender.frame.insetBy(dx: 0, dy: 10), in: self.view, permittedArrowDirections: .up, animated: true)
        vc.goMemberVc = {[weak self] in
            popver.dismiss(animated: true)
            self?.goShouyin()
        }

        vc.goQuestionDetail = {[weak self] qID in
            popver.dismiss(animated: true)
            self?.questionView.show(qID)
            self?.questionView.zixun = self?.zixun
            self?.questionView.questionViewFinished = {[weak self] in
                self?.zixunRightContentVC?.zixun = self?.zixun
                if let ids = self?.zixun?.product_ids
                {
                    let request = HZixunUpdate()
                    request.params["advisory_id"] = self?.zixun?.zixun_id
                    request.params["product_ids"] = ids
                    request.execute()
                    
                    self?.zixunQuestionPIds = ids.components(separatedBy: ",").map{
                        if let i = Int($0)
                        {
                            return i
                        }
                        
                        return 0
                    }
                    self?.zixunQuestionPNames = ids.components(separatedBy: ",")
                }
            }
        }

//        let board = UIStoryboard(name: "QuestionBoard", bundle: nil)
//        let vc = board.instantiateInitialViewController()
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didStartPressed(_ sender : UIButton)
    {
        print(self.zixun?.zixun_id)
        if self.zixun?.state == "draft"
        {
            startDate = Date().dateTo("yyyy-MM-dd HH:mm:ss")
            self.zixun?.client_date = startDate
            let request = HZixunStartRequest()
            request.params["advisory_id"] = self.zixun?.zixun_id
            request.params["client_date"] = self.zixun?.client_date
            request.execute()
            request.finished = { [weak self](params) in
                if let result = params?["rc"] as? Int, result == 0
                {
                    self?.zixun?.state = "doing"
                    self?.zixun?.client_date = self?.startDate
                    FetchQiantaiZixunRequest().execute()
                    self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self?.setTimeLabelText), userInfo: nil, repeats: true)
                }
                else
                {
                    CBMessageView(title: params?["rm"] as! String).show()
                }
            }
            
            self.timeLabel.text = "00:00:00";
            
            self.startButton.setTitle("结束", for: .normal)
        }
        else if self.zixun?.state == "done" || self.zixun?.state == "visit"
        {
            //go 收银
            let request = HZixunUpdate()
            request.params["advisory_id"] = self.zixun?.zixun_id
            request.params["condition"] = self.zixun?.condition
            request.params["advice"] = self.zixun?.advice
            request.params["designers_id"] = self.zixun?.designer_id
            request.params["director_employee_id"] = self.zixun?.director_id
            print("\(self.zixun?.select_product_ids)")
            if (self.zixun?.select_product_ids ?? "").lengthOfBytes(using: .utf8) > 0
            {
                request.params["select_product_ids"] = self.zixun?.select_product_ids
            }
            else
            {
                request.params["select_product_ids"] = "-1"
            }
            request.execute()
            goShouyin()
        }
        else if self.zixun?.state == "doing"
        {
//            let request = HZixunEndRequest()
//            request.params["advisory_id"] = self.zixun?.zixun_id
//            request.params["is_pos"] = false
//            request.execute()
//            request.finished = { [weak self](params) in
//                if let result = params?["rc"] as? Int, result == 0
//                {
//                    FetchHQiantaiFenzhenRoomRequest().execute()
//                    self?.timer?.invalidate()
//                    self?.timer = nil
//                    self?.zixun?.state = "visit"
//                    self?.navigationController?.popViewController(animated: true)
//                }
//                else
//                {
//                    CBMessageView(title: params?["rm"] as! String).show()
//                }
//            }
            if (self.zixun?.select_product_ids ?? "").lengthOfBytes(using: .utf8) == 0 || Int(self.zixun?.select_product_ids ?? "0") == 0
            {
                let request = HZixunEndRequest()
                request.params["advisory_id"] = self.zixun?.zixun_id
                request.params["is_pos"] = false
                request.execute()
                request.finished = { [weak self](params) in
                    if let result = params?["rc"] as? Int, result == 0
                    {
                        FetchHQiantaiFenzhenRoomRequest().execute()
                        self?.timer?.invalidate()
                        self?.timer = nil
                        self?.zixun?.state = "visit"
                        self?.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        CBMessageView(title: params?["rm"] as! String).show()
                    }
                }
                
            }
            else
            {
                let request = HZixunEndRequest()
                request.params["advisory_id"] = self.zixun?.zixun_id
                request.params["is_pos"] = true
                request.execute()
                request.finished = { [weak self](params) in
                    if let result = params?["rc"] as? Int, result == 0
                    {
                        FetchHQiantaiFenzhenRoomRequest().execute()
                        self?.timer?.invalidate()
                        self?.timer = nil
                        self?.zixun?.state = "done"
                        self?.goShouyin()
                    }
                    else
                    {
                        CBMessageView(title: params?["rm"] as! String).show()
                    }
                }
            }
            
//            let alert = UIAlertController(title: nil, message: "请选择", preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "咨询完成", style: .default, handler: { (action) in
//                let request = HZixunEndRequest()
//                request.params["advisory_id"] = self.zixun?.zixun_id
//                request.params["is_pos"] = false
//                request.execute()
//                request.finished = { [weak self](params) in
//                    if let result = params?["rc"] as? Int, result == 0
//                    {
//                        FetchHQiantaiFenzhenRoomRequest().execute()
//                        self?.timer?.invalidate()
//                        self?.timer = nil
//                        self?.zixun?.state = "visit"
//                        self?.navigationController?.popViewController(animated: true)
//                    }
//                    else
//                    {
//                        CBMessageView(title: params?["rm"] as! String).show()
//                    }
//                }
//            }))
//            alert.addAction(UIAlertAction(title: "开单", style: .default, handler: { (action) in
//                let request = HZixunEndRequest()
//                request.params["advisory_id"] = self.zixun?.zixun_id
//                request.params["is_pos"] = true
//                request.execute()
//                request.finished = { [weak self](params) in
//                    if let result = params?["rc"] as? Int, result == 0
//                    {
//                        FetchHQiantaiFenzhenRoomRequest().execute()
//                        self?.timer?.invalidate()
//                        self?.timer = nil
//                        self?.zixun?.state = "done"
//                        self?.goShouyin()
//                    }
//                    else
//                    {
//                        CBMessageView(title: params?["rm"] as! String).show()
//                    }
//                }
//
//            }))
//
//            if let popoverController = alert.popoverPresentationController
//            {
//                popoverController.sourceView = sender
//                popoverController.sourceRect = sender.bounds
//                popoverController.permittedArrowDirections = .down
//            }
//
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func goZixunFinish()
    {
        self.timer?.invalidate()
        self.timer = nil
        self.zixun?.state = "done"
    }
    
    func prepareProduct()
    {
        let memberCard =  BSCoreDataManager.current().fetchMemberCard(withMemberID: self.zixun?.member_id ?? NSNumber(value: 0)).first as! CDMemberCard
        let viewController = PadProjectViewController(memberCard: memberCard, handno: nil)//(posOperate: posOperate)
        if (self.zixun?.select_product_ids ?? "").lengthOfBytes(using: .utf8) == 0 || Int(self.zixun?.select_product_ids ?? "0") == 0
        {
            (self.mm_drawerController.centerViewController as! UINavigationController).pushViewController(viewController!, animated: true)
            return
        }
        if let array = self.zixun?.select_product_ids?.components(separatedBy: ",")
        {
            for productId in array
            {
                var hasItemInCardLeft = false
                for cardItem in memberCard.projects!
                {
                    if (cardItem as! CDMemberCardProject).item?.itemID?.intValue == Int(productId) && (cardItem as! CDMemberCardProject).projectCount!.intValue > 0
                    {
                        viewController?.didPadProjectViewItemClick((cardItem as! CDMemberCardProject))
                        hasItemInCardLeft = true
                    }
                }
                if !hasItemInCardLeft
                {
                    let product = BSCoreDataManager.current().findEntity("CDProjectItem", withValue: NSNumber(value: Int(productId)!), forKey: "itemID") as! CDProjectItem
                    viewController?.didPadProjectViewItemClick(product)
                }
                print(productId)
            }
        }
        viewController?.refreshItems()
        (self.mm_drawerController.centerViewController as! UINavigationController).pushViewController(viewController!, animated: true)
    }
    
    func goShouyin()
    {
        prepareProduct()
        return
        let memberCard =  BSCoreDataManager.current().fetchMemberCard(withMemberID: self.zixun?.member_id ?? NSNumber(value: 0)).first as! CDMemberCard
        let posOperate =  BSCoreDataManager.current().insertEntity("CDPosOperate") as! CDPosOperate
        posOperate.memberCard = memberCard
//        zixunRightContentVC?.buyArray
        
        
        let viewController = PadProjectViewController(memberCard: memberCard, handno: nil)//(posOperate: posOperate)
        for buyId in (zixunRightContentVC?.buyArray)!
        {
            let product = BSCoreDataManager.current().findEntity("CDProjectItem", withValue: buyId, forKey: "itemID") as! CDProjectItem
            viewController?.didPadProjectViewItemClick(product)
        }
        for useId in (zixunRightContentVC?.useArray)!
        {
            for cardItem in memberCard.projects!
            {
                if (cardItem as! CDMemberCardProject).item?.itemID == useId
                {
                    viewController?.didPadProjectViewItemClick((cardItem as! CDMemberCardProject))
                }
            }
//            let useItem = BSCoreDataManager.current().findEntity("CDMemberCardProject", withValue: useId, forKey: "productLineID") as! CDMemberCardProject
//            viewController?.didPadProjectViewItemClick(useItem)
        }
        viewController?.refreshItems()
        (self.mm_drawerController.centerViewController as! UINavigationController).pushViewController(viewController!, animated: true)
//        PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:memberCard couponCard:couponCard handno:nil];
//        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:viewController animated:YES];
        
//        let vc = PadMemberAndCardViewController(viewType: kPadMemberAndCardDefault) as PadMemberAndCardViewController
//        vc.rootNaviationVC = self.navigationController
//        vc.keyword = self.zixun?.mobile
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didHouqigenjinPressed(_ sender : UIButton)
    {
        if self.zixun?.state == "done"
        {
            let request = HZixunEndRequest()
            request.params["advisory_id"] = self.zixun?.zixun_id
            request.params["is_pos"] = false
            request.execute()
            request.finished = { [weak self](params) in
                if let result = params?["rc"] as? Int, result == 0
                {
                    self?.timer?.invalidate()
                    self?.timer = nil
                    self?.zixun?.state = "visit"
                    self?.navigationController?.popViewController(animated: true)
                }
                else
                {
                    CBMessageView(title: params?["rm"] as! String).show()
                }
            }
        }
    }
    
    func setTimeLabelText()
    {
        if let start = self.zixun?.client_date?.date(with: "yyyy-MM-dd HH:mm:ss")
        {
            let timeInterval = Date().timeIntervalSince(start)
            let formatDate = Date(timeIntervalSince1970: timeInterval - 8 * 3600)
            let formator = DateFormatter()
            formator.dateFormat = "HH:mm:ss"
            self.timeLabel.text = formator.string(from: formatDate)
        }
        if startDate != ""
        {
            let timeInterval = Date().timeIntervalSince(startDate.date(with: "yyyy-MM-dd HH:mm:ss")!)
            let formatDate = Date(timeIntervalSince1970: timeInterval - 8 * 3600)
            let formator = DateFormatter()
            formator.dateFormat = "HH:mm:ss"
            self.timeLabel.text = formator.string(from: formatDate)
        }
        if (self.zixun?.select_product_ids ?? "").lengthOfBytes(using: .utf8) == 0 || Int(self.zixun?.select_product_ids ?? "0") == 0
        {
            self.startButton.setTitle("咨询完成", for: .normal)
        }
        else
        {
            self.startButton.setTitle("开单", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ZixunDetailRightZixunContentViewController
        {
            self.zixunRightContentVC = segue.destination as? ZixunDetailRightZixunContentViewController
        }
    }
    
    //连接设备按钮
    @IBOutlet weak var connectInkDeviceButton: UIButton!
    
    var openDeviceView = OpenDeviceView()
    var longPressedView = LongPressedView()
    var confirmView = ConfirmView()
    var selectDeviceView = SelectDeviceView()
    var changeNameView = ChangeDeviceNameView()
    var connectFinishedView = PairSuccessView()
    
    func dealBlueToothReStart() {
        connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
        pushInkDeviceButtonView = PushInkDeviceButtonView.loadNibNamed("PushInkDeviceButtonView")
        pushInkDeviceButtonView.frame = self.view.bounds
        //self.view.addSubview(pushInkDeviceButtonView)
        self.powerOffView = PowerOffView.loadNibNamed("PowerOffView")
        self.powerOffView.frame = self.view.bounds
        self.view.addSubview(self.powerOffView)
        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
        pushInkDeviceButtonView.addGestureRecognizer(singleTap)
        checkoutInkDeviceLostTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (t) in
            if !PersisitentTool.shared.hasRetConnectedDevice {
                /// 10s未响应 则认为设备被其他pad连去了
                self.pushInkDeviceButtonView.removeFromSuperview()
                self.reConnectedView = ReConnectedView.loadNibNamed("ReConnectedView")
                self.reConnectedView.frame = self.view.bounds
                self.view.addSubview(self.reConnectedView)
                let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
                self.reConnectedView.addGestureRecognizer(singleTap)
                self.reConnectedView.reConnectNowBtn.addTarget(self, action: #selector(self.needToReconnectInkDevice), for: UIControlEvents.touchUpInside)
            }
            else {
                self.pushInkDeviceButtonView.removeFromSuperview()
            }
        })
    }
    
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        print("外设=\(peripheral.state.rawValue)")
//
//    }
    
    var bluetoothManager = CBCentralManager()
    var blueToothStatus : String?
    
    ///外设管理者CBPeripheralManager
    //var peripheralManager = CBPeripheralManager()
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        central.scanForPeripherals(withServices: nil, options: nil)
        
        print("蓝牙central = \(central)")
        switch central.state {
              
         case CBManagerState.poweredOn:
            if blueToothStatus == "poweredOff" {
                dealBlueToothReStart()
            }
            blueToothStatus = "poweredOn"
            print("蓝牙已打开,请扫描外设")
                 print("hasRetConnectedDevice\(PersisitentTool.shared.hasRetConnectedDevice)")
                 //self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
                 //connectInkDeviceButton.isEnabled = true
            
         case CBManagerState.unauthorized:
                 print("这个应用程序是无权使用蓝牙低功耗")
         case CBManagerState.poweredOff:
                 blueToothStatus = "poweredOff"
                 isInkDeviceConnected = false
                 print("蓝牙目前已关闭")
                 
                 dealBlueToothCloseStatus()
         case CBManagerState.resetting:
                 print("蓝牙resetting")
         default:
                 print("中央管理器没有改变状态")
         }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("蓝牙didConnect")
    }
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("蓝牙willRestoreState")
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("蓝牙didFailToConnect")
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("蓝牙didDisconnectPeripheral")
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("蓝牙didDiscover")
    }
    
    
    func dealBlueToothCloseStatus() {
        
        ///连接按钮断开
        connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
        //connectInkDeviceButton.isEnabled = false
        ///提示用户先去打开系统设置的蓝牙
        let alertVC : UIAlertController = UIAlertController.init(title: "连接数位本需要打开蓝牙,请您确认蓝牙是否打开", message: "", preferredStyle: .alert)
        let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            
        }
        alertVC.addAction(comfirmAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    func showPowerOffView() {
        ///powerOffView
        self.powerOffView = PowerOffView.loadNibNamed("PowerOffView")
        self.powerOffView.frame = self.view.bounds
        self.view.addSubview(self.powerOffView)
        
        if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
            ///取UserDefault中的name和时间
            self.powerOffView.namelabel.text = UserDefaults.standard.string(forKey: "InkDeviceName")
            let InkDeviceDiscovered = UserDefaults.standard.object(forKey: "InkDeviceDiscovered")
            
            self.powerOffView.connectTimeLabel.text = self.dateConvertString(date: InkDeviceDiscovered as! Date)
        }
        
        self.powerOffView.pairBtn.addTarget(self, action: #selector(self.needToReconnectInkDevice), for: UIControlEvents.touchUpInside)
        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
        self.powerOffView.addGestureRecognizer(singleTap)
    }
    
    var firstConnected : Bool = false
    var inkDeviceDetailInfoView = DeviceInfoView()
    @IBAction func connectInkDeviceButtonPressed(_ sender: Any) {
        // !UserDefaults.standard.bool(forKey: "hasStepFirstConnected") ||
        print("------------------")
        print(UserDefaults.standard.bool(forKey: "hasStepFirstConnected"))//
        print(UserDefaults.standard.string(forKey: "InkDeviceName"))
        print(PersisitentTool.shared.hasRetConnectedDevice)
        print("------------------")
        
        if blueToothStatus != "poweredOn"
        {
            let alertVC : UIAlertController = UIAlertController.init(title: "连接手写本需要打开蓝牙,请您确认当前设备蓝牙是否打开？", message: "", preferredStyle: .alert)
            let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                
            }
            alertVC.addAction(comfirmAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        if PersisitentTool.shared.hasRetConnectedDevice {
            inkDeviceDetailInfoView = DeviceInfoView.loadNibNamed("DeviceInfoView")
            self.view.addSubview(inkDeviceDetailInfoView)
            ///如果点了 重新配对删除了旧数据 但是没有存入新数据 注意会报nil错误
            if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
                let InkDeviceName = UserDefaults.standard.string(forKey: "InkDeviceName")
                inkDeviceDetailInfoView.deviceNameLabel.text = InkDeviceName
                let InkDeviceDiscovered = UserDefaults.standard.object(forKey: "InkDeviceDiscovered")
                inkDeviceDetailInfoView.lastConnectLabel.text = dateConvertString(date: InkDeviceDiscovered as! Date)
            }
            
            let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
            inkDeviceDetailInfoView.addGestureRecognizer(singleTap)
            inkDeviceDetailInfoView.reConnectBtn.addTarget(self, action: #selector(chongXinPeiDui), for: UIControlEvents.touchUpInside)
        }
        else {
            
            if UserDefaults.standard.string(forKey: "InkDeviceName") != nil {
                self.showPowerOffView()
                
            }else {
                startConnectInkDeviceFirstStep()
            }
//            if !UserDefaults.standard.bool(forKey: "hasStepFirstConnected") || (UserDefaults.standard.string(forKey: "InkDeviceName") == nil) {
//
//                startConnectInkDeviceFirstStep()
//
//                //self.showPowerOffView()
//            }
        }
        
        
        
       
    }
    
    //重新配对
    func chongXinPeiDui() {
        
        inkDeviceDetailInfoView.removeFromSuperview()
        //删除UserDefault中的InkDevice数据 重新走连接步骤
        self.deleteUserDefaultInkDeviceData()
        firstConnected = false
        PersisitentTool.shared.hasRetConnectedDevice = false
        ///连接按钮变灰
        connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
        self.startConnectInkDeviceFirstStep()
    }
    
    ///因为连接的时候也要长按 重启设备 所以会和手动关闭设备冲突需要用个flag区分一下
    var isLongPressed : Bool = false
    
    func startConnectInkDeviceFirstStep() {
        
        ///判断系统蓝牙是否开启
        //print("blueToothStatus = \(blueToothStatus)")
        
        if blueToothStatus == "poweredOff" {
            let alertVC : UIAlertController = UIAlertController.init(title: "连接手写本需要打开蓝牙,请您确认当前设备蓝牙是否打开？", message: "", preferredStyle: .alert)
            let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                
            }
            alertVC.addAction(comfirmAction)
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            
            if !firstConnected {
                if !PersisitentTool.shared.hasRetConnectedDevice {
                    
                    isLongPressed = true
                    openDeviceView = OpenDeviceView.loadNibNamed("OpenDeviceView")
                    openDeviceView.frame = self.view.frame
                    self.view.addSubview(openDeviceView)
                    
                    openDeviceView.nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
                    
                    let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
                    openDeviceView.addGestureRecognizer(singleTap)
                }
            }
        }
    }
    func handleSingleTap(tap:UITapGestureRecognizer) {
        checkoutInkDeviceLostTimer.invalidate()
        UIView.animate(withDuration: 0.4, animations: {
            tap.view?.alpha = 0
        }, completion: { (ret) in
            tap.view?.removeFromSuperview()
        })
    }
    
    func nextStep() {
        self.openDeviceView.removeFromSuperview()
        ///加载连接中界面
        longPressedView = LongPressedView.loadNibNamed("LongPressedView")
        longPressedView.frame = self.view.frame
        self.view.addSubview(longPressedView)
        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
        longPressedView.addGestureRecognizer(singleTap)
        
        /// 为了避免和长按重启设备冲突 关闭监测设备powerOff的定时器
        isInkDeviceClosedTimer.invalidate()

        BSWILLManager.shared.startScan()
        
        ///是否扫描到设备
        BSWILLManager.shared.findDeviceHandler = { (arr) -> Void in
            
            //print("是否扫描到设备\(arr)")
            //[Device Name: Bamboo Device ID: 6BC601E6-32BB-0654-E14A-042F39E7BAB9 Type: Bamboo Slate or Folio Discovered: 2018-01-09 02:50:16 +0000]
            
            ///显示设备列表页面
            self.selectDeviceView = SelectDeviceView.loadNibNamed("SelectDeviceView")
            self.selectDeviceView.inkDeviceInfoArr = arr
            self.view.addSubview(self.selectDeviceView)
            self.selectDeviceView.nextStepBtn.addTarget(self, action: #selector(self.willConnectToOneInkDevice), for: UIControlEvents.touchUpInside)
//            let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
//            self.selectDeviceView.addGestureRecognizer(singleTap)
        }
    
    }
    
    func willConnectToOneInkDevice() {
        ///改变按钮背景色和字
        self.selectDeviceView.nextStepBtn.backgroundColor = UIColor.gray
        self.selectDeviceView.nextStepBtn.setTitle("等待中", for: UIControlState.normal)
        self.selectDeviceView.nextStepBtn.isEnabled = false
        
        if BSWILLManager.shared.discoveredDevices == nil {
            return
        }
        let deviceInfo : InkDeviceInfo = BSWILLManager.shared.discoveredDevices[0]
        
        BSWILLManager.shared.connectDevice(deviceInfo: deviceInfo, finished: { (ret, message) -> (Void) in
            print("ret = \(ret) and message = \(message)")
            
            if message == "Device connecting" {
                
            }
            else if message == "Tap device button to confirm connection"
            {
                //移除longPressedView, selectDeviceView
                self.longPressedView.removeFromSuperview()
                self.selectDeviceView.removeFromSuperview()
                
                //添加确认按钮界面
                self.confirmView = ConfirmView.loadNibNamed("ConfirmView")
                self.confirmView.frame = self.view.frame
                self.view.addSubview(self.confirmView)
                let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(self.handleSingleTap(tap:)))
                self.confirmView.addGestureRecognizer(singleTap)
            }
            else if message == "Device connected" {
                
                ///已经历连接步骤标志 不想单独依赖PersisitentTool.shared.hasRetConnectedDevice 判断是否连接
                UserDefaults.standard.set(true, forKey: "hasStepFirstConnected")
                UserDefaults.standard.synchronize()
                
                ///第一次连接成功标志 重新配对的时候要置false
                self.firstConnected = true
                
                ///已经连接标志 防止从其他界面切换到当前界面重复连接
                PersisitentTool.shared.hasRetConnectedDevice = true
                
                //移除所有子界面
                self.confirmView.removeFromSuperview()
                
                //输入数为本名字界面 也就是可以改数位本名字
                //ChangeDeviceNameView
                self.changeNameView = ChangeDeviceNameView.loadNibNamed("ChangeDeviceNameView")
                self.view.addSubview(self.changeNameView)
                self.changeNameView.nextButton.addTarget(self, action: #selector(self.changeNameFinished), for: UIControlEvents.touchUpInside)
                self.changeNameView.deviceNameTextField.text = deviceInfo.name
                
                ///在这里进入下载模式 不要在最后一步
                ///点连接按钮连接成功之后可直接进入下载模式 不用延时
                self.joinDownLoadMode()
                self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
                self.zixunRightContentVC?.reloadFisetRowData(true)
                BSWILLManager.shared.connectingInkDevice?.deviceStatusChanged = {(status1,status2) in
                    print("deviceStatusChanged = \(status1.description),\(status2.description)")
                }
                
                
            }
            else if message == "Failed to connect to device. Restarting scan." {
                
                let alertVC : UIAlertController = UIAlertController.init(title: "连接丢失\n请再试一次。", message: "", preferredStyle: .alert)
                
                let comfirmAction = UIAlertAction(title: "请再试一次", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                    self.selectDeviceView.removeFromSuperview()
                    ///再次回到长按界面
                    self.view.addSubview(self.longPressedView)
                }
                
                alertVC.addAction(comfirmAction)
                
                self.present(alertVC, animated: true, completion: nil)
                
            }
            
        })
    }
    
    func changeNameFinished() {
        ///修改数为本名字
        if changeNameView.deviceNameTextField.text == "" || changeNameView.deviceNameTextField.text == nil {
            changeNameView.deviceNameTextField.text = "Bamboo 智能数位本"
        }
    SmartpadManager.sharedInstance.setDeviceName(changeNameView.deviceNameTextField.text ?? "Bamboo 智能数位本") { (ret, error) in
            print("修改数为本名字ret = \(ret) error = \(error.debugDescription)")
        }
        
        ///修改UserDefault中的名字
        UserDefaults.standard.set(changeNameView.deviceNameTextField.text ?? "Bamboo 智能数位本", forKey: "InkDeviceName")
        UserDefaults.standard.synchronize()
        
        self.changeNameView.removeFromSuperview()
        
        ///连接完成view
        connectFinishedView = PairSuccessView.loadNibNamed("PairSuccessView")
        self.view.addSubview(connectFinishedView)
        connectFinishedView.nextButton.addTarget(self, action: #selector(connectOk), for: UIControlEvents.touchUpInside)
    }
    
    ///点了连接完成 “完成”按钮
    func connectOk() {
        connectFinishedView.removeFromSuperview()
        
    }
    
    @IBOutlet weak var selectButton: UIButton!
    
    //选择按钮被点击
    @IBAction func selectbuttonPressed(_ sender: UIButton) {
        
        if  sender.currentTitle == "选择"{
            changeSelectedBtn()
 
        }
        else {
            changeSelectBtn2()
        }
    }
    ///“选择”->“取消”
    func changeSelectedBtn() {
        //1.选择->取消
        selectButton.setTitle("取消", for: UIControlState.normal)
        
        //2.setUI Navi
        titleLabel.text = "选择"
        connectInkDeviceButton.isHidden=true
        
        //3.显示 合并, 移出, 删除 3个按钮
        combileButton.isHidden=false
        removeButton.isHidden=false
        deleteButton.isHidden=false
        //删除 云朵按钮隐藏
        cloundButton.isHidden = true
        
        //4.cell当前处与选中效果 这时去掉defaultCell
        //通知ZixunDetailRightZixunContentViewController reload collectionView
        let inkDeviceCellDidSelected = Notification.Name.init(rawValue: "InkDeviceCellDidSelected")
        NotificationCenter.default.post(name: inkDeviceCellDidSelected, object: self, userInfo: ["select":"选择"])
        
        //删除和移出按钮不可点击 当选择cell大于1个时可点击
        removeButton.isEnabled = false
        removeButton.setTitleColor(UIColor.init(red: 197/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1), for: UIControlState.normal)
        deleteButton.isEnabled = false
        combileButton.isEnabled = false
        combileButton.setTitleColor(UIColor.init(red: 197/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1), for: UIControlState.normal)
    }
    
    ///“取消”->“选择”
    func changeSelectBtn2() {
        //1.取消->选择
        selectButton.setTitle("选择", for: UIControlState.normal)
        //2.setUI Navi
        titleLabel.text = "咨询内容"
        connectInkDeviceButton.isHidden=false
        //hidden 合并 移出 删除 3个按钮
        combileButton.isHidden=true
        removeButton.isHidden=true
        deleteButton.isHidden=true
        
        //云朵按钮隐藏
        cloundButton.isHidden = false
        
        //3.cell选中效果
        //通知ZixunDetailRightZixunContentViewController reload collectionView
        let inkDeviceCellDidSelected = Notification.Name.init(rawValue: "InkDeviceCellDidSelected")
        NotificationCenter.default.post(name: inkDeviceCellDidSelected, object: self, userInfo: ["select":"未选择"])
        
        selectedCellArr.removeAll()
        self.zixunRightContentVC?.ziXunContentCollectionView.reloadData()
    }
    
    ///处理合并
    func dealWithCombine(willCombineArr : [String]) {
        ///临时数组 存储从UserDefaults中取出来的imgUrl对应的点数组
        let pointArrs = NSMutableArray()
        for imgUrl in willCombineArr {
            //print("即将要合并的imgUrl = \(imgUrl)")
            //print(UserDefaults.standard.object(forKey: "ink-\(imgUrl)"))//一个包含N个点的数组
            
            let tag = imgUrl.subString(start: 25, length: 32)
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            let filePath = path+"/BezierPath"+"-\(tag)"
            print(NSKeyedUnarchiver.unarchiveObject(withFile: filePath))
            
            if (NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [Any]).count == 0
            {
                let alertVC : UIAlertController = UIAlertController.init(title: "", message: "您选中的图片在本机没有存储笔画，请重新选择。", preferredStyle: .alert)
                
                let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                    return
                    //self.deleteSelectCellImgs()
                    
                }
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (action:UIAlertAction)in
                    
                }
                alertVC.addAction(comfirmAction)
                
                //alertVC.addAction(cancelAction)
                
                self.present(alertVC, animated: true, completion: nil)
            }
            else
            {
                pointArrs.addObjects(from: NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [Any])
            }
            //解归档（反序列化）
            //NSArray *currentBezierPathArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            //pointArrs.addObjects(from:(UserDefaults.standard.object(forKey: "ink-\(imgUrl)") as! [Any]))
            //删除inkImageUrlArray中的imgUrl
            for (index,url) in self.zixunRightContentVC!.inkImageUrlArray!.enumerated() {
                if imgUrl == url {
                   
                    ///同时删除UserDefault中的内容
                    BezierPathManager.sharedInstance().removeBezierPathArr(url)
                    
                    ///删除collection数据源中数据
                    self.zixunRightContentVC?.inkImageUrlArray.remove(at: index)
                    
                }
            }
            
        }
        
        //print("处理合并\(pointArrs)")//pointArrs要转成UIBezierPath
        let bezierPathArr = pointArrs//BezierPathManager.sharedInstance().dealPointsStr(toBezierPathArr2: pointArrs as! [Any])
        
        ///而且要发咨询请求API
        zixunDataUpDate()
        ///遗留问题:合并之后还能加载原来的子图片 是因为后台只有增，没有删
        
        //print("待合并处理的\(bezierPathArr)")
        ///多张变一张 合并结束 刷新Navi(相当于点“取消”按钮一样)
        self.zixunRightContentVC?.dealBezierPathArr(bezierPathArr: bezierPathArr as! [UIBezierPath])
        self.deleteSelectCellImgs()
        changeSelectBtn2()
        
        ///清空临时数组
        pointArrs.removeAllObjects()
        
    }
    //ziXunIdForAPI
    func zixunDataUpDate() {
        
        let request = HZixunUpdate()
        request.params["advisory_id"] = self.zixunRightContentVC!.zixun?.zixun_id
        
        ///此处不能用inkImageUrlArray 因为这里面可能包含写字本下载的图片
        var paramsInkImageUrlArray = [String]()
        for url in self.zixunRightContentVC!.inkImageUrlArray {
            if url.hasPrefix("http") {
                paramsInkImageUrlArray.append(url)
            }
        }
        let imageStr = paramsInkImageUrlArray.joined(separator: ",")
        request.params["image_urls"] = imageStr
        request.params["is_writing_board"] = true
        request.execute()
        print("更新咨询写字本图片请求参数=\(request.params)")
        
    }
    
    //合并按钮
    @IBOutlet weak var combileButton: UIButton!

    
    ///合并[UIBezierPath]用的临时数组
    var combilePath = [UIBezierPath]()
    
    ///合并按钮点击方法
    @IBAction func combileButtonPressed(_ sender: Any) {
        
        ///没有选中任何cell时直接跳过 或者给出提示
        if selectedCellArr.count <= 1 {
            let noSelectMsg = CBMessageView.init(title: "请至少选择2页来合并")
            noSelectMsg?.show()
            return
        }
        
        ///处理合并selectedCellArr 是一个装imgUrl的数组 通过imgUrl可以取到UserDefault中的UIBezierPath 合并成一张img 再重新存入UserDefault 同时删除合并前的数组 刷新collectionView
        dealWithCombine(willCombineArr: selectedCellArr)
 
    }
    
    //移出按钮
    @IBOutlet weak var removeButton: UIButton!
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        
        ///移出到离线区
        InkFileManager.shared.removeImgFromZixunContent(selectedImgArr: selectedCellArr)
        
        ///同时删除选中的内容
        deleteSelectCellImgs()

    }
    
    //删除
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        showComfirmDeleteMsg()
    }
    
    func showComfirmDeleteMsg() {
        
        let alertVC : UIAlertController = UIAlertController.init(title: "确定删除吗", message: "", preferredStyle: .alert)
        
        let comfirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            
            self.deleteSelectCellImgs()

        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (action:UIAlertAction)in
            
        }
        alertVC.addAction(comfirmAction)
        
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    var willDeleteButNotHaveImgID = [String]()
    func deleteSelectCellImgs() {
        
        if selectedCellArr.contains(DragImgUrlString ?? "") {
            DragImgUrlString = nil
        }
        //realTimeFinishUrlString
        if selectedCellArr.contains(realTimeFinishUrlString ?? "") {
            realTimeFinishUrlString = nil
        }
        
        ///选择了之后点删除按钮 批量删除selectedCell
        // selectedCellArr 里面装的是imgUrl 后台imgUrl格式是ID@http:XXX@t ID存在了UserDefault key是http:XXX 这个在zixunRightContentVC就已经处理
        
        print("准备批量删除=\(selectedCellArr)")
        //TODO :因为写完不会立即获得imgID 得出去进来才有 所以在这里删除后台图片可能获取不到imgID
        var willDeleteIDsArr = [String]()
        
        for imgUrl in selectedCellArr {
            if UserDefaults.standard.string(forKey: "imgID-\(imgUrl)") != nil {
                 willDeleteIDsArr.append(UserDefaults.standard.string(forKey: "imgID-\(imgUrl)")!)
            }
            else
            {
                ///如果从实时模式刚写完就删 这时候因为没有获得imgID 无法删除
                ///只能暂时删除当前数据源 然后等待下载zixun Set方法被调用后再删后台数据
                willDeleteButNotHaveImgID.append(imgUrl)
            }
          
        }
        print("willDeleteIDsArr = \(willDeleteIDsArr)")
        UserDefaults.standard.set(willDeleteButNotHaveImgID, forKey: "willDeleteButNotHaveImgID")
        UserDefaults.standard.synchronize()
        
        ///删除ziXunContentCollectionView数据源
        var inkImgUrls = [String]()
        if self.zixunRightContentVC?.inkImageUrlArray != nil {
            
            inkImgUrls = self.zixunRightContentVC?.inkImageUrlArray ?? [""]
            print("inkImgUrls = \(inkImgUrls)")
            
            ///选出inkImageUrlArray中未被选中的imgUrl
            var inkImgUrls2 = inkImgUrls.filter({ (string) -> Bool in
                
                return !selectedCellArr.contains(string)
            })
            
            print("inkImgUrls2 = \(inkImgUrls2)")
            
            self.zixunRightContentVC?.inkImageUrlArray.removeAll()
            self.zixunRightContentVC?.inkImageUrlArray = inkImgUrls2
            inkImgUrls2.removeAll()
        }
        
        /// TODO :有bug
        //self.zixunRightContentVC?.ziXunUpDateAPI(willDeleteImgIDsArr: willDeleteIDsArr)
        deleteSome(willDeleteIDsArr: willDeleteIDsArr, selectCellArr: selectedCellArr)
        
        self.zixunRightContentVC?.ziXunContentCollectionView.reloadData()
        
        selectedCellArr.removeAll()
        
        ///恢复“选择”按钮
        changeSelectBtn2()

    }
    
    ///TODO : test批量删除
    func deleteSome(willDeleteIDsArr:[String],selectCellArr : [String]) {
        
        let request = HZixunUpdate2()
        request.params["advisory_id"] = ziXunIdForAPI
        
        ///此处不能用inkImageUrlArray 因为这里面可能包含写字本下载的图片
        var paramsInkImageUrlArray = [String]()

        ///防止发了不是http开头的图片
        for url in selectCellArr {
            if url.hasPrefix("http") {
                paramsInkImageUrlArray.append(url)
            }
        }

        let imageStr = paramsInkImageUrlArray.joined(separator: ",")
        request.params["image_urls"] = imageStr
        
        request.params["is_writing_board"] = true
        request.params["del_img_list"] = willDeleteIDsArr.joined(separator: ",")
  
        request.execute()
        
        print("选择删除参数HZixunUpdate2=\(request.params)")
      
    }
    
    ///不要定义局部的变量（添加到UIWindow上之后一点Cell会消失） 最好定义成强引用属性
    ///点击navi上的云朵 show出的左侧离线图片View
    var cloudVC = InkCloundVC()
    
    ///云朵按钮
    @IBOutlet weak var cloundButton: UIButton!
    
    @IBAction func cloundButtonDidPressed(_ sender: Any) {
        print("cloudVC = \(cloudVC)")
        
        cloudVC = InkCloundVC()
        cloudVC.view.frame = CGRect.init(x: 0, y: 0, width: 1024, height: 768)
        //cloudVC.offLinetotalFileArr = self.offLinetotalFileArr
        UIApplication.shared.keyWindow?.addSubview(cloudVC.view)
        cloudVC.show()

    }
    
    func didReceiveNotificationOnMainThread(_ notification : NSNotification)
    {
        if ( notification.name.rawValue == kFetchZixunResponse )
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
            {
                self.zixunList = BSCoreDataManager.current().fetchAllZixun(withType: nil, keyword: nil, memberID: nil, zixunID: nil)
                for i in 0..<self.zixunList.count
                {
                    if (self.zixunList[i].zixun_id == self.zixunId)
                    {
                        self.zixun = self.zixunList[i]
                        self.zixunRightContentVC?.zixun = self.zixunList[i]
                        self.checkState()
                    }
                }
                print("咨询list请求完成")
                MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
            }
        }
        else if (notification.name.rawValue == selectedCellNotiName){
            /// 根据通知的select字段判断是选中还是未选中cell 来决定是否加入合并的临时数组
            if (notification.userInfo!["select"] as! String) == "true" {
                ///选中添加
                selectedCellArr.append(notification.userInfo!["cellImgUrl"] as! String)
                
            }
            else{
                ///非选中删除 也就是选中了之后可能改为非选中
                selectedCellArr = selectedCellArr.filter({ (string) -> Bool in
                    return !(string == (notification.userInfo!["cellImgUrl"] as! String))
                })
                
            }
            
            print("selct count = \(selectedCellArr.count)")
            ///如果selectedCellArr数目>1 则navi上的“移出” “删除”按钮 可操作 否则不能
            if selectedCellArr.count > 0 {
                
                removeButton.isEnabled = true
                removeButton.setTitleColor(UIColor.init(red: 96/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1), for: UIControlState.normal)
                
                deleteButton.isEnabled = true
            }
            else {
                
                removeButton.isEnabled = false
                removeButton.setTitleColor(UIColor.init(red: 197/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1), for: UIControlState.normal)
                deleteButton.isEnabled = false
            }
            if selectedCellArr.count > 1 {
                combileButton.isEnabled = true
                combileButton.setTitleColor(UIColor.init(red: 96/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1), for: UIControlState.normal)
            }
            else {
                combileButton.isEnabled = false
                combileButton.setTitleColor(UIColor.init(red: 197/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1), for: UIControlState.normal)
            }
        }
        else if (notification.name.rawValue == lookCloundVCImgNotiName){
            let imgBrowserVC = ZixunImgBrowserVC()
            imgBrowserVC.lookImgFrom = notification.userInfo!["from"] as! String
            imgBrowserVC.iconArray = notification.userInfo!["arr"] as! [Any]
            imgBrowserVC.index = (notification.userInfo!["index"] as! IndexPath).row
            
            imgBrowserVC.removebtnBlock = {(imgIndex , imgUrl) in
                
                //print("removebtn准备删除第\(imgIndex)张 imgUrl = \(imgUrl)")
                
                ///删除本地离线数据源 刷新InkCloudVC
                InkFileManager.shared.removeDownLoadOffLineImage(imgUrl: imgUrl!)
                
                self.cloudVC.offLineImgDownLoadFinish()
                
            }
            self.navigationController?.pushViewController(imgBrowserVC, animated: true)
        }
        else if (notification.name.rawValue == connectDeviceCatchNotiName){
            ///设备断开连接了
            self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
            dealBlueToothReStart()
            self.zixunRightContentVC?.reloadFisetRowData(false)
        }
        else if (notification.name.rawValue == setUpFileDataReceiverFaildNotiName){
            ///设置下载接受服务失败或出现断电情况
            PersisitentTool.shared.hasRetConnectedDevice = false
            self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
            self.zixunRightContentVC?.reloadFisetRowData(false)
        }
        else if (notification.name.rawValue == inkDeviceHasConnectedNotiName){
            //TODO : 点一下完成 需要用户重新配对
            needClickFlag = true
            
            isInkDeviceConnected = true
            
            self.powerOffView.removeFromSuperview()
            
            ///和云朵按钮一起显示
            if !cloundButton.isHidden {
                
                self.connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
                pushInkDeviceButtonView.removeFromSuperview()
                self.reConnectedView.removeFromSuperview()
                self.zixunRightContentVC?.reloadFisetRowData(true)
            }
        }
        else if (notification.name.rawValue == inkDevicePowerChangeNotiName){
            ///电量低于20%显示电量低 其他按百分比显示 默认显示ink_baterry@2x
            let power = notification.userInfo!["level"] as! Int
            print("数为本当前电量=\(power)") //Int
            if power == 100 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power100.png"), for: UIControlState.normal)
            }
            else if power<100 && power >= 90 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power90.png"), for: UIControlState.normal)
            }
            else if power<90 && power >= 80 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power80.png"), for: UIControlState.normal)
            }
            else if power<80 && power >= 70 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power70.png"), for: UIControlState.normal)
            }
            else if power<70 && power >= 60 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power60.png"), for: UIControlState.normal)
            }
            else if power<60 && power >= 50 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power50.png"), for: UIControlState.normal)
            }
            else if power<50 && power >= 40 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power40.png"), for: UIControlState.normal)
            }
            else if power<40 && power >= 30 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power30.png"), for: UIControlState.normal)
            }
            else if power<30 && power >= 20 {
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power20.png"), for: UIControlState.normal)
            }
            else {
                ///电量极低
                connectInkDeviceButton.setImage(UIImage.init(named: "ink_power10.png"), for: UIControlState.normal)
            }
        }
            //inkDeviceDidReconnectedNotification
        else if (notification.name.rawValue == inkDeviceDidReconnectedNotification) {
            
            //取消按一下View 改connectBtn为已连接
            pushInkDeviceButtonView.removeFromSuperview()
            checkoutInkDeviceLostTimer.invalidate()
            connectInkDeviceButton.setImage(UIImage.init(named: "ink_baterry"), for: UIControlState.normal)
            
            powerOffView.removeFromSuperview()
            print("接收到通知处isInkDeviceClosedTimer.isValid = \(isInkDeviceClosedTimer.isValid)")
            //isInkDeviceClosedTimer.invalidate()
            if blueToothStatus == "poweredOn"
            {
                checkOutInkDeviceIsPowerOff()
            }
        }
        //inkDeviceDidReDisConnectedNotification
        else if (notification.name.rawValue == inkDeviceDidReDisConnectedNotification){
            connectInkDeviceButton.setImage(UIImage.init(named: "ink_noConnected.png"), for: UIControlState.normal)
            checkoutInkDeviceLostTimer.invalidate()
        }
        else if (notification.name.rawValue == "EPadSelectFinished")
        {
            checkState()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


