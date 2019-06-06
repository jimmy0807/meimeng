//
//  TemplateListViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "QRCodeView.h"
#import "BNScanCodeViewController.h"


@interface TemplateListViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, QRCodeViewDelegate, BNScanCodeDelegate>

- (id)initWithProjectTemplate:(CDProjectTemplate *)projectTemplate;

@end
