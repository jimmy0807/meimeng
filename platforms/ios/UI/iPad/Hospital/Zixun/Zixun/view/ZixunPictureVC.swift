//
//  ZixunPictureVC.swift
//  meim
//
//  Created by 波恩公司 on 2017/11/15.
//

import Foundation
import UIKit
import WILLDevices
import WILLDevicesCore
import WILLInk


class ZixunPictureVC : UIViewController,UIScrollViewDelegate  {
    
    ///当前写的这次路径
    var currentBezierPathArr = [UIBezierPath]()
    
    ///拆分后半部分数组
    var splitBezierPathArr = [UIBezierPath]()
    
    
    ///下载图片必要参数
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
    
    /// The collection view used to render samples of the files recevied
    @IBOutlet var collectionView: UICollectionView!
    
    /// Flag to stop spamming when we are polling for files 当我们轮询文件时，标记停止垃圾邮件
    internal var showFinishedPrompt = true
    
    /// Flag to see if we should be polling for new files
    internal var pollForNewFiles = true
    
    /// Should we rotate the recevied files to match orientation 我们是否应该旋转接收的文件以匹配方向
    internal var shouldRotateImages = true
 
    @IBOutlet weak var picture: UIView!
    
    var lastScaleFactor : CGFloat! = 1.5  //放大、缩小

    var netRotation : CGFloat = 1;//旋转
    
    var netTranslation : CGPoint! = CGPoint(x: 0, y: 0)//平移
    
    var document : InkDocument!
    
    var cellContentView : UIView!
    
    ///拆分View
    
    @IBOutlet weak var SliderBackGroundView: UIView!
    
    
    @IBOutlet weak var sliderView: UISlider!
    
    ///拆分即将结束flag
    var splitWillFinished : Bool = false
    
    
    init(currentBezierPathArr : [UIBezierPath]) {
        
        self.currentBezierPathArr = currentBezierPathArr
        
        super.init(nibName: "ZixunPictureVC", bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //netTranslation = CGPoint(x: 0, y: 0)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
    override func viewDidAppear(_ animated: Bool) {
        

    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @objc func setNewUI(){
        //设置新UI
        if let sublayers = picture.layer.sublayers {
            for l in sublayers {
                if l is CAShapeLayer {
                    l.removeFromSuperlayer()
                }
            }
        }

        for bezPath in currentBezierPathArr {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezPath.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            picture.layer.addSublayer(shapeLayer)
        }
   
    }
    
    override func viewDidLoad() {
        
        for bezPath in currentBezierPathArr {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezPath.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            picture.layer.addSublayer(shapeLayer)
        }
        
        //slider.setValue(0.8,animated:true)
        //sliderView.isContinuous = false  //滑块滑动停止后才触发ValueChanged事件
        sliderView.addTarget(self,action:#selector(sliderDidchange(_:)), for:UIControlEvents.valueChanged)
        SliderBackGroundView.isHidden = true
        
        //手势为捏的姿势:按住option按钮配合鼠标来做这个动作在虚拟器上
        
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
//        BigImage.addGestureRecognizer(pinchGesture)

//        //拖手势
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
//        picture.addGestureRecognizer(panGesture)
        
//        let doubleTap = UITapGestureRecognizer.init(target: self,
//                                                    action: #selector(self.twoTouch(_:)))
//        doubleTap.numberOfTapsRequired = 2
//        BottomScroll.addGestureRecognizer(doubleTap)

    }
    
    
    
    @IBAction func ziXunPictureClicked(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "123")
        if sender.titleLabel?.text == "取消" {
            ///setUpNavi
            //1.隐藏sliderView
            SliderBackGroundView.isHidden = true
            //2.retNaviUI
            zxixunPicturesBtn.titleLabel?.text = "咨询图片"
            timeLabel.text = ""
            deleteButton.isHidden = false
            //3.拆分按钮可以点击
            splitButton.isEnabled=true
            splitButton.isHidden = false
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //捏的手势，使图片放大和缩小，捏的动作是一个连续的动作
    func handlePinchGesture(sender: UIPinchGestureRecognizer){
        
        let factor = sender.scale
        if factor > 1{
            //图片放大
            picture.transform = CGAffineTransform(scaleX: lastScaleFactor+factor-1, y: lastScaleFactor+factor-1)
        }else{
            //缩小
            picture.transform = CGAffineTransform(scaleX: lastScaleFactor*factor, y: lastScaleFactor*factor)
        }
        //状态是否结束，如果结束保存数据
        if sender.state == UIGestureRecognizerState.ended{
            
            if factor > 1{
                lastScaleFactor = lastScaleFactor + factor - 1
            }else{
                lastScaleFactor = lastScaleFactor * factor
            }
        }
        
        
    }
    
    //拖手势
    func handlePanGesture(sender: UIPanGestureRecognizer){
        //得到拖的过程中的xy坐标
        let translation : CGPoint = sender.translation(in: picture)
        //平移图片CGAffineTransformMakeTranslation
        picture.transform = CGAffineTransform(translationX: netTranslation.x+translation.x, y: netTranslation.y+translation.y)
        if sender.state == UIGestureRecognizerState.ended{
            netTranslation.x += translation.x
            netTranslation.y += translation.y
        }
    }
    
    //拆分
    @IBOutlet weak var splitButton: UIButton!
    
    @IBAction func SplitButtonPressed(_ sender: Any) {
       
        if splitWillFinished {
            
            ///先删除原图
            for (index,BezierPathArr) in FileTransferManger.shared.filetotalArr.enumerated() {
                if BezierPathArr == self.currentBezierPathArr {
                    FileTransferManger.shared.filetotalArr.remove(at: index)
                }
            }
            
            ///结束拆分 保存拆分内容
            self.currentBezierPathArr = newBezierPathArr
            
            ///把拆分的2个部分 笔划数组传给FileTransferManger
            FileTransferManger.shared.filetotalArr.append(newBezierPathArr)
            FileTransferManger.shared.filetotalArr.append(splitBezierPathArr)
            
            ///去掉拆分 画面
            SliderBackGroundView.isHidden=true
            zxixunPicturesBtn.titleLabel?.text = "咨询图片"
            deleteButton.isHidden = false
            timeLabel.text = ""
            splitWillFinished = false
            
            
        } else{
            //如果笔画path小于2 那就不允许拆分
            if self.currentBezierPathArr.count < 2 {
                let forbidenMessage = CBMessageView.init(title: "无法拆分,因为至少需要2笔划")
                forbidenMessage?.show()
                return
            }
            else{
                //1.显示sliderView
                SliderBackGroundView.isHidden = false
                //2.retNaviUI
                zxixunPicturesBtn.titleLabel?.text = "取消"
                timeLabel.text = "拆分"
                deleteButton.isHidden = true
                //3.拆分按钮变灰
                splitButton.titleLabel?.textColor = UIColor.gray
                splitButton.isEnabled = false
            }
            
            
        }

    }
    
    //删除
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        ///删除当前页
        for (index,item) in FileTransferManger.shared.filetotalArr.enumerated() {
            if item == currentBezierPathArr {
                FileTransferManger.shared.filetotalArr.remove(at: index)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //时间标签
    @IBOutlet weak var timeLabel: UILabel!
    
    //咨询图片按钮
    @IBOutlet weak var zxixunPicturesBtn: UIButton!
    
    
//    @IBAction func cancelSplitButtonPressed(_ sender: Any) {
//        
//        //恢复拆分按钮点击前
//        sliderView.isHidden=true
//        
//        deleteButton.isHidden=false
//        
//        SplitButton.titleLabel?.textColor = UIColor.init(red: 92/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1)
//        
//        SplitButton.isEnabled=true
//        
//        cancelSplitButton.isHidden=true
//        
//        zxixunPicturesBtn.isHidden=false
//        
//        timeLabel.isHidden=false
//        
//    }
    
    var newBezierPathArr = [UIBezierPath]()
    ///拆分时滑动Slider时调用
    @objc func sliderDidchange(_ slider:UISlider){
        //print("slider.value = \(slider.value)")//0-1
        newBezierPathArr.removeAll()
        
        if slider.value < 1 {
            splitButton.titleLabel?.textColor = UIColor.init(red: 92/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1)
            splitButton.isEnabled=true
            ///这时再点拆分按钮就是完成 结束拆分这次操作了
            splitWillFinished = true
            
        }
        else {
            splitButton.titleLabel?.textColor = UIColor.lightGray
            splitButton.isEnabled=false
        }
        
        //self.currentBezierPathArr.count
        
        newBezierPathArr = self.currentBezierPathArr
        
        //slider.value换算成path的个数
        let splitPathCount : NSInteger  = self.currentBezierPathArr.count * (Int)(slider.value * 10) / 10
        
        //print("slider.value换算成path的个数 = \(splitPathCount)")
        ///选取splitPathCount个作为新的self.currentBezierPathArr 其余新生成一个数组
        var i : Int = 0
        var startBezierPathArr = [UIBezierPath]()
        //var endBezierPathArr = [UIBezierPath]()
        while i < splitPathCount {
            startBezierPathArr.append(self.currentBezierPathArr[i])
            i = i + 1
        }
        newBezierPathArr = startBezierPathArr
        
        var j : Int = self.currentBezierPathArr.count
        while j > splitPathCount {
            splitBezierPathArr.append(self.currentBezierPathArr[j-1])
            j = j - 1
        }
        
        ///用self.currentBezierPathArr重新设置UI
        setSplitNewUI(splitPathArr: newBezierPathArr)
        
    }
    
    func setSplitNewUI(splitPathArr : [UIBezierPath]){
        //设置新UI
        if let sublayers = picture.layer.sublayers {
            for l in sublayers {
                if l is CAShapeLayer {
                    l.removeFromSuperlayer()
                }
            }
        }
        
        for bezPath in splitPathArr {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezPath.cgPath
            shapeLayer.position = CGPoint.zero
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            picture.layer.addSublayer(shapeLayer)
        }
    }
    
}


extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }

    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        //let reSize = CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}







