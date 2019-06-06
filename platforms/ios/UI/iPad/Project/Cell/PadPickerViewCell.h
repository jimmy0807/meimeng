//
//  PadPickerViewCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPadPickerViewCellHeight      272.0

typedef enum kPickerViewType
{
    kDatePickerSelectDate,
    kPickerViewSelectStore,
    kPickerViewSelectPriceList,
    kPickerViewSelectTechnician,
    kPickerViewSelectDateAndTime
}kPickerViewType;


@class PadPickerViewCell;
@protocol PadPickerViewCellDelegate <NSObject>

@optional
- (void)datePicker:(PadPickerViewCell *)cell selectedDate:(NSDate *)date;
- (void)pickerView:(PadPickerViewCell *)cell selectedStore:(CDStore *)store;
- (void)pickerView:(PadPickerViewCell *)cell selectedPriceList:(CDMemberPriceList *)priceList;
- (void)pickerView:(PadPickerViewCell *)cell selectedTechnician:(CDStaff *)technician;
- (void)pickerView:(PadPickerViewCell *)cell selectedDateAndTime:(NSDate *)date;

@end

@interface PadPickerViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) kPickerViewType type;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<PadPickerViewCellDelegate> delegate;

- (void)reloadDatePickerWithDate:(NSDate *)date;
- (void)reloadPickerViewWithStores:(NSArray *)stores;
- (void)reloadPickerViewWithPriceLists:(NSArray *)priceLists;
- (void)reloadPickerViewWithTechnicians:(NSArray *)technicians;
- (void)reloadPickerViewWithDateAndTime:(NSDate *)date;

@end
