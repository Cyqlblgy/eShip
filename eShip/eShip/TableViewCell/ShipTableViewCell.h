//
//  ShipTableViewCell.h
//  eShip
//
//  Created by Bin Lang on 5/31/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carrierImage;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
