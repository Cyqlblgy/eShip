//
//  FindViewController.h
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZBar/ZBarSDK.h>
#import "WYPopoverController.h"

@interface FindViewController : UIViewController <ZBarReaderDelegate,WYPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *shipNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *carrierTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *getListButton;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

- (IBAction)scanNumber:(id)sender;

- (IBAction)getCarrierList:(id)sender;

- (IBAction)startTracking:(id)sender;

@end
