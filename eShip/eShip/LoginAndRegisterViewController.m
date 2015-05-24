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

@interface LoginAndRegisterViewController ()

@end

@implementation LoginAndRegisterViewController
@synthesize loginButton,passwordTextField,userNameTextField,isLogin,emailTextField,phoneNumberTextField;

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
    
    UIImage *emailImage = [UIImage imageNamed:@"userName"];
    UIView *leftViewForEmail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, emailImage.size.height)];
    UIImageView *imageViewForEmail = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,emailImage.size.width, emailImage.size.height)];
    [imageViewForEmail setCenter:leftViewForEmail.center];
    [imageViewForEmail setImage:emailImage];
    [leftViewForEmail addSubview:imageViewForEmail];
    emailTextField.leftView = leftViewForEmail;
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    emailTextField.tag = 2;
    
    UIImage *phoneImage = [UIImage imageNamed:@"passWord"];
    UIView *leftViewForPhene = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, phoneImage.size.height)];
    UIImageView *imageViewForPhone = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,phoneImage.size.width, phoneImage.size.height)];
    [imageViewForPhone setCenter:leftViewForPhene.center];
    [imageViewForPhone setImage:phoneImage];
    [leftViewForPhene addSubview:imageViewForPhone];
    phoneNumberTextField.leftView = leftViewForPhene;
    phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneNumberTextField.tag = 3;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    if(isLogin){
        [phoneNumberTextField setHidden:YES];
        [emailTextField setHidden:YES];
        loginButton.frame =CGRectMake(loginButton.frame.origin.x, loginButton.frame.origin.y - 2*emailTextField.frame.size.height, loginButton.frame.size.width, loginButton.frame.size.height);
        passwordTextField.returnKeyType = UIReturnKeyDone;
        [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        self.navigationItem.title = @"登陆";
    }
    else{
        passwordTextField.returnKeyType = UIReturnKeyNext;
        [loginButton setTitle:@"注册" forState:UIControlStateNormal];
        self.navigationItem.title = @"注册";
    }
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
    if(isLogin){
            //Login sample
            NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            userNameTextField.text, @"user_name",
                                            passwordTextField.text, @"password",
                                            nil];
        
            [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkLogin andParams:jsonDictionary andMaxTimeOut:20 andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                UIAlertController *alert;
                if(connectionError == nil && res.statusCode == BLNetworkLoginSuccess){
//                    NSError *error =nil;
//                    NSDictionary *da = [NSJSONSerialization JSONObjectWithData:data
//                                                                       options:NSJSONReadingMutableContainers
//                                                                         error:&error];
//                    if(error == nil){
                        alert=   [UIAlertController
                                  alertControllerWithTitle:@"Success"
                                  message:@"登陆成功"
                                  preferredStyle:UIAlertControllerStyleAlert];
                    [self saveCurrentUser];
//                    }
                }
                else{
                    alert=   [UIAlertController
                              alertControllerWithTitle:@"Failed"
                              message:@"登陆失败"
                              preferredStyle:UIAlertControllerStyleAlert];
                }
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action){
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];

            }];

    }
    else{
        NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:userNameTextField.text, @"user_name",emailTextField.text,@"email",passwordTextField.text, @"password",phoneNumberTextField.text, @"phone",nil];
        [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkRegister andParams:jsonDictionary andMaxTimeOut:20 andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError){
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            UIAlertController *alert;
            if(res.statusCode == BLNetworkRegisterSuccess){
                alert=   [UIAlertController
                          alertControllerWithTitle:@"Success"
                          message:@"注册成功"
                          preferredStyle:UIAlertControllerStyleAlert];
                [self saveCurrentUser];
            }
            else if(res.statusCode == BLNetworkRegisterDuplicateUserNamrorEmail){
                alert=   [UIAlertController
                          alertControllerWithTitle:@"Failed"
                          message:@"注册失败"
                          preferredStyle:UIAlertControllerStyleAlert];
            }
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action){
                                     [self.navigationController popViewControllerAnimated:YES];
                                 }];
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
