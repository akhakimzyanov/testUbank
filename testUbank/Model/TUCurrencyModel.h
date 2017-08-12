//
//  TUCurrencyModel.h
//  testUbank
//
//  Created by Aidar on 12.08.17.
//  Copyright © 2017 Aidar Khakimzyanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUCurrencyModel : NSObject

- (float)getGBPFromCurrency:(NSString *)currency andValue:(float)value;

@end
