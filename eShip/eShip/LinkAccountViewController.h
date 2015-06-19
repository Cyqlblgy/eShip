//
//  LinkAccountViewController.h
//  eShip
//
//  Created by Bin Lang on 6/19/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkAccountViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *fedexTextField;
@property (weak, nonatomic) IBOutlet UITextField *UPSTextField;

@end
