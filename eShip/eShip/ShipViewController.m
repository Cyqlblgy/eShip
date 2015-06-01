//
//  ShipViewController.m
//  eShip
//
//  Created by Bin Lang on 5/31/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "ShipViewController.h"
#import "ShipTableViewCell.h"

@interface ShipViewController ()

@end

@implementation ShipViewController

@synthesize shipInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return shipInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:@"WYSettingsTableViewCell" forIndexPath:indexPath];
    
    ShipTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShipCell"];
    
    if (cell == nil) {
        cell = [[ShipTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShipCell"];
    }
    NSDictionary *textDic = [shipInfo objectAtIndex:indexPath.row];
    int time = [[textDic valueForKey:@"transitDays"] intValue];
    NSString *carrier = [textDic valueForKey:@"carrier"];
    NSDictionary *costDic = [textDic valueForKey:@"rate"];
    cell.costLabel.text = [[NSString alloc] initWithFormat:@"估计费用：%@ %@",[costDic valueForKey:@"amount"],[costDic valueForKey:@"currency"]];
    cell.timeLabel.text = [[NSString alloc] initWithFormat:@"估计运送时间：%d天",time];
    cell.carrierImage.image = [UIImage imageNamed:carrier];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //selectedOne = [list objectAtIndex:indexPath.row];
    //[tableView reloadData];
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
