//
//  TrackingDetailViewController.h
//  eShip
//
//  Created by Bin Lang on 5/23/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *parcelDetail;
@property (nonatomic, strong) NSString *carrier;
@property (weak, nonatomic) IBOutlet UILabel *CarrierAndNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliverDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
