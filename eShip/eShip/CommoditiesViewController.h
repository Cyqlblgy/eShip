//
//  CommoditiesViewController.h
//  eShip
//
//  Created by Bin Lang on 6/2/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLShipObject.h"

@interface CommoditiesViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) BLShipObject *shipObject;
@property (weak, nonatomic) IBOutlet UITextField *itemCountry;
@property (weak, nonatomic) IBOutlet UITextField *itemQuantity;
@property (weak, nonatomic) IBOutlet UITextView *itemDescription;

@end
