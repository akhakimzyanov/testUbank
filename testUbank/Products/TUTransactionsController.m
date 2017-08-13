//
//  TUTransactionsController.m
//  testUbank
//
//  Created by Aidar on 12.08.17.
//  Copyright © 2017 Aidar Khakimzyanov. All rights reserved.
//

#import "TUTransactionsController.h"

@implementation TUTransactionsController

#pragma mark - View Init Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Transactions for %@", TUTransactionsModel.shared.currentProductName];
}



#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TUTransactionsModel.shared.getCurrentProductTransactionsCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell"];
    
    NSDictionary *ds = [TUTransactionsModel.shared getTransaction:indexPath.row];

    if (ds != nil) {
        cell.textLabel.text = ds[@"first"];
        cell.detailTextLabel.text = ds[@"second"];
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return TUTransactionsModel.shared.getCurrentProductAmount;
}

@end
