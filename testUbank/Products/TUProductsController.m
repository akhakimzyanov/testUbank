//
//  TUProductsController.m
//  testUbank
//
//  Created by Aidar on 12.08.17.
//  Copyright © 2017 Aidar Khakimzyanov. All rights reserved.
//

#import "TUProductsController.h"

@interface TUProductsController ()

@end


@implementation TUProductsController

#pragma mark - View Init Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TUTransactionsModel shared];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(dataSourceChanged)
                                               name:@"TransactionsReady"
                                             object:nil];
}


- (void)dataSourceChanged
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}



#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TUTransactionsModel.shared.getSkuProductsCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    
    NSDictionary *ds = [TUTransactionsModel.shared getSkuProduct:indexPath.row];
    
    if (ds != nil) {
        cell.textLabel.text = ds[@"name"];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ transactions", ds[@"count"]];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TUTransactionsModel.shared.currentProductIndex = self.tableView.indexPathForSelectedRow.row;
}

@end
