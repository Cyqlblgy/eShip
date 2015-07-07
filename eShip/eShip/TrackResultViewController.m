//
//  TrackResultViewController.m
//  eShip
//
//  Created by Bin Lang on 7/5/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "TrackResultViewController.h"
#import "TrackingDetailViewController.h"
#import "ColorHelper.h"

@implementation TrackResultViewController

@synthesize pView,trackingNumber,latestStatus;

-(void)viewDidLoad{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"快递追踪";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"追踪" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"详细信息" style:UIBarButtonItemStylePlain target:self action:@selector(goNext)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    trackingNumber.text = [[NSString alloc] initWithFormat:@"%@:%@",_carrier,_fakeNumber];
    latestStatus.text = @"最新状态 : 已投递";
    UILabel *bview = [[UILabel alloc] initWithFrame:CGRectMake(pView.frame.origin.x+10, pView.frame.origin.y+10, 180, 180)];
    [bview setText:@"100%"];
    bview.layer.cornerRadius = 90;
    bview.layer.masksToBounds = YES;
    bview.textAlignment = NSTextAlignmentCenter;
    bview.textColor = [UIColor lightGrayColor];
    bview.font = [UIFont fontWithName:@"Arial" size:40];
    bview.backgroundColor = [ColorHelper colorWithHexString:@"D1EEFC"];
    pView.color = [ColorHelper colorWithHexString:@"5BCAFF"];
    pView.value = 1.0;
    [self.view addSubview:bview];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goNext{
    TrackingDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"trackDetailVC"];
    vc.fakeNumber = _fakeNumber;
    vc.carrier = _carrier;
    [self.navigationController pushViewController:vc animated:NO];
}


@end
