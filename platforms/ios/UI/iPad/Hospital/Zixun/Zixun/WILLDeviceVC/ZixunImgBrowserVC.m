//
//  ZixunImgBrowserVC.m
//  meim
//
//  Created by 刘伟 on 2017/12/11.
//

#import "ZixunImgBrowserVC.h"
#import "BezierPathManager.h"
#import "CBMessageView.h"
#import "WillSplitView.h"

#define ScreenW 1024
#define ScreenH 693

///声明一个枚举 知道是从哪里进来的
typedef enum lookImgFromType
{
    CloundVCType,
    ZxDetailRightContentVCType
}lookImgFromType;

@interface ZixunImgBrowserVC ()<UIScrollViewDelegate>{
    ///当前在第几张
    NSInteger imgIndex;
    
    //拆分即将结束flag
    BOOL splitWillFinished ;
    
    ///拆分数目
    NSInteger currentSplitPathCount;
}


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
///Scrollview

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@property (weak, nonatomic) IBOutlet UIButton *splitBtn;

@property (weak, nonatomic) IBOutlet UIView *sliderBgView;

@property (weak, nonatomic) IBOutlet UISlider *sliderView;

///拆分View
@property (strong,nonatomic) UIImageView *willSplitView;

/// 当前拆分的path数组
@property (strong,nonatomic) NSArray *willSplitPathArr;

@property (strong,nonatomic)NSMutableArray *leftPathArr;
@property (strong,nonatomic)NSMutableArray *rightPathArr;



@end

@implementation ZixunImgBrowserVC


-(void)creatNewWillSplitView: (NSArray *)bezierpathArr {
  
#if 0
    WillSplitView *willSplitView = [[WillSplitView alloc]initWithFrame:CGRectMake(261.1, 76, 501.8, ScreenH) AndBezierPathArr:bezierpathArr];
    //261.1+ScreenW*imgIndex
    [willSplitView setNeedsDisplay];

    _willSplitView = willSplitView;
    [self.view addSubview:_willSplitView];
#endif
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#if 1
    ///生成拆分View
    UIImageView *willSplitView = [[UIImageView alloc]initWithFrame:CGRectMake(270+ScreenW*imgIndex, 1, 490, 693)];
    //CGRectMake(261.1+ScreenW*imgIndex, 1, 501.8, ScreenH)
    //CGRectMake(270+ScreenW*imgIndex, 1, 484, 693)
    willSplitView.image = [UIImage imageNamed:@"ink_moban2.jpg"];
    willSplitView.backgroundColor = [UIColor whiteColor];

    _willSplitView = willSplitView;
    
    _willSplitView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _willSplitView.alpha = 1;
        
    } completion:^(BOOL finished) {
        [_scrollView addSubview:_willSplitView];
        self.sliderBgView.hidden = NO;
        [self.view bringSubviewToFront:self.sliderBgView];
    }];
    
//    ///移出已有图层
//    NSMutableArray *sublayers = (NSMutableArray *)_willSplitView.layer.sublayers;
//    if (sublayers) {
//        for (id l in sublayers) {
//            if ([l isKindOfClass:[CAShapeLayer class]]) {
//                [l removeFromSuperlayer];
//            }
//        }
//    }
//
    NSLog(@"bezierpathArr.count = %d",bezierpathArr.count);
    
    // addSublayer内存爆了
    @synchronized(self) {
        //NSLog(@"addSublayer");
        for (UIBezierPath *bezPath in bezierpathArr) {
            CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
            //shapeLayer.shouldRasterize = YES;
            shapeLayer.path = bezPath.CGPath;
            shapeLayer.position = CGPointZero;
            shapeLayer.fillColor = [UIColor blackColor].CGColor;
            shapeLayer.strokeColor = [UIColor clearColor].CGColor;
            //shapeLayer.lineWidth = 3;//设置无效
            [_willSplitView.layer addSublayer:shapeLayer];///这句代码耗性能
            //[_willSplitView.layer insertSublayer:shapeLayer atIndex:0];
        }
    }

    [self.view bringSubviewToFront:self.headerView];

#endif
}

- (IBAction)splitBtnDidPressed:(id)sender {
 
    //拆分的前提条件是笔画数大于2
    ///从UserDefault中取出path渲染到View
    /**
     pointsArr中格式是 ["[point]","[]"...]
     */
    
    ///取存储的点文件
    //获得文件路径
    NSString *tag = [_iconArray[imgIndex] substringFromIndex:25];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/BezierPath-%@",tag]];
    //NSString *filePath = [documentPath stringByAppendingPathComponent:@"/BezierPath"];

    //解归档（反序列化）
    NSArray *currentBezierPathArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"%@",currentBezierPathArr);
    self.scrollView.scrollEnabled = YES;

//    NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
//    let filePath = path+"/BezierPath"
//    //归档
//    NSKeyedArchiver.archiveRootObject(bezierPathArr, toFile: filePath)
//    let unArchive = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
//    let pathArray:[UIBezierPath] = unArchive as! [UIBezierPath]
//    print(pathArray)
//
//    NSArray *pointsArr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ink-%@",_iconArray[imgIndex]]];
//    ///取临时点文件
//    //NSArray *pointsArr = [BezierPathManager sharedInstance].pathStrArr;
//
//    NSArray *currentBezierPathArr = [[BezierPathManager sharedInstance]dealPointsStrToBezierPathArr2: pointsArr];
    if (currentBezierPathArr.count > 1) {
        
        ///赋值给willSplitPathArr
        self.willSplitPathArr = currentBezierPathArr;
        
        //splitWillFinished为是否完成拆分标志
        if (splitWillFinished) {
            if (self.rightPathArr.count == 0)
            {
                return;
            }
            //NSLog(@"拆成两张 并且删除原图 %@",self.leftPathArr);
            self.splitFinished(self.leftPathArr, self.rightPathArr, _iconArray[imgIndex]);
            self.sliderBgView.hidden = YES;
            self.removeBtn.hidden = NO;
            splitWillFinished = NO;
            
            ///清空一下当前临时数组
            [self.leftPathArr removeAllObjects];
            [self.rightPathArr removeAllObjects];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            ///隐藏删除按钮
            if (self.removeBtn.hidden)
            {
                self.removeBtn.hidden = NO;
                self.sliderBgView.hidden = YES;
                self.scrollView.scrollEnabled = YES;
            }
            else
            {
                self.sliderView.value = 1.0;
                self.removeBtn.hidden = YES;
                self.scrollView.scrollEnabled = NO;
                ///创建一个待拆分的view
                [self creatNewWillSplitView:currentBezierPathArr];
            }
        }
    }
    else {
        CBMessageView *forbidenMessage = [[CBMessageView alloc]initWithTitle:@"无法拆分,因为至少需要2笔划。或者本机没有存储笔画。"];
        [forbidenMessage show];
        return;
    }
    
}

-(void)showWaringAlertView:(NSInteger)imgIndex {
   
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:@"" preferredStyle:1];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定 " style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self.lookImgFrom isEqualToString:@"InkCloundVC"]) {
            if (self.removebtnBlock != nil) {
                
                NSLog(@"要删第%d",imgIndex);
                self.removebtnBlock(imgIndex, _iconArray[imgIndex]);
                
            }
        }
        else if ([self.lookImgFrom isEqualToString:@"ZixunDetailRightZixunContentViewController"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteImgFinished" object:_iconArray[imgIndex]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//
//        });
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];

    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (IBAction)removeBtnDidPressed:(id)sender {
    ///确定要删除第index张吗? 0,1,2,3...
    //NSLog(@"确定要删除第%d张吗?",imgIndex);
    
    //确认弹窗
    [self showWaringAlertView:imgIndex];
    
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
  
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"lookImgFrom = %@",self.lookImgFrom);

    [self setupScrollView];
    
    [self setUpOtherUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///TODO:拆分功能暂时不做 隐藏该按钮
    self.splitBtn.hidden = NO;
    
    // Do any additional setup after loading the view.
    self.leftPathArr = [NSMutableArray array];
    self.rightPathArr = [NSMutableArray array];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)setUpOtherUI {
    self.sliderBgView.hidden = YES;
    //这个属性是控制要不要松开手指出发sliderView的控制事件 NO表示松开才触发
    //self.sliderView.continuous = NO;
    [self.sliderView addTarget:self action:@selector(sliderDidchange:) forControlEvents:UIControlEventValueChanged];
}

-(void)sliderDidchange: (UISlider *)slider {
    
    //NSLog(@"[sliderValue doubleValue] = %f",[sliderValue doubleValue]);
//    NSString *sliderValue = [NSString stringWithFormat:@"%f",slider.value];
    
//    if ([sliderValue doubleValue] == 0.0 ||[sliderValue doubleValue] == 0.1 || [sliderValue doubleValue] == 0.2 ||[sliderValue doubleValue] == 0.3 ||[sliderValue doubleValue] == 0.5 ||[sliderValue doubleValue] == 0.6 ||[sliderValue doubleValue] == 0.7 ||[sliderValue doubleValue] == 0.8 ||[sliderValue doubleValue] == 0.9 ||[sliderValue doubleValue] == 0.4 ||[sliderValue doubleValue] == 1.0)
//    {
    
            splitWillFinished = YES;
        
            ///初始值设为0.99
            if (slider.value == 0 || slider.value == 1) {
                self.splitBtn.enabled = NO;
        
            } else {
                self.splitBtn.enabled = YES;
        
                //self.leftPathArr = (NSMutableArray *)self.willSplitPathArr;
        
                
                //[sliderValue doubleValue]换算成path的个数
                NSInteger splitPathCount = (NSInteger)(self.willSplitPathArr.count * slider.value + 1.0);
                //        NSInteger splitMiddleCount = splitPathCount;
                //        if ([sliderValue doubleValue] < 0.5) {
                //            splitMiddleCount = splitPathCount - 1;
                //        }
                NSLog(@"总count = %d ,splitPathCount =%d, slider value = %f",self.willSplitPathArr.count,splitPathCount,slider.value);//11,10
                
                if (currentSplitPathCount == splitPathCount) {
                    if (self.rightPathArr.count == 0)
                    {
                        splitWillFinished = NO;
                    }
                    return;
                }
                else {
                    //更新currentSplitPathCount
                    currentSplitPathCount = splitPathCount;
                    [self.leftPathArr removeAllObjects];
                    [self.rightPathArr removeAllObjects];
                    //小于splitPathCount是前一部分path
                    int i = 0;
                    while (i < self.willSplitPathArr.count) {
                        if (i < currentSplitPathCount)
                        {
                            [self.leftPathArr addObject: self.willSplitPathArr[i]];
                        }
                        else
                        {
                            [self.rightPathArr addObject:self.willSplitPathArr[i]];
                        }
                        i++;
                    }
//                    while (i < currentSplitPathCount) {
//                        [startBezierPathArr addObject: self.willSplitPathArr[i]];
//                        i ++ ;
//                    }
//
//                    self.leftPathArr = startBezierPathArr;
//
//                    int j = self.willSplitPathArr.count;
//                    while (j > currentSplitPathCount) {
//                        [self.rightPathArr addObject:self.willSplitPathArr[j-1]];
//                        j = j -1;
//                    }
                    [self creatNewWillSplitView:self.leftPathArr];

                    if (self.rightPathArr.count == 0)
                    {
                        splitWillFinished = NO;
                    }
                    
                }
                
                
            }
//    }
//    else {
//        return;
//    }
}



-(void)setupScrollView{
    NSLog(@"_iconArray = %@",_iconArray);
    NSLog(@"self.index = %d",self.index);
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 75, ScreenW, ScreenH);
        [self.view addSubview:scrollView];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentSize = CGSizeMake(ScreenW * _iconArray.count, ScreenH);
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [scrollView setContentOffset:CGPointMake(ScreenW * self.index, 0) animated:NO];
        scrollView.delegate = self;
        _scrollView = scrollView;
        
        ///将图片添加到你scrollView
        for (int i = 0 ; i< _iconArray.count; i++) {
            
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(270+ScreenW*i, 1, 490, ScreenH)];
            NSLog(@"imgV = %@",imgV);
            NSLog(@"图片浏览界面的图片地址=%@",_iconArray[i]);
            //url方式加载
            [imgV sd_setImageWithURL:[NSURL URLWithString:_iconArray[i]]];

            imgV.backgroundColor = [UIColor whiteColor];
            [_scrollView addSubview:imgV];
            imgV.userInteractionEnabled = YES;
            
            // 捏合缩放手势
            UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
            
            //[imgV addGestureRecognizer:pinchGestureRecognizer];
            //imgCreatDate
            NSString  *imgCreatDateStr = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"imgCreatDate-%@",_iconArray[i]]];
            if (imgCreatDateStr==nil || [imgCreatDateStr isEqualToString:@""]) {
                //不要直接return 会直接跳出for循环
                //return;
                self.dateLabel.text = @"";
            }else {
                self.dateLabel.text = imgCreatDateStr;

            }
            NSLog(@"%@-%@",_iconArray[i],imgCreatDateStr);
        }
    
        ///当前在第几张
        imgIndex = self.index;
        
}

/// MARK : UISCrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    ///借助此方法知道当前在第几张
    if (fmod (scrollView.contentOffset.x
, 1024.0) == 0 ) {
        
        imgIndex = fabs(scrollView.contentOffset.x) / 1024;
        
        //NSLog(@"当前在第%d张", imgIndex);
    }
}

///处理拆分
//{
//    ///filetotalArr里面的文件数是累加的
//    let bezierPathArr = FileTransferManger.shared.filetotalArr.last
//    
//    let cellImg = self.creatCellImage(bezierPathsArr: bezierPathArr!)
//    let tag:NSInteger = NSInteger(NSDate().timeIntervalSince1970)
//    let url = URL(string: "\(tag)")
//    SDWebImageManager.shared().saveImage(toCache: cellImg, for: url)
//    
//    ///把bezierPathArr里面的path转成Points数组存进UserDefault 因为UserDefault不支持UIbezierPath类型
//    //BezierPathManager.sharedInstance().saveBezierPathArr(toPointsStr2: bezierPathArr, andImgKey: "ink-\(tag)")
//    BezierPathManager.sharedInstance().saveBezierPathArr(toPointsStr2: bezierPathArr, andImgKey: "ink-\(tag)")
//    
//    
//    ///保存图片creatDate
//    UserDefaults.standard.set(self.dateConvertString(date: Date()), forKey: String.init(tag))
//    UserDefaults.standard.synchronize()
//    
//    ///inkImageUrlArray里面的图片url包含本地的缓存和后台咨询单中的http开头的url
//    self.inkImageUrlArray?.append("\(url!)")
//    
//    print("下载结束self.inkImageUrlArray = \(self.inkImageUrlArray)")
//    ///刷新collectionView
//    self.ziXunContentCollectionView.reloadData()
//}

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
