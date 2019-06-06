//
//  CDZixunInkOffLinePicture+CoreDataProperties.h
//  meim
//
//  Created by 刘伟 on 2017/12/8.
//
//

#import "CDZixunInkOffLinePicture+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDZixunInkOffLinePicture (CoreDataProperties)

+ (NSFetchRequest<CDZixunInkOffLinePicture *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *downLoadDate;
@property (nullable, nonatomic, copy) NSString *pictureArrStr;

@end

NS_ASSUME_NONNULL_END
