//
//  RateResultViewController.m
//  eShip
//
//  Created by Bin Lang on 5/31/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "RateResultViewController.h"
#import "ShipTableViewCell.h"
#import "ContactViewController.h"

@interface RateResultViewController (){
    int counter;
    NSMutableArray *realInfo;
}

@end

@implementation RateResultViewController

@synthesize shipInfo,rateObject,mytableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    realInfo = [[NSMutableArray alloc] init];
    for(int i = 0; i<shipInfo.count; i++){
        NSDictionary *info = [shipInfo objectAtIndex:i];
        if(![[info valueForKey:@"carrier"] isKindOfClass:[NSNull class]] && ![[info valueForKey:@"rate"] isKindOfClass:[NSNull class]] && ![[info valueForKey:@"transitDays"] isKindOfClass:[NSNull class]]){
            [realInfo addObject:info];
        }
    }
    self.navigationItem.title = @"查询结果";
    CGRect frame = mytableView.frame;
    mytableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 100*(realInfo.count+1));
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
    return realInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:@"WYSettingsTableViewCell" forIndexPath:indexPath];
    
    ShipTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShipCell"];
    
    if (cell == nil) {
        cell = (ShipTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ShipTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    NSDictionary *textDic = [realInfo objectAtIndex:indexPath.row];
    int time = [[textDic valueForKey:@"transitDays"] intValue];
    NSString *carrier = [textDic valueForKey:@"carrier"];
    NSDictionary *costDic = [textDic valueForKey:@"rate"];
    cell.costLabel.text = [[NSString alloc] initWithFormat:@"估计费用：%@ %@",[costDic valueForKey:@"amount"],[costDic valueForKey:@"currency"]];
    cell.timeLabel.text = [[NSString alloc] initWithFormat:@"估计运送时间：%d天",time];
    cell.carrierImage.image = [UIImage imageNamed:carrier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactViewController *contactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"contactVC"];
    contactVC.rateObject = rateObject;
    NSDictionary *textDic = [realInfo objectAtIndex:indexPath.row];
    contactVC.shipCarrier = [textDic valueForKey:@"carrier"];
    [self.navigationController pushViewController:contactVC animated:YES];
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
