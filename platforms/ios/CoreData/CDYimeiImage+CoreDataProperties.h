//
//  CDYimeiImage+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/20.
//
//

#import "CDYimeiImage+CoreDataClass.h"
@class CDMemberVisit,CDPosWashHand,CDZixun,CDHHuizhen;

NS_ASSUME_NONNULL_BEGIN

@interface CDYimeiImage (CoreDataProperties)

+ (NSFetchRequest<CDYimeiImage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *imageID;
@property (nullable, nonatomic, copy) NSString *small_url;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *take_time;
@property (nullable, nonatomic, copy) NSString *bigImageUrl;
@property (nullable, nonatomic, retain) CDPosOperate *before;
@property (nullable, nonatomic, retain) CDMemberVisit *huifang;
@property (nullable, nonatomic, retain) CDPartner *partner;
@property (nullable, nonatomic, retain) CDPosWashHand *washhand;
@property (nullable, nonatomic, retain) CDZixun *zixun;
@property (nullable, nonatomic, retain) CDHHuizhen *huizhen;

@end

NS_ASSUME_NONNULL_END
