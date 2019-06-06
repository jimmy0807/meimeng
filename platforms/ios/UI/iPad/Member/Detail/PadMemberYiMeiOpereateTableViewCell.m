//
//  PadMemberYiMeiOpereateTableViewCell.m
//  ds
//
//  Created by jimmy on 16/10/21.
//
//

#import "PadMemberYiMeiOpereateTableViewCell.h"

@interface PadMemberYiMeiOpereateTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* operateNameLabel;
@property(nonatomic, weak)IBOutlet UILabel* priceLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeLabel;
@property(nonatomic, weak)IBOutlet UIImageView* arrowImageView;
@property(nonatomic, weak)IBOutlet UILabel* itemLabel;
@property(nonatomic, weak)IBOutlet UILabel* doctorLabel;
@property(nonatomic, weak)IBOutlet UILabel* buweiLabel;
@property(nonatomic, strong)NSArray* posProducts;
@property(nonatomic, weak)IBOutlet UIImageView* photoImageView;
@property(nonatomic, weak)IBOutlet UILabel* uploadNameLabel;
@property(nonatomic, weak)IBOutlet UILabel* uploadTimeLabel;
@property(nonatomic, weak)IBOutlet UITextView* remarkDisplayTextView;

///消费记录术后照
@property (weak, nonatomic) IBOutlet UIImageView *afterphotoImageView;

@end

@implementation PadMemberYiMeiOpereateTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    
    self.operateNameLabel.text = [NSString stringWithFormat:@"%@-%@",operate.name, LS(operate.type)];
    self.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), operate.nowAmount.floatValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *operateDate = [dateFormatter dateFromString:operate.operate_date];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    self.timeLabel.text = [dateFormatter stringFromDate:operateDate];
    
    NSMutableString *itemString = [[NSMutableString alloc] init];
//    self.posProducts = [[BSCoreDataManager currentManager] fetchPosProductsWithOperate:operate];
//    [self.posProducts enumerateObjectsUsingBlock:^(CDPosProduct*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ( idx == 0 )
//        {
//            [itemString appendString:@"项目:  "];
//        }
//        
//        [itemString appendString:obj.product_name];
//        
//        if ( idx != self.posProducts.count - 1 )
//        {
//            [itemString appendString:@"、"];
//        }
//    }];
#if 0
    self.itemLabel.text = operate.consume_product_names;
    
    if ( operate.doctor_name.length > 0 )
    {
        self.doctorLabel.text = [NSString stringWithFormat:@"医生: %@",operate.doctor_name];
    }
#endif
    
    self.remarkDisplayTextView.text = operate.display_remark;
    
    for ( CDOperateActivity* a in operate.yimei_activity )
    {
        if ( [a.role integerValue] == YimeiWorkFlow_TakePhoto )
        {
            self.uploadNameLabel.text = a.userName;
            self.uploadTimeLabel.text = a.time;
            break;
        }
    }
    
    ///设置术前照
    NSArray* imageArray = self.operate.yimei_before.array;
    
    if ( imageArray.count > 0 )
    {
        for (CDYimeiImage* image in imageArray)
        {
            if ([image.take_time isEqualToString:@"before"]) {
                [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:image.url]];
                break;
            }
        }
        //CDYimeiImage* image = imageArray[0];
    }
    else
    {
        self.photoImageView.image = nil;
    }
    
    ///设置术后照
    NSArray* afterImageArray = self.operate.yimei_before.array;
    
    if ( afterImageArray.count > 0 )
    {
        for (CDYimeiImage* image in afterImageArray)
        {
            if ([image.take_time isEqualToString:@"after"]) {
                [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:image.url]];
                break;
            }
        }
//        CDYimeiImage* image = imageArray[0];
//        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:image.url]];
    }
    else
    {
        self.photoImageView.image = nil;
    }
}

- (void)setExpand:(BOOL)expand
{
    if ( expand )
    {
        self.arrowImageView.image = [UIImage imageNamed:@"common_arrwo_up"];
    }
    else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"common_arrwo_down"];
    }
}


- (IBAction)didPhotoButtonPressed:(id)sender
{
    [self.delegate didPhotoButtonPressed:self];
}

- (IBAction)didAfterPhotoButtonPressed:(UIButton *)sender {
    [self.delegate didAfterPhotoButtonPressed:self];
}


@end
