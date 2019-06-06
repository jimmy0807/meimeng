//
//  BSPrintPosOperateRequestNew.h
//  meim
//
//  Created by jimmy on 17/3/21.
//
//

#import "ICRequest.h"

@interface BSPrintPosOperateRequestNew : ICRequest <UIAlertViewDelegate>

@property(nonatomic, strong)NSNumber* operateID;
@property(nonatomic)BOOL openCashBox;

@property(nonatomic, strong)CDPosWashHand* hand;
@property(nonatomic, strong)CDHJiaoHao* jiaohao;
@property(nonatomic, strong)NSString* printUrl;
@property(nonatomic)BOOL isAfterPayment;
@property(nonatomic)BOOL isYaofang;

@end
