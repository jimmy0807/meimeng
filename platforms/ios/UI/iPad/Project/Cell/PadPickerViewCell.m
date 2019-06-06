//
//  PadPickerViewCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadPickerViewCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"
#import "BSCoreDataManager.h"

@interface PadPickerViewCell ()

@property (nonatomic, strong) NSArray *stores;
@property (nonatomic, strong) NSArray *priceLists;
@property (nonatomic, strong) NSArray *technicians;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *minuteArray;

@end

@implementation PadPickerViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, 0.0, kPadMaskViewContentWidth, kPadPickerViewCellHeight)];
        self.background.backgroundColor = [UIColor clearColor];
        self.background.image = [[UIImage imageNamed:@"pad_picker_view_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        self.background.userInteractionEnabled = YES;
        [self.contentView addSubview:self.background];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:self.background.bounds];
        self.datePicker.backgroundColor = [UIColor clearColor];
        [self.datePicker addTarget:self action:@selector(didDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.background addSubview:self.datePicker];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:self.background.bounds];
        self.pickerView.backgroundColor = [UIColor clearColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.background addSubview:self.pickerView];
    }
    
    return self;
}

- (void)reloadDatePickerWithDate:(NSDate *)date
{
    if (date)
    {
        self.datePicker.date = date;
    }
    else
    {
        self.datePicker.date = [NSDate date];
    }
    self.type = kDatePickerSelectDate;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.alpha = 1.0;
    self.pickerView.alpha = 0.0;
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd";
    //    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    //    NSDate *minDate = [dateFormatter dateFromString:datestr];
    //    self.datePicker.minimumDate = minDate;
}

- (void)reloadPickerViewWithStores:(NSArray *)stores
{
    self.stores = stores;
    self.type = kPickerViewSelectStore;
    self.datePicker.alpha = 0.0;
    self.pickerView.alpha = 1.0;
    [self.pickerView reloadAllComponents];
}

- (void)reloadPickerViewWithPriceLists:(NSArray *)priceLists
{
    self.priceLists = priceLists;
    self.type = kPickerViewSelectPriceList;
    self.datePicker.alpha = 0.0;
    self.pickerView.alpha = 1.0;
    [self.pickerView reloadAllComponents];
}

- (void)reloadPickerViewWithTechnicians:(NSArray *)technicians
{
    self.type = kPickerViewSelectTechnician;
    self.technicians = technicians;
    for (int i = 0; i < self.technicians.count; i++)
    {
        CDStaff *staff = [self.technicians objectAtIndex:i];
        NSArray *books = [[BSCoreDataManager currentManager] fetchLatestBooksWithTechnician:staff];
        staff.latestBookTime = LS(@"PadTechnicianNoReservation");
        if (books.count != 0)
        {
            CDBook *latestBook = [books objectAtIndex:0];
            if (latestBook && latestBook.start_date.length >= 16 && latestBook.end_date.length >= 16)
            {
                staff.latestBookTime = [NSString stringWithFormat:LS(@"PadTechnicianLatestReservation"), [latestBook.start_date substringWithRange:NSMakeRange(11, 5)], [latestBook.end_date substringWithRange:NSMakeRange(11, 5)]];
            }
        }
    }
    self.datePicker.alpha = 0.0;
    self.pickerView.alpha = 1.0;
    [self.pickerView reloadAllComponents];
}

- (void)reloadPickerViewWithDateAndTime:(NSDate *)date
{
    self.date = date;
    self.type = kPickerViewSelectDateAndTime;
    self.datePicker.alpha = 0.0;
    self.pickerView.alpha = 1.0;
    [self.pickerView reloadAllComponents];
}


#pragma mark -
#pragma mark Required Methods

- (void)didDatePickerValueChanged:(id)sender
{
    if (self.type == kDatePickerSelectDate)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:selectedDate:)])
        {
            [self.delegate datePicker:self selectedDate:self.datePicker.date];
        }
    }
}


#pragma mark -
#pragma mark UIPickerViewDataSource && UIPickerViewDelegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.type == kPickerViewSelectDateAndTime)
    {
        return 2;
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.type == kPickerViewSelectStore)
    {
        return self.stores.count;
    }
    else if (self.type == kPickerViewSelectPriceList)
    {
        return self.priceLists.count;
    }
    else if (self.type == kPickerViewSelectTechnician)
    {
        return self.technicians.count + 1;
    }
    else if (self.type == kPickerViewSelectDateAndTime)
    {
        if (component == 0)
        {
            return 24;
        }
        else if (component == 1)
        {
            return 60;
        }
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.type == kPickerViewSelectStore || self.type == kPickerViewSelectPriceList || self.type == kPickerViewSelectTechnician)
    {
        return self.pickerView.frame.size.width;
    }
    else if (self.type == kPickerViewSelectDateAndTime)
    {
        return 72.0;
    }
    
    return 0.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 48.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.type == kPickerViewSelectStore)
    {
        CDStore *store = [self.stores objectAtIndex:row];
        return store.storeName;
    }
    else if (self.type == kPickerViewSelectPriceList)
    {
        CDMemberPriceList *priceList = [self.priceLists objectAtIndex:row];
        return [NSString stringWithFormat:LS(@"PadPriceListStartAmount"), priceList.name, priceList.start_money.integerValue];
    }
    else if (self.type == kPickerViewSelectTechnician)
    {
        if ( row == self.technicians.count )
        {
            return @"无";
        }
        
        CDStaff *staff = [self.technicians objectAtIndex:row];
        return [NSString stringWithFormat:@"%@(%@)", staff.name, staff.latestBookTime];
    }
    else if (self.type == kPickerViewSelectDateAndTime)
    {
        if (component == 0)
        {
            return [NSString stringWithFormat:@"%2d", row];
        }
        else if (component == 1)
        {
            return [NSString stringWithFormat:@"%02d", row];
        }
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.type == kPickerViewSelectStore)
    {
        if (row >= self.stores.count)
        {
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selectedStore:)])
        {
            CDStore *store = [self.stores objectAtIndex:row];
            [self.delegate pickerView:self selectedStore:store];
        }
    }
    else if (self.type == kPickerViewSelectPriceList)
    {
        if (row >= self.priceLists.count)
        {
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selectedPriceList:)])
        {
            CDMemberPriceList *priceList = [self.priceLists objectAtIndex:row];
            [self.delegate pickerView:self selectedPriceList:priceList];
        }
    }
    else if (self.type == kPickerViewSelectTechnician)
    {
        if (row >= self.technicians.count + 1)
        {
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selectedTechnician:)])
        {
            if ( row == self.technicians.count )
            {
                [self.delegate pickerView:self selectedTechnician:nil];
            }
            else
            {
                CDStaff *technician = [self.technicians objectAtIndex:row];
                [self.delegate pickerView:self selectedTechnician:technician];
            }
        }
    }
    else if (self.type == kPickerViewSelectDateAndTime)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
        datestr = [NSString stringWithFormat:@"%@ %d:%d:00", datestr, [self.pickerView selectedRowInComponent:0], [self.pickerView selectedRowInComponent:1]];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.date = [dateFormatter dateFromString:datestr];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selectedDateAndTime:)])
        {
            [self.delegate pickerView:self selectedDateAndTime:self.date];
        }
    }
}

@end
