//
//  AddressViewController.h
//  eShip
//
//  Created by Bin Lang on 5/27/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRateObject.h"

@interface AddressViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTextFiedl1;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField2;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (nonatomic, assign) BOOL isOriginal;
@property (nonatomic, assign) BOOL isShip;
@property (weak, nonatomic) BLRateObject *rateObject;
- (IBAction)saveAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
