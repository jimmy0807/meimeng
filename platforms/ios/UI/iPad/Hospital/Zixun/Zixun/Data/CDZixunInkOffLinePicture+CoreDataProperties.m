//
//  CDZixunInkOffLinePicture+CoreDataProperties.m
//  meim
//
//  Created by 刘伟 on 2017/12/8.
//
//

#import "CDZixunInkOffLinePicture+CoreDataProperties.h"

@implementation CDZixunInkOffLinePicture (CoreDataProperties)

+ (NSFetchRequest<CDZixunInkOffLinePicture *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZixunInkOffLinePicture"];
}

@dynamic downLoadDate;
@dynamic pictureArrStr;

@end
