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
    NSDateFormatter *dateFormatter, *newDateFormatter;
}

@end

@implementation TrackingDetailViewController

@synthesize carrier,CarrierAndNumberLabel,deliverDateLabel,shipDateLabel,parcelDetail,statusLabel,scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    newDateFormatter = [[NSDateFormatter alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
     //[self parseParcelDetail];
    [self fakeData];
    CarrierAndNumberLabel.frame = CGRectMake(5, CarrierAndNumberLabel.frame.origin.y, self.view.frame.size.width/2-5, CarrierAndNumberLabel.frame.size.height);
    CarrierAndNumberLabel.text = [[NSString alloc] initWithFormat:@"%@:%@",carrier,trackingNumber];
    statusLabel.frame = CGRectMake(self.view.frame.size.width/2+5, statusLabel.frame.origin.y, self.view.frame.size.width/2-5, statusLabel.frame.size.height);
    statusLabel.text = [[NSString alloc] initWithFormat:@"最新状态 :%@", status];
    deliverDateLabel.frame = CGRectMake(5, deliverDateLabel.frame.origin.y, self.view.frame.size.width/2-5, deliverDateLabel.frame.size.height);
    shipDateLabel.frame = CGRectMake(self.view.frame.size.width/2+5, shipDateLabel.frame.origin.y, self.view.frame.size.width/2-5, shipDateLabel.frame.size.height);
    if(![deliverDate isKindOfClass:[NSNull class]]){
    deliverDateLabel.text = [[NSString alloc] initWithFormat:@"投递时间:%@", deliverDate];
    }
    else{
    deliverDateLabel.text = @"投递时间  :  未知";
    }
    if(![shipDate isKindOfClass:[NSNull class]]){
    shipDateLabel.text = [[NSString alloc] initWithFormat:@"寄出时间:%@", shipDate];
    }
    else{
    shipDateLabel.text = @"寄出时间  :  未知";
    }
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
    newDateFormatter.dateFormat = @"yyyy-MM-dd";
    if(![deliverDate isKindOfClass:[NSNull class]]){
    NSDate *dDate = [dateFormatter dateFromString:deliverDate];
    deliverDate = [[newDateFormatter stringFromDate:dDate] mutableCopy];
    }
    if(![shipDate isKindOfClass:[NSNull class]]){
    NSDate *sDate = [dateFormatter dateFromString:shipDate];
    shipDate = [[newDateFormatter stringFromDate:sDate] mutableCopy];
    }

    events = [parcelDetail valueForKey:@"events"];
    status = [parcelDetail valueForKey:@"status"];
    for(int i = 0; i< [events count]; i++){
        TrackingDetailViewModel *view = [[TrackingDetailViewModel alloc] initWithFrame:CGRectMake(15, i*150, scrollView.frame.size.width-30, 130) andParams:[events objectAtIndex:i]];
       // view.backgroundColor = [UIColor greenColor];
       // scrollView.backgroundColor = [UIColor blueColor];
        [scrollView addSubview:view];
    }
}

- (void)fakeData{
    trackingNumber = _fakeNumber;
    deliverDate = @"2015-6-11";
    shipDate = @"2015-6-09";
    NSDictionary *place1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Worcester",@"city",
                            @"MA",@"state",
                            @"US",@"country",nil];
    NSDictionary *e1 = [[NSDictionary alloc] initWithObjectsAndKeys:place1,@"place",
                        @"Picked up",@"description",
                        @"2015-6-09",@"date",nil];
    NSDictionary *place2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Shanghai",@"city",
                            @"SH",@"state",
                            @"China",@"country",nil];
    NSDictionary *e2 = [[NSDictionary alloc] initWithObjectsAndKeys:place2,@"place",
                        @"Delivered",@"description",
                        @"2015-6-11",@"date",nil];
    events = [[[NSArray alloc] initWithObjects:e1,e2,nil] mutableCopy];
    status = @"已投递";
    for(int i = 0; i< [events count]; i++){
        TrackingDetailViewModel *view = [[TrackingDetailViewModel alloc] initWithFrame:CGRectMake(15, i*150, scrollView.frame.size.width-30, 130) andParams:[events objectAtIndex:i]];
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
