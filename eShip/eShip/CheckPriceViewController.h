//
//  CheckPriceViewController.h
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "BLRateObject.h"

@interface CheckPriceViewController : UIViewController<UITextFieldDelegate,WYPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *originalPlaceTextField;

@property (weak, nonatomic) IBOutlet UITextField *destinationPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *originalButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButton;
@property (weak, nonatomic) IBOutlet UIButton *itemTypeButton;
@property (nonatomic, strong) BLRateObject *rateObject;


- (IBAction)SearchPrice:(id)sender;

@end
