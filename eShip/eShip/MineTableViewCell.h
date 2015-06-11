//
//  MineTableViewCell.h
//  eShip
//
//  Created by Bin Lang on 6/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameField;
@property (weak, nonatomic) IBOutlet UILabel *currentUserLabel;

@end
