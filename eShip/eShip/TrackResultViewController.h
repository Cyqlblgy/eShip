//
//  TrackResultViewController.h
//  eShip
//
//  Created by Bin Lang on 7/5/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MACircleProgressIndicator.h"

@interface TrackResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *trackingNumber;
@property (weak, nonatomic) IBOutlet UILabel *latestStatus;
@property (nonatomic, strong) NSString * fakeNumber;
@property (nonatomic, strong) NSString *carrier;
@property (weak, nonatomic) IBOutlet MACircleProgressIndicator *pView;
@end
