//
//  ContactViewController.h
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLFedexShipObject.h"
#import "BLRateObject.h"
#import "BLUPSShipObject.h"

@interface ContactViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) BLFedexShipObject *shipObject;
@property (nonatomic, strong) BLUPSShipObject *upsShipObject;
@property (nonatomic, strong) BLRateObject *rateObject;
@property (nonatomic, strong) NSString *shipCarrier;
@property (weak, nonatomic) IBOutlet UITextField *senderName;
@property (weak, nonatomic) IBOutlet UITextField *senderPhone;
@property (weak, nonatomic) IBOutlet UITextField *senderEmail;
@property (weak, nonatomic) IBOutlet UITextField *recipentName;
@property (weak, nonatomic) IBOutlet UITextField *recipentPhone;
@property (weak, nonatomic) IBOutlet UITextField *recipentEmail;

@end
