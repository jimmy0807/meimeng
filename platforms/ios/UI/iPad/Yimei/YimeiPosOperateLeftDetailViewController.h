//
//  YimeiPosOperateLeftDetailViewController.h
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import <UIKit/UIKit.h>

@protocol YimeiPosOperateLeftDetailViewControllerDelegate <NSObject>
- (void)didYimeiPosOperateLeftDetailViewBackButtonPressed;
- (void)didYimeiPosOperateLeftDetailViewtakePhotoButtonPressed;
- (void)didYimeiPosOperateLeftDetailViewPhotoAdded;
- (void)showYimeiSignAfterOperationViewController:(NSMutableDictionary*)params;
- (void)showBrowser;
@end

@interface YimeiPosOperateLeftDetailViewController : UIViewController

@property(nonatomic, weak)id<YimeiPosOperateLeftDetailViewControllerDelegate> delegate;
@property(nonatomic, strong)CDPosWashHand* washHand;

- (void)signFinished;
- (void)takePhotoByPad;
- (void)savePhotoByCamera:(UIImage *)image;
- (void)savePhotoByCamera:(UIImage *)image subImage:(UIImage*)subImage;
- (void)savePhotoByCameraWitBigUrl:(NSString *)url subImage:(UIImage*)subImage;
- (void)savePhotoByCameraWitBigUrl:(NSString *)url subImageUrl:(NSString*)subImageUrl;
- (void)selectPhotoFromCamera;

@end
