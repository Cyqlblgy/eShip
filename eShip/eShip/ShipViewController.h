//
//  ShipViewController.h
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRateObject.h"
#import "WYPopoverController.h"

@interface ShipViewController : UIViewController<WYPopoverControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originalPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *carrierTextField;
@property (weak, nonatomic) IBOutlet UIButton *carrierButton;
@property (weak, nonatomic) IBOutlet UIButton *originalButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButton;
@property (weak, nonatomic) IBOutlet UIButton *itemTypeButton;
@property (nonatomic, strong) BLRateObject *rateObject;
@property (weak, nonatomic) IBOutlet UIButton *shipButton;

@end
