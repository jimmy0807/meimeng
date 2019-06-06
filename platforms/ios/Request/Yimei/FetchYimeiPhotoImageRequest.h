//
//  FetchYimeiPhotoImageRequest.h
//  ds
//
//  Created by jimmy on 16/11/9.
//
//

#import "ICRequest.h"

@interface FetchYimeiPhotoImageRequest : ICRequest

@property(nonatomic, strong)NSArray* ids;
@property(nonatomic, strong)NSString* requestTableName;
@end
