//
//  ShipViewController.h
//  eShip
//
//  Created by Bin Lang on 5/31/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *shipInfo;
@end
