//
//  YimeiSignAfterOperationViewController.m
//  ds
//
//  Created by jimmy on 16/11/9.
//
//

#import "YimeiSignAfterOperationViewController.h"
#import "SignDrawingNameView.h"
#import "UploadPicToZimg.h"
#import "MBProgressHUD.h"
#import "BSYimeiEditPosOperateRequest.h"
#import "UIImage+Scale.h"
#import "CBLoadingView.h"
#import "EditWashHandRequest.h"

@interface YimeiSignAfterOperationViewController ()<SignDrawingNameViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *queueLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *designerLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *itemScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *signFinalImgeView;
@property (nonatomic, strong)SignDrawingNameView* signView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property(nonatomic, strong) NSArray *posProducts;
@end

@implementation YimeiSignAfterOperationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self forbidSwipGesture];
    
    self.nameLabel.text = self.washHand.sign_member_name;
    self.queueLabel.text = self.washHand.yimei_queueID;
    self.designerLabel.text = self.washHand.yimei_shejishiName;
    self.doctorLabel.text = self.washHand.doctor_name;
    self.operatorLabel.text = self.washHand.yimei_operate_employee_name;
    self.categoryLabel.text = self.washHand.keshi_name;
    
    if ( [self.washHand.remark isEqualToString:@"0"] )
    {
        self.remarkLabel.text = @"";
    }
    else
    {
        self.remarkLabel.text = self.washHand.remark;
    }
    
    [self reloadProducts];

    [self addSignView];
    
    [self registerNofitificationForMainThread:kEditWashHandResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kEidtPosOperateResponse] || [notification.name isEqualToString:kEditWashHandResponse]  )
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            if ( self.YimeiSignAfterOperationViewControllerFinished )
            {
                self.YimeiSignAfterOperationViewControllerFinished();
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
            self.washHand.yimei_sign_after = @"";
            [[BSCoreDataManager currentManager] save:nil];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
//    else if ( [notification.name isEqualToString:kEditWashHandResponse] )
//    {
//        //[self reloadProducts];
//        if ( self.YimeiSignAfterOperationViewControllerFinished )
//        {
//            self.YimeiSignAfterOperationViewControllerFinished();
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }
    
}

- (void)reloadProducts
{
#if 0
    __block CGFloat totalLength = 0;
    
    NSMutableString* categoryString = [[NSMutableString alloc] init];
    self.posProducts = self.operate.products.array;//[[BSCoreDataManager currentManager] fetchPosProductsWithOperate:self.operate];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [self.posProducts enumerateObjectsUsingBlock:^(CDPosProduct*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:obj.product_id forKey:@"itemID"];
        if ( [item.bornCategory integerValue] == kPadBornCategoryProject )
        {
            UILabel* title = [[UILabel alloc] initWithFrame:CGRectZero];
            title.textColor = COLOR(106, 106, 106, 1);
            title.font = [UIFont systemFontOfSize:13];
            if ( obj.part_display_name.length == 0 )
            {
                title.text = obj.product_name;
            }
            else
            {
                title.text = [NSString stringWithFormat:@"%@(%@)",obj.product_name,obj.part_display_name];
            }
            
            CGSize minSize = [title.text sizeWithFont:[UIFont boldSystemFontOfSize:13.0] constrainedToSize:CGSizeMake(3000.0, 20) lineBreakMode:NSLineBreakByWordWrapping];
            
            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0 + totalLength, 0, 24 + minSize.width, 24)];
            v.layer.masksToBounds = YES;
            v.layer.cornerRadius = 3;
            v.backgroundColor = COLOR(242, 242, 242, 1);
            [v addSubview:title];
            title.frame = CGRectMake(12, 0, minSize.width, v.frame.size.height);
            
            [self.itemScrollView addSubview:v];
            
            totalLength = totalLength + 8 + 24 + minSize.width;
            
            if ( item.categoryName.length > 0 && ![item.categoryName isEqualToString:@"全部"] && ![item.categoryName isEqualToString:@"其他"] )
            {
                if ( params[item.categoryName] )
                    return;
                
                [params setObject:@(TRUE) forKey:item.categoryName];
                if ( categoryString.length == 0 )
                {
                    [categoryString appendString:item.categoryName];
                }
                else
                {
                    [categoryString appendFormat:@"、%@",item.categoryName];
                }
            }
        }
    }];
    
    self.categoryLabel.text = categoryString;
    self.itemScrollView.contentSize = CGSizeMake(totalLength, self.itemScrollView.contentSize.height);
#endif
}

- (void)addSignView
{
    self.signView = [[SignDrawingNameView alloc] initWithFrame:CGRectMake(70, 465, 585, 293)];
    self.signView.delegate = self;
    [self.view addSubview:self.signView];
    
    [self.view bringSubviewToFront:self.confirmButton];
}

- (void)beginToDraw
{
    self.signFinalImgeView.image = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayToShowFinalImage) object:nil];
}

- (void)endDraw
{
    [self performSelector:@selector(delayToShowFinalImage) withObject:nil afterDelay:1];
}

- (void)delayToShowFinalImage
{
    if ( self.signFinalImgeView.image == nil )
    {
        self.signFinalImgeView.image = self.signView.savedImage;
    }
    
    [self.signView clear];
}

- (IBAction)didConfirmButtonPressed:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayToShowFinalImage) object:nil];
    [self delayToShowFinalImage];
    
    if ( !self.signFinalImgeView.image )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请先签名" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        return;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat imageDestWidth = imageWidth;
    CGFloat imageDestHeight = imageHeight;
    if (imageWidth > 320)
    {
        imageDestWidth = 320;
        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    }
    
    UIImage* compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text = @"正在上传签名 请稍后...";
    
    UploadPicToZimg* v = [UploadPicToZimg alloc];
    [v uploadPic:compressedImage finished:^(BOOL ret, NSString *urlString)
    {
         if ( ret )
         {
             self.washHand.yimei_sign_after = urlString;
             [self.params setObject:urlString forKey:@"after_sign_image"];
             
             EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
             request.params = self.params;
             request.wash = self.washHand;
             [request execute];
             
             HUD.label.text = @"正在提交数据 请稍后...";
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"图片上传失败,请稍后再试"
                                                                delegate:nil
                                                       cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                       otherButtonTitles:nil, nil];
             [alertView show];
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
     }];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    self.YimeiSignAfterOperationViewControllerCancel();
}

@end
