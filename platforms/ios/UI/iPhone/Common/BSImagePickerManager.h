//
//  BSImagePickerManager.h
//  Boss
//
//  Created by lining on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol BSImagePickerManagerDelegate <NSObject>
-(void)didSelectedImage:(UIImage *)image;
@end

@interface BSImagePickerManager : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
+(instancetype)shareManager;
-(void)startImagePickerWithType:(UIImagePickerControllerSourceType)sourceType delegate:(id<BSImagePickerManagerDelegate>)delegate allowEdit:(BOOL)edit;

@property(nonatomic, weak) id<BSImagePickerManagerDelegate>delegate;
@end
