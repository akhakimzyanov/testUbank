//
//  TUTransactionsModel.h
//  testUbank
//
//  Created by Aidar on 12.08.17.
//  Copyright © 2017 Aidar Khakimzyanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TUCurrencyModel.h"

@interface TUTransactionsModel : NSObject

+ (instancetype)shared;

- (NSInteger)getSkuProductsCount;
- (NSDictionary *)getSkuProduct:(NSInteger)index;

@property (nonatomic) NSInteger currentProductIndex;

- (NSString *)currentProductName;
- (NSInteger)getCurrentProductTransactionsCount;
- (NSDictionary *)getTransaction:(NSInteger)index;
- (NSString *)getCurrentProductAmount;

@end
