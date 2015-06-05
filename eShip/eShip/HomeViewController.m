//
//  HomeViewController.m
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "HomeViewController.h"
#import "FindViewController.h"
#import "TheSidebarController.h"
#import "LeftViewController.h"
#import "MapViewController.h"

@interface HomeViewController ()<TheSidebarControllerDelegate>

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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"mapID"]){
        MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
        
        LeftViewController *leftViewController = [[LeftViewController alloc] init];
        leftViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"left-sidebar"]];
        
        TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:mapVC leftSidebarViewController:leftViewController];
        sidebarController.navigationItem.title = @"eShip";
        sidebarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:mapVC action:@selector(goBack)];
        sidebarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:mapVC action:@selector(showLeftSide)];
        sidebarController.delegate = mapVC;
        sidebarController.view.backgroundColor = [UIColor blackColor];// colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        [self.navigationController pushViewController:sidebarController animated:NO];
        return NO;
    }
    else{
        return YES;
    }
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
