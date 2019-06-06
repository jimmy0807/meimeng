//
//  ZixunImgBrowserVC.h
//  meim
//
//  Created by 刘伟 on 2017/12/11.
//  

#import <UIKit/UIKit.h>



typedef void(^RemoveBtnBlock)(NSInteger imgIndex, NSString *imgUrl);
typedef void(^SplitFinished)(NSArray *leftArr, NSArray *rightSArr , NSString *key);


@interface ZixunImgBrowserVC : ICCommonViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

///图片数组
@property(nonatomic,strong)NSArray *iconArray;

///当前点击的下标
@property(assign,nonatomic)NSInteger index;

///删除BtnBlock 用来删除CloundVC和ZixunDetailRightZixunContentVC数据源
@property(copy,nonatomic)RemoveBtnBlock removebtnBlock;

///知道是从哪里进来的
@property (strong,nonatomic) NSString *lookImgFrom;

///拆分完成block
@property(copy,nonatomic)SplitFinished splitFinished;


@end
