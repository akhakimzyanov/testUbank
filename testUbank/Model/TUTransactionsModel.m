//
//  TUTransactionsModel.m
//  testUbank
//
//  Created by Aidar on 12.08.17.
//  Copyright © 2017 Aidar Khakimzyanov. All rights reserved.
//

#import "TUTransactionsModel.h"

@interface TUTransactionsModel ()
{
    NSArray *productsSortedKeys;
    
    NSString *currentProductName;
    NSArray *currentProductTransactions;
    NSString *currentProductTransactionsAmount;
    
    NSNumberFormatter *currencyFormatter;
}

@property (nonatomic, strong) NSDictionary *productsSKU;

@property (nonatomic, strong) TUCurrencyModel *currencyModel;

@end


@implementation TUTransactionsModel

#pragma mark - Init Methods
+ (instancetype)shared
{
    static TUTransactionsModel *instance;
    
    @synchronized(self) {
        if (!instance) {
            instance = TUTransactionsModel.new;
            
            instance.currencyModel = TUCurrencyModel.new;
        }
    }
    
    return instance;
}



#pragma mark - Products Data Source Methods
- (NSInteger)getSkuProductsCount
{
    return productsSortedKeys.count;
}

- (NSDictionary *)getSkuProduct:(NSInteger)index
{
    if (index >= 0 && index < self.getSkuProductsCount) {
        NSString *key = productsSortedKeys[index];
        
        return @{@"name": key, @"count": @([self.productsSKU[key] count])};
    }
    
    return nil;
}



#pragma mark - Transaction Data Source Methods
- (void)setCurrentProductIndex:(NSInteger)currentProductIndex
{
    if (index >= 0 && currentProductIndex < self.getSkuProductsCount) {
        currentProductName = productsSortedKeys[currentProductIndex];
        
        NSArray *transactions = self.productsSKU[currentProductName];
        
        float amount = 0;
        
        NSMutableArray *newTransactions = NSMutableArray.new;
        
        currencyFormatter = NSNumberFormatter.new;
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        
        for (NSDictionary *trans in transactions) {
            NSString *firstCurrency = trans[@"currency"];
            
            float firstPrice = [trans[@"amount"] floatValue];
            
            float secondPrice = firstPrice;
            
            if (![firstCurrency isEqualToString:@"GBP"]) {
                secondPrice = [self.currencyModel getGBPFromCurrency:firstCurrency andValue:firstPrice];
            }
            
            amount += secondPrice;
            
            currencyFormatter.currencyCode = firstCurrency;
            
            NSString *first = [currencyFormatter stringFromNumber:@(firstPrice)];
            
            currencyFormatter.currencyCode = @"GBP";
            
            NSString *second = [currencyFormatter stringFromNumber:@(secondPrice)];
            
            [newTransactions addObject:@{@"first": first, @"second": second}];
        }
        
        currentProductTransactionsAmount = [currencyFormatter stringFromNumber:@(amount)];
        
        currentProductTransactions = newTransactions.copy;
    }
}


- (NSString *)currentProductName
{
    return currentProductName;
}


- (NSInteger)getCurrentProductTransactionsCount
{
    if (currentProductTransactions != nil) {
        return currentProductTransactions.count;
    }
    
    return 0;
}


- (NSDictionary *)getTransaction:(NSInteger)index
{
    if (index >= 0 && index < self.getCurrentProductTransactionsCount) {
        return currentProductTransactions[index];
    }
    
    return nil;
}


- (NSString *)getCurrentProductAmount
{
    return currentProductTransactionsAmount;
}



#pragma mark - Work With Coming Data
- (void)loadTransactions
{
    NSString *transactionPath = [NSBundle.mainBundle pathForResource:@"transactions" ofType:@"plist"];
        
    NSArray *transactionContent = [NSArray arrayWithContentsOfFile:transactionPath];
        
    [self workWithTransactionsContent:transactionContent];
}


- (void)workWithTransactionsContent:(NSArray *)transactionsContent
{
    NSMutableDictionary *transactions = NSMutableDictionary.new;
    
    for (NSDictionary *trans in transactionsContent) {
        if (trans[@"sku"] != nil && [trans[@"sku"] isKindOfClass:NSString.class]
            && trans[@"currency"] != nil && [trans[@"currency"] isKindOfClass:NSString.class]
            && trans[@"amount"] != nil && [trans[@"amount"] floatValue] > 0) {
            
            if (transactions[trans[@"sku"]] == nil) {
                transactions[trans[@"sku"]] = NSMutableArray.new;
            }
            
            [transactions[trans[@"sku"]] addObject:trans];
        }
    }
    
    self.productsSKU = transactions.copy;
    
    productsSortedKeys = [transactions.allKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [a compare:b];
    }];
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"TransactionsReady" object:nil];
}

@end
