//
//  TrackResultViewController.m
//  eShip
//
//  Created by Bin Lang on 7/5/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "TrackResultViewController.h"
#import "TrackingDetailViewController.h"

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
    bview.backgroundColor = [self colorWithHexString:@"D1EEFC"];
    pView.color = [self colorWithHexString:@"5BCAFF"];
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

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
