//
//  CheckPriceViewController.h
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckPriceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *originalPlaceTextField;

@property (weak, nonatomic) IBOutlet UITextField *destinationPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)SearchPrice:(id)sender;

@end
