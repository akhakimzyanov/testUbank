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

- (void)loadTransactions;

@property (nonatomic, getter=getSkuProductsCount, readonly) NSInteger skuProductsCount;
- (NSDictionary *)getSkuProduct:(NSInteger)index;

@property (nonatomic) NSInteger currentProductIndex;

@property (nonatomic, readonly, copy) NSString *currentProductName;
@property (nonatomic, getter=getCurrentProductTransactionsCount, readonly) NSInteger currentProductTransactionsCount;
- (NSDictionary *)getTransaction:(NSInteger)index;
@property (nonatomic, getter=getCurrentProductAmount, readonly, copy) NSString *currentProductAmount;

@end
