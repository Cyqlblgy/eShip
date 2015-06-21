//
//  LoginViewController.m
//  eShip
//
//  Created by Bin Lang on 6/9/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "LoginViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"
#import "SVProgressHUD.h"
#import "TheSidebarController.h"
#import "LeftViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController
@synthesize unTextField,pwTextField,loginButton,qqLogin,wechatLogin,weiboLogin,renrenLogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *userNameImage = [UIImage imageNamed:@"userName"];
    UIView *leftViewForUserName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, userNameImage.size.height)];
    UIImageView *imageViewForUserName = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,userNameImage.size.width, userNameImage.size.height)];
    [imageViewForUserName setCenter:leftViewForUserName.center];
    [imageViewForUserName setImage:userNameImage];
    [leftViewForUserName addSubview:imageViewForUserName];
    unTextField.leftView = leftViewForUserName;
    unTextField.leftViewMode = UITextFieldViewModeAlways;
    unTextField.tag = 0;
    unTextField.layer.borderColor=[[UIColor whiteColor]CGColor];
    unTextField.layer.borderWidth= 0.1f;
    
    UIImage *passwordImage = [UIImage imageNamed:@"passWord"];
    UIView *leftViewForPassWord = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, passwordImage.size.height)];
    UIImageView *imageViewForPassWord = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,passwordImage.size.width, passwordImage.size.height)];
    [imageViewForPassWord setCenter:leftViewForPassWord.center];
    [imageViewForPassWord setImage:passwordImage];
    [leftViewForPassWord addSubview:imageViewForPassWord];
    pwTextField.leftView = leftViewForPassWord;
    pwTextField.leftViewMode = UITextFieldViewModeAlways;
    pwTextField.tag = 1;
    pwTextField.layer.borderColor=[[UIColor whiteColor]CGColor];
    pwTextField.layer.borderWidth= 0.1f;
    
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    CGRect frame = loginButton.frame;
    
    qqLogin.layer.cornerRadius = 5;
    qqLogin.layer.masksToBounds = YES;
    
    wechatLogin.layer.cornerRadius = 5;
    wechatLogin.layer.masksToBounds = YES;
    wechatLogin.frame = CGRectMake((frame.size.width-200)/3+50+frame.origin.x, wechatLogin.frame.origin.y, 50, 50);
    
    weiboLogin.layer.cornerRadius = 5;
    weiboLogin.layer.masksToBounds = YES;
    weiboLogin.frame = CGRectMake((frame.size.width-200)*2/3+100+frame.origin.x, weiboLogin.frame.origin.y, 50, 50);
    
    renrenLogin.layer.cornerRadius = 5;
    renrenLogin.layer.masksToBounds = YES;
    renrenLogin.frame = CGRectMake(frame.size.width-50+frame.origin.x, renrenLogin.frame.origin.y, 50, 50);
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController navigationBar].hidden = NO;
    self.navigationItem.title = @"登录";

    UIBarButtonItem *aButton = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(goRegister)];
    self.navigationItem.rightBarButtonItem = aButton;
    UIBarButtonItem *bButton = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = bButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goRegister{
    //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"linkAccountVC"] animated:YES];
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    if([unTextField.text isEqualToString:@""] || [pwTextField.text isEqualToString:@""]){
        UIAlertController *alert =   [UIAlertController
                                           alertControllerWithTitle:@"用户名/密码错误"
                                           message:@"请保证用户名/密码输入正确"
                                           preferredStyle:UIAlertControllerStyleAlert];;
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else{
        [self.view endEditing:YES];
        NSDictionary *jsonDictionary;
        if([unTextField.text rangeOfString:@"@"].location != NSNotFound){
            jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              unTextField.text, @"email",
                              pwTextField.text, @"password",
                              nil];

        }
        else{
            jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    unTextField.text, @"user_name",
                                    pwTextField.text, @"password",
                                    nil];
        }
    [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeGradient];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkLogin andParams:jsonDictionary andMaxTimeOut:20 andAcceptType:nil andAuthorization:nil andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        UIAlertController *alert;
        UIAlertAction* ok;
        if(connectionError == nil && res.statusCode == BLNetworkLoginSuccess){
            alert=   [UIAlertController
                      alertControllerWithTitle:@"Success"
                      message:@"登陆成功"
                      preferredStyle:UIAlertControllerStyleAlert];
            NSError *e =nil;
            NSDictionary *loginResult = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&e];
            [self saveCurrentUserwithDictionary:loginResult];
            
            ok = [UIAlertAction
                  actionWithTitle:@"OK"
                  style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction *action){
                      [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MineVC"] animated:NO];
                  }];
            LeftViewController *vc =  (LeftViewController *)self.sidebarController.leftSidebarViewController;
            [vc updateLabel];
        }
        else{
            alert=   [UIAlertController
                      alertControllerWithTitle:@"Failed"
                      message:@"登陆失败"
                      preferredStyle:UIAlertControllerStyleAlert];
            ok = [UIAlertAction
                  actionWithTitle:@"OK"
                  style:UIAlertActionStyleDefault
                  handler:nil];
        }
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    }
}

- (void)saveCurrentUserwithDictionary:(NSDictionary *)loginResult{
    NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                               [loginResult valueForKey:@"user_name"], @"userName",
                                pwTextField.text, @"passWord",
                                nil];
    [[NSUserDefaults standardUserDefaults] setValue:Dictionary forKey:@"CurrentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

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
        [pwTextField becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 1){
        [pwTextField resignFirstResponder];
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


@end
