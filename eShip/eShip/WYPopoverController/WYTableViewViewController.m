//
//  WYTableViewViewController.m
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "WYTableViewViewController.h"

@interface WYTableViewViewController (){
    NSArray *carrierList;
}

@end

@implementation WYTableViewViewController

@synthesize selectedCarrier;

- (void)viewDidLoad {
    [super viewDidLoad];
    carrierList = [[NSArray alloc] initWithObjects:@"申通",@"圆通",@"FedEX",@"UPS",@"韵达", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return carrierList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:@"WYSettingsTableViewCell" forIndexPath:indexPath];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CarrierListCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarrierListCell"];
    }
    NSString *rowText = [carrierList objectAtIndex:indexPath.row];
    cell.textLabel.text = rowText;
    if([selectedCarrier isEqualToString:rowText]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedCarrier = [carrierList objectAtIndex:indexPath.row];
    [tableView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
