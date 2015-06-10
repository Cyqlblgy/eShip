//
//  LoginAndRegisterViewController.h
//  eShip
//
//  Created by Bin Lang on 5/24/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginAndRegisterViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;


@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginOrRegister:(id)sender;

@end
