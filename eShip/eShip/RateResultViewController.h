//
//  RateResultViewController.h
//  eShip
//
//  Created by Bin Lang on 5/31/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRateObject.h"

@interface RateResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (strong, nonatomic) NSArray *shipInfo;
@property (nonatomic, strong) BLRateObject *rateObject;
@end
