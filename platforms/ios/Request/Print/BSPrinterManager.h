//
//  BSPrinterManager.h
//  meim
//
//  Created by jimmy on 17/3/21.
//
//

#import <Foundation/Foundation.h>

@interface BSPrinterManager : NSObject

InterfaceSharedManager(BSPrinterManager)

@property(nonatomic)BOOL isCashBoxConnected;
@property(nonatomic)BOOL isPrinterConnected;
@property(nonatomic)BOOL isScannerConnected;

@end
