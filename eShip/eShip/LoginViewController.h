//
//  LoginViewController.h
//  eShip
//
//  Created by Bin Lang on 6/9/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *unTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *qqLogin;
@property (weak, nonatomic) IBOutlet UIButton *wechatLogin;
@property (weak, nonatomic) IBOutlet UIButton *renrenLogin;
@property (weak, nonatomic) IBOutlet UIButton *weiboLogin;
- (IBAction)login:(id)sender;

@end
