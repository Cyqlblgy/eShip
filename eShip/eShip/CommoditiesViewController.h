//
//  CommoditiesViewController.h
//  eShip
//
//  Created by Bin Lang on 6/2/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLFedexShipObject.h"
#import "BLUPSShipObject.h"

@interface CommoditiesViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) BLFedexShipObject *shipObject;
@property (nonatomic, strong) BLUPSShipObject *upsShipObject;
@property (nonatomic, strong) NSString *shipCarrier;
@property (weak, nonatomic) IBOutlet UITextField *itemCountry;
@property (weak, nonatomic) IBOutlet UITextField *itemQuantity;
@property (weak, nonatomic) IBOutlet UITextView *itemDescription;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *methodTextField;
@property (weak, nonatomic) IBOutlet UILabel *methodLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
