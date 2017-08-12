//
//  TUCurrencyModel.m
//  testUbank
//
//  Created by Aidar on 12.08.17.
//  Copyright © 2017 Aidar Khakimzyanov. All rights reserved.
//

#import "TUCurrencyModel.h"

@interface TUCurrencyModel ()

@property (nonatomic, strong) NSDictionary *currencyToGBP;

@end


@implementation TUCurrencyModel

#pragma mark - Init Methods
- (instancetype)init
{
    self = super.init;
    
    [self getRatesFromDocument];
    
    return self;
}



#pragma mark - Data Source Methods
- (float)getGBPFromCurrency:(NSString *)currency andValue:(float)value
{
    float k = self.currencyToGBP[currency] != nil ? [self.currencyToGBP[currency] floatValue] : 1;
    
    return k*value;
}



#pragma mark - Work With Coming Data
- (void)getRatesFromDocument
{
    NSString *ratesPath = [NSBundle.mainBundle pathForResource:@"rates" ofType:@"plist"];
    
    NSArray *ratesContent = [NSArray arrayWithContentsOfFile:ratesPath];
    
    [self workWithRatesContent:ratesContent];
}


- (void)workWithRatesContent:(NSArray *)ratesContent
{
    NSMutableDictionary *currency = NSMutableDictionary.new;
    
    NSMutableArray *currencyNotFound = NSMutableArray.new;
    
    for (NSDictionary *rate in ratesContent) {
        NSString *from = rate[@"from"];
        NSString *to = rate[@"to"];
        
        float value = [rate[@"rate"] floatValue];
        
        if ([to isEqualToString:@"GBP"]) {
            currency[from] = @(value);
        } else if ([from isEqualToString:@"GBP"] && currency[to] == nil) {
            currency[to] = @(1.0/value);
        } else if (![to isEqualToString:@"GBP"] && ![from isEqualToString:@"GBP"]) {
            if (currency[to] != nil) {
                currency[from] = @(value * [currency[to] floatValue]);
            } else if (currency[from] != nil) {
                currency[to] = @(1.0/value * [currency[from] floatValue]);
            } else {
                [currencyNotFound addObject:rate];
            }
        }
    }
    
    if (currencyNotFound.count > 0) {
        for (NSDictionary *rate in currencyNotFound) {
            NSString *from = rate[@"from"];
            NSString *to = rate[@"to"];
            
            float value = [rate[@"rate"] floatValue];
            
            if (currency[to] != nil) {
                currency[from] = @(value * [currency[to] floatValue]);
            } else if (currency[from] != nil) {
                currency[to] = @(1.0/value * [currency[from] floatValue]);
            } else {
                [currencyNotFound addObject:rate];
            }
        }
    }
    
    self.currencyToGBP = currency.copy;
}

@end
