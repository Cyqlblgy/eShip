//
//  HomeViewController.m
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "HomeViewController.h"
#import "FindViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize imageView,checkingView,shippingView,mapView,trackingView;
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = imageView.frame;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    trackingView.frame = CGRectMake(0, rect.origin.y+rect.size.height, rect.size.width/2, (screenFrame.size.height-40-rect.origin.y-rect.size.height)/2);
    checkingView.frame = CGRectMake(rect.size.width/2, rect.origin.y+rect.size.height, rect.size.width/2, (screenFrame.size.height-40-rect.origin.y-rect.size.height)/2);
    shippingView.frame = CGRectMake(0, (screenFrame.size.height-40+ rect.origin.y+rect.size.height)/2, rect.size.width/2, (screenFrame.size.height-40-rect.origin.y-rect.size.height)/2);
    mapView.frame = CGRectMake(rect.size.width/2, (screenFrame.size.height-40+ rect.origin.y+rect.size.height)/2, rect.size.width/2, (screenFrame.size.height-40-rect.origin.y-rect.size.height)/2);
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController navigationBar].hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
