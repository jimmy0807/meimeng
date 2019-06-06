//
//  FetchHPatientRequest.h
//  meim
//
//  Created by jimmy on 2017/4/28.
//
//

#import "ICRequest.h"

@interface FetchHPatientRequest : ICRequest

@property(nonatomic, strong)NSString* keyword;
@property(nonatomic, strong)NSString* categoryString;
@property(nonatomic, strong)NSString* type;
@property(nonatomic)HPatientListType listType;
@property(nonatomic)BOOL isMyPatient;
@property(nonatomic)NSInteger offset;

@end
