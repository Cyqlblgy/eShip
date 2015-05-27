//
//  CheckPriceViewController.h
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"

@interface CheckPriceViewController : UIViewController<WYPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *originalPlaceTextField;

@property (weak, nonatomic) IBOutlet UITextField *destinationPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *originalButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButton;
@property (weak, nonatomic) IBOutlet UIButton *itemTypeButton;


- (IBAction)SearchPrice:(id)sender;

@end
