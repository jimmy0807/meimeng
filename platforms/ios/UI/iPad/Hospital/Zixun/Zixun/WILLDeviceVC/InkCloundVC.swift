//
//  InkCloundVC.swift
//  meim
//
//  Created by 刘伟 on 2017/12/5.
//

import Foundation

class InkCloundVC : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var offLinetotalFileArr = [[UIBezierPath]]()
    
    /// 未和咨询绑定的图片url
    var noBindPictureUrlArr = [String]()

    ///离线图片collectionView
    @IBOutlet weak var offLineFilebgView: UIView!
    
    //var offLineFileCollectionView : UICollectionView?;
    
    @IBOutlet var offLineFileCollectionView: UICollectionView!
    
    let CELL_ID = "offLinePictureCell";
    
    let HEAD_ID = "InkPictureHeaderView";
    
    ///用来控制视图的出现和隐藏
    @IBOutlet weak var backViewLeading: NSLayoutConstraint!
    
    ///是否拖拽cell到了满足条件的x
    
    typealias DrugFinished = (Bool) ->()
    
    var drugFinished : DrugFinished?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hidden()
        self.view.removeFromSuperview()
    }
    
    ///保存写字本图片url的数组
    var inkImageUrlArray:[String]! = []
    
    override func viewDidAppear(_ animated: Bool) {
        ///离线图片->collectionViewCell上的小图片 inkImageUrlArray应该是追加的, 包含了从后台拉取的和从设备下载的两部分
        
        ///因为forin遍历的时间是一样的 所以为了区分开 加一个依次递增的整数
        var tagNumber : NSInteger = 1
        for bezierPathArr in offLinetotalFileArr {
            let cellImg = creatCellImage(bezierPathsArr: bezierPathArr)
            let tag:NSInteger = NSInteger(NSDate().timeIntervalSince1970)
            let url = URL(string: "\(tag+tagNumber)")
            tagNumber = tagNumber + 1
            //print("url = \(String(describing: url))")
            SDWebImageManager.shared().saveImage(toCache: cellImg, for: url)
            //inkImageUrlArray?.append("\(url!)")
            //inkUploadStatusArray.append(false)
        }
        //offLineFileCollectionView.reloadData()
    }
    
    func setUpUI() {
        ///实现offLineFilebgView模糊效果(UI次要)
        let blurEffrct : UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffrct)
        visualEffectView.frame = self.offLineFilebgView.frame
        visualEffectView.alpha = 0.9
        self.offLineFilebgView.addSubview(visualEffectView)
        
        backViewLeading.constant = -308
        
    }

    func show() {
        
        getUserDefaultData()

        UIView.animate(withDuration: 0.2, animations: {
            self.backViewLeading.constant = 0
            //self.view.layoutIfNeeded()
        }) { (ret) in
            self.offLineFileCollectionView.reloadData()
        }
        
    }
    
    func hidden() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.backViewLeading.constant = -308
            self.view.layoutIfNeeded()
        }
    }
    
    var downImgDateArr = [String]()
    var oneDateDownImgUrlArr = [String]()
    func getUserDefaultData(){
        
        if UserDefaults.standard.object(forKey: "downOffLineImgDate") as? [String] != nil {
            downImgDateArr = UserDefaults.standard.object(forKey: "downOffLineImgDate") as! [String]

        }

    }
    
    func removeDuplicate(_ imageUrlArray:[String])->[String]
    {
        var lastImageStr = ""
        var duplicateArr:[Int] = []
        var resultArr = imageUrlArray
        for i in 0..<resultArr.count
        {
            let imgStr = resultArr[i]
            if imgStr == lastImageStr
            {
                duplicateArr.append(i)
            }
            lastImageStr = imgStr
        }
        duplicateArr.reverse()
        if duplicateArr.count > 0
        {
            for i in 0..<duplicateArr.count
            {
                resultArr.remove(at: i)
            }
        }
        return resultArr
    }
    
    func registerNoti() {
        
        let offLineImgDownLoadFinished = Notification.Name.init(rawValue: "offLineImgDownLoadFinished")
        NotificationCenter.default.addObserver(self, selector: #selector(offLineImgDownLoadFinish), name: offLineImgDownLoadFinished, object: nil)
        
        
    }
    
    func offLineImgDownLoadFinish() {
        ///再取一次数据源
        getUserDefaultData()
        //removeDuplicate()
        self.offLineFileCollectionView.reloadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
      
        ///去拉取保存到UserDefault的离线数据
        getUserDefaultData()
        
        ///创建存放离线文件的collectionView
        createCollectionView();
        
        registerNoti()
        
    }
    
    var testArray = [String]()
    func creatTestData() {
        testArray = ["A","B","C","D","E","F","G","H"]
    }
    
    func createCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout();
        //水平间隔
        flowLayout.minimumInteritemSpacing = 10.0
        
        //垂直行间距
        flowLayout.minimumLineSpacing = 5.0
        
        //设置单元格宽度和高度
        flowLayout.itemSize = CGSize(width:124, height:124)
        
        //offLineFileCollectionView = UICollectionView.init(frame: CGRect.init(x: 22, y: 30, width: 308 - 44, height: 768-60), collectionViewLayout: flowLayout)
        
        offLineFileCollectionView.backgroundColor = UIColor.clear
        
        ///注册cell (xib方式)
        offLineFileCollectionView?.register(UINib.init(nibName: "OffLinePictureCell", bundle: nil), forCellWithReuseIdentifier: "offLinePictureCell")
        
        ///注册头部
        offLineFileCollectionView.register(InkPictureHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEAD_ID)
        
        offLineFileCollectionView.delegate = self;
        offLineFileCollectionView.dataSource = self;
        
        //offLineFileCollectionView?.clipsToBounds = true
        offLineFileCollectionView.bounces = false
        
        self.view.addSubview(offLineFileCollectionView);
        
        ///添加长按手势 (参考前台分诊预约拖动)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didCellLongPressed(_:)))
        offLineFileCollectionView.addGestureRecognizer(longPressGesture);
        
    }
    var snapShotView : UIView?
    var gestureStartPoint : CGPoint!
    var snapShotViewOrinalPoint : CGPoint!
    //var gestureZiXunInkPicture : CDZixunBook?

    var zixunRightContentVC : ZixunDetailRightZixunContentViewController?

    ///拖动cell仿照了前台分诊的拖动效果
    func didCellLongPressed(_ gestureRecognizer : UILongPressGestureRecognizer)
    {
        
        if gestureRecognizer.state == .began
        {
            ///禁用主界面手势
            self.view.isUserInteractionEnabled = false
            
            let location = gestureRecognizer.location(in: offLineFileCollectionView)
            let indexPath : IndexPath = offLineFileCollectionView.indexPathForItem(at: location)!
            
            drugFinished = {(finished) -> () in
                if finished {
                    
                    ///移动数据源中的数据到右侧
                    //self.inkImageUrlArray.remove(at: indexPath?.row ?? 0)
                    //print("移动的是哪个cell = \(indexPath.row)")
                    
                    ///刷新两边的数据源
                    ///TODO: 是否要给一个提示 是否确定绑定到右边咨询单？
                    
                    for (index,item) in self.downImgDateArr.enumerated() {
                        var downImgUrlArr = [String]()
                        if index == indexPath.section {
                            downImgUrlArr = UserDefaults.standard.object(forKey: item) as! [String]
                         
                        //removeDownLoadOffLineImage
                        InkFileManager.shared.removeDownLoadOffLineImage(imgUrl: downImgUrlArr[indexPath.row])
                            
                        ///重新取数据 刷新collectionView
                        if (UserDefaults.standard.object(forKey: "downOffLineImgDate") as? [String]) != nil {
                            self.downImgDateArr = UserDefaults.standard.object(forKey: "downOffLineImgDate") as! [String]
                            self.offLineFileCollectionView.reloadData()
                        }
                        
                        hadDragImgUrl = false
                        ///发通知告诉zixunRightContentVC刷新CollectionView
                        let moveOffLineImgItemFinished = Notification.Name.init(rawValue: "moveOffLineImgItemFinished")
                        NotificationCenter.default.post(name: moveOffLineImgItemFinished, object: downImgUrlArr[indexPath.row], userInfo: nil)
                        
                        }
                    }

                }//end finished

            }
            
            if let cell =  offLineFileCollectionView.cellForItem(at: indexPath)
            {
                let snapshot = cell.contentView.snapshot()!
                snapshot.frame = cell.convert(cell.bounds, to: nil)
                snapshot.alpha = 1;
                snapshot.layer.shadowRadius = 8.0;
                snapshot.layer.shadowOpacity = 0.0;
                snapshot.layer.shadowOffset = CGSize.zero;
                snapshot.layer.shadowPath = UIBezierPath(rect: snapshot.layer.bounds).cgPath
                snapshot.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
                self.snapShotView = snapshot
                self.gestureStartPoint = gestureRecognizer.location(in: self.view.superview)
                self.snapShotViewOrinalPoint = snapshot.frame.origin
                
                UIApplication.shared.keyWindow?.addSubview(snapshot)
                
                UIView.animate(withDuration: 0.3, animations: {
                    snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                })
            }
        }
        else if gestureRecognizer.state == .changed
        {
            
            if let snapshot = self.snapShotView
            {
                let location = gestureRecognizer.location(in: self.view.superview)
                snapshot.frame.origin =  CGPoint(x: self.snapShotViewOrinalPoint.x + location.x - self.gestureStartPoint.x, y: self.snapShotViewOrinalPoint.y + location.y - self.gestureStartPoint.y)
            }
        }
            
        else if gestureRecognizer.state == .ended
        {
            let location = gestureRecognizer.location(in: self.view.superview)
            
            //print("drug end location.x = \(location.x)")//382
            //print("drug end location.y = \(location.y)")//410
            ///拖拽的图片满足一定条件才执行删除操作 (x,y不是严格的标准值 只是为了做成好像是拖进了咨询内容框一样的效果)
            if (location.x > 382.0) && (location.y < 410) && (location.y > 0) {
                ///用这个block回调给.began手势 要删除拖动的cell了
                drugFinished!(true)
                
            }
            
            offLineFileCollectionView.reloadData()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.snapShotView?.alpha = 0
            }, completion: { _ in
                self.snapShotView?.removeFromSuperview()
            })
            
            ///打开主界面手势
            self.view.isUserInteractionEnabled = true
            
        }
    }
    
    //MARK: - UICollectionView 代理
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("downImgDateArr.count = \(downImgDateArr.count)")
        return downImgDateArr.count > 0 ? downImgDateArr.count : 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("云朵VC-section = \(section) - \(getNumberOfRows(section: section))")
        return getNumberOfRows(section: section)
        //return inkImageUrlArray.count
        //return testArray.count
    }
    
    ///获取dateStr : ImgUrlArr
    func getNumberOfRows(section : Int) -> Int {
        var downImgUrlArr = [String]()
        for (index,item) in downImgDateArr.enumerated() {
            print("index = \(index) - item = \(item)")
            if index == section {
                
                //print(UserDefaults.standard.object(forKey: item))
                if (UserDefaults.standard.object(forKey: item) as? [String]) != nil {
                    downImgUrlArr = UserDefaults.standard.object(forKey: item) as! [String]
                    downImgUrlArr = self.removeDuplicate(downImgUrlArr)
                }
            }
        }
        return downImgUrlArr.count
    }
    
    //返回 cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! OffLinePictureCell;

        for (index,item) in downImgDateArr.enumerated() {
            var downImgUrlArr = [String]()
            if index == indexPath.section {
                downImgUrlArr = UserDefaults.standard.object(forKey: item) as! [String]
                downImgUrlArr = self.removeDuplicate(downImgUrlArr)
                cell.smallImageView.sd_setImage(with: URL.init(string: downImgUrlArr[indexPath.row]))
            }
        }
       
        cell.layer.cornerRadius = 5
        cell.contentView.layer.cornerRadius = 5
        cell.layer.masksToBounds = false
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 124, height: 124)

    }
    
    //每个分区区头尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 132, height: 54)
    }
    
    //返回区头、区尾实例
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
          
            //let headView = InkPictureHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: 132, height: 48))
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEAD_ID, for: indexPath as IndexPath) as! InkPictureHeaderView
            if downImgDateArr.count == 0 {
                 
            }
            else {
                headView.titleLabel.text = downImgDateArr[indexPath.section]

            }
            reusableView = headView
            
        }
        return reusableView
    }
    
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        ///进入详细页面查看 当前日期下的图片
        
        ///先找到dateStr-ImgUrlArr数据源
        var downImgUrlArr = [String]()
        for (index,item) in self.downImgDateArr.enumerated() {
            if index == indexPath.section {
                downImgUrlArr = UserDefaults.standard.object(forKey: item) as! [String]
            }
        }
        
        ///移出CoundVC 发通知让ZixunDetailContainerVC推到图片浏览界面
        self.view.removeFromSuperview()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lookCloundVCImgNotiName"), object: self, userInfo: ["arr":downImgUrlArr,"index":indexPath,"from":"InkCloundVC"])
        
    }
    
    func creatCellImage(bezierPathsArr : [UIBezierPath]) -> UIImage {
        
        ///绘制手写本内容: 因为这里下载的是大图尺寸 所以先画到一个UIImageView上 再缩放成小图添加到cell上
        let bigImageView:UIImageView = UIImageView.init(frame: CGRect.init(x: 270, y: 80, width: 490, height: 693))
        //bigImageView.backgroundColor = UIColor.orange
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
            bigImageView.layer.addSublayer(shapeLayer)
        }
        
        ///UIView转UIImage
        UIGraphicsBeginImageContextWithOptions(bigImageView.bounds.size, false, 0.0 )
        bigImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return img
    }
    
    
}
