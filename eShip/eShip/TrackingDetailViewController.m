//
//  TrackingDetailViewController.m
//  eShip
//
//  Created by Bin Lang on 5/23/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "TrackingDetailViewController.h"
#import "TrackingDetailViewModel.h"

@interface TrackingDetailViewController (){
    NSMutableArray *events;
    NSMutableString *deliverDate;
    NSMutableString *shipDate;
    NSString *trackingNumber;
    NSString *status;
    NSDateFormatter *dateFormatter;
}

@end

@implementation TrackingDetailViewController

@synthesize carrier,CarrierAndNumberLabel,deliverDateLabel,shipDateLabel,parcelDetail,statusLabel,scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
     [self parseParcelDetail];
    CarrierAndNumberLabel.text = [[NSString alloc] initWithFormat:@"%@  :  %@",carrier,trackingNumber];
    statusLabel.text = [[NSString alloc] initWithFormat:@"最新状态  :  %@", status];
    deliverDateLabel.text = [[NSString alloc] initWithFormat:@"投递时间  :  %@", deliverDate];
    shipDateLabel.text = [[NSString alloc] initWithFormat:@"寄出时间  :  %@", shipDate];
}


- (void)viewWillDisappear:(BOOL)animated{
    [self resetParams];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetParams{
    deliverDate = nil;
    shipDate = nil;
    trackingNumber = nil;
    events = nil;
    status = nil;
}

- (void)parseParcelDetail{
    trackingNumber = [parcelDetail valueForKey:@"trackingNum"];
    shipDate = [parcelDetail valueForKey:@"shipDate"];
    deliverDate = [parcelDetail valueForKey:@"deliverDate"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *sDate = [dateFormatter dateFromString:shipDate];
    NSDate *dDate = [dateFormatter dateFromString:deliverDate];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    shipDate = [[dateFormatter stringFromDate:sDate] mutableCopy];
    deliverDate = [[dateFormatter stringFromDate:dDate] mutableCopy];
    events = [parcelDetail valueForKey:@"events"];
    status = [parcelDetail valueForKey:@"status"];
    for(int i = 0; i< [events count]; i++){
        TrackingDetailViewModel *view = [[TrackingDetailViewModel alloc] initWithFrame:CGRectMake(50, i*150, scrollView.frame.size.width-100, 130) andParams:[events objectAtIndex:i]];
       // view.backgroundColor = [UIColor greenColor];
       // scrollView.backgroundColor = [UIColor blueColor];
        [scrollView addSubview:view];
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
