//
//  UploadPicToZimg.h
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define UploadPicToZimgUrl @"http://devimg.we-erp.com/"
#else
#define UploadPicToZimgUrl @"http://image.we-erp.com/"
#endif

@interface UploadPicToZimg : NSObject

- (void)uploadPic:(UIImage*)image finished:(void (^)(BOOL ret, NSString* urlString))finished;
- (void)uploadPic:(UIImage*)image withWorkFlowId:(int)workflowId finished:(void (^)(BOOL ret, NSString* urlString))finished;
- (void)uploadPic:(UIImage*)image withTakeTime:(NSString *)takeTime finished:(void (^)(BOOL ret, NSString* urlString))finished;

@end
