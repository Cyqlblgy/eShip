//
//  FileDisplayViewController.h
//  eShip
//
//  Created by Bin Lang on 6/13/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileDisplayViewController : UIViewController

@property (nonatomic, strong) NSString *trackingNumber;
@property (weak, nonatomic) IBOutlet UIButton *labelButton;
@property (weak, nonatomic) IBOutlet UIButton *customButton;
- (IBAction)getLabel:(id)sender;
- (IBAction)getCustomFile:(id)sender;

@end
