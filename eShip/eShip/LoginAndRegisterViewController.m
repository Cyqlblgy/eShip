//
//  LoginAndRegisterViewController.m
//  eShip
//
//  Created by Bin Lang on 5/24/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"
#import "TheSidebarController.h"
#import "LeftViewController.h"

@interface LoginAndRegisterViewController ()

@end

@implementation LoginAndRegisterViewController
@synthesize loginButton,passwordTextField,userNameTextField,emailTextField,phoneNumberTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *userNameImage = [UIImage imageNamed:@"userName"];
    UIView *leftViewForUserName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, userNameImage.size.height)];
    UIImageView *imageViewForUserName = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,userNameImage.size.width, userNameImage.size.height)];
    [imageViewForUserName setCenter:leftViewForUserName.center];
    [imageViewForUserName setImage:userNameImage];
    [leftViewForUserName addSubview:imageViewForUserName];
    userNameTextField.leftView = leftViewForUserName;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    userNameTextField.tag = 0;
    
    UIImage *passwordImage = [UIImage imageNamed:@"passWord"];
    UIView *leftViewForPassWord = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, passwordImage.size.height)];
    UIImageView *imageViewForPassWord = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,passwordImage.size.width, passwordImage.size.height)];
    [imageViewForPassWord setCenter:leftViewForPassWord.center];
    [imageViewForPassWord setImage:passwordImage];
    [leftViewForPassWord addSubview:imageViewForPassWord];
    passwordTextField.leftView = leftViewForPassWord;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.tag = 1;
    loginButton.backgroundColor = [UIColor lightGrayColor];
    
    UIImage *emailImage = [UIImage imageNamed:@"email"];
    UIView *leftViewForEmail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, emailImage.size.height)];
    UIImageView *imageViewForEmail = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,emailImage.size.width, emailImage.size.height)];
    [imageViewForEmail setCenter:leftViewForEmail.center];
    [imageViewForEmail setImage:emailImage];
    [leftViewForEmail addSubview:imageViewForEmail];
    emailTextField.leftView = leftViewForEmail;
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    emailTextField.tag = 2;
    
    UIImage *phoneImage = [UIImage imageNamed:@"phone"];
    UIView *leftViewForPhene = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, phoneImage.size.height)];
    UIImageView *imageViewForPhone = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,phoneImage.size.width, phoneImage.size.height)];
    [imageViewForPhone setCenter:leftViewForPhene.center];
    [imageViewForPhone setImage:phoneImage];
    [leftViewForPhene addSubview:imageViewForPhone];
    phoneNumberTextField.leftView = leftViewForPhene;
    phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneNumberTextField.tag = 3;
    
    
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *bButton = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = bButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    passwordTextField.returnKeyType = UIReturnKeyNext;
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    self.navigationItem.title = @"注册";
}

- (void)goBack{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TextFieldDelegate implementation

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == 0){
        [passwordTextField becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 1){
        if(emailTextField.isHidden){
            [passwordTextField resignFirstResponder];
            return YES;
        }
        else{
            [emailTextField becomeFirstResponder];
            return NO;
        }
    }
    else if(textField.tag == 2){
        [phoneNumberTextField becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 3){
        [phoneNumberTextField resignFirstResponder];
        return YES;
    }
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginOrRegister:(id)sender {
    if([emailTextField.text isEqualToString:@""] || [userNameTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""]){
        UIAlertController *alert =   [UIAlertController
                                      alertControllerWithTitle:@"信息不完全"
                                      message:@"请保证完成必填信息再注册"
                                      preferredStyle:UIAlertControllerStyleAlert];;
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:userNameTextField.text, @"user_name",emailTextField.text,@"email",passwordTextField.text, @"password",phoneNumberTextField.text, @"phone",nil];
        [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkRegister andParams:jsonDictionary andMaxTimeOut:20 andAcceptType:nil andAuthorization:nil andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError){
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            UIAlertController *alert;
            UIAlertAction* ok;
            if(res.statusCode == BLNetworkRegisterSuccess){
                alert=   [UIAlertController
                          alertControllerWithTitle:@"Success"
                          message:@"注册成功"
                          preferredStyle:UIAlertControllerStyleAlert];
                [self saveCurrentUser];
                ok =                 [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action){
                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                      }];
                LeftViewController *vc =  (LeftViewController *)self.sidebarController.leftSidebarViewController;
                [vc updateLabel];
            }
            else if(res.statusCode == BLNetworkRegisterDuplicateUserNamrorEmail){
                alert=   [UIAlertController
                          alertControllerWithTitle:@"Failed"
                          message:@"注册失败"
                          preferredStyle:UIAlertControllerStyleAlert];
                ok =                 [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                      handler:nil];

            }
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
}


#pragma Private methods

- (void)saveCurrentUser{
    NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    userNameTextField.text, @"userName",
                                    passwordTextField.text, @"passWord",
                                    nil];
    [[NSUserDefaults standardUserDefaults] setValue:Dictionary forKey:@"CurrentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
