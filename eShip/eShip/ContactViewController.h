//
//  ContactViewController.h
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLShipObject.h"
#import "BLRateObject.h"

@interface ContactViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) BLShipObject *shipObject;
@property (nonatomic, strong) BLRateObject *rateObject;
@property (weak, nonatomic) IBOutlet UITextField *senderName;
@property (weak, nonatomic) IBOutlet UITextField *senderPhone;
@property (weak, nonatomic) IBOutlet UITextField *senderEmail;
@property (weak, nonatomic) IBOutlet UITextField *recipentName;
@property (weak, nonatomic) IBOutlet UITextField *recipentPhone;
@property (weak, nonatomic) IBOutlet UITextField *recipentEmail;

@end
