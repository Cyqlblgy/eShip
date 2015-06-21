//
//  LinkAccountViewController.m
//  eShip
//
//  Created by Bin Lang on 6/19/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "LinkAccountViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"

@interface LinkAccountViewController (){
    NSString *usrn, *pswd;
}

@end

@implementation LinkAccountViewController

@synthesize UPSTextField,fedexTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController navigationBar].hidden = NO;
    self.navigationItem.title = @"关联账号";
    UIImage *fedexImage = [UIImage imageNamed:@"fedex"];
    UIView *leftViewForFedex = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    UIImageView *imageViewForFedex = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,50, 50)];
    [imageViewForFedex setCenter:leftViewForFedex.center];
    [imageViewForFedex setImage:fedexImage];
    [leftViewForFedex addSubview:imageViewForFedex];
    fedexTextField.leftView = leftViewForFedex;
    fedexTextField.leftViewMode = UITextFieldViewModeAlways;
    fedexTextField.tag = 0;
    
    UIImage *upsImage = [UIImage imageNamed:@"ups"];
    UIView *leftViewForUPS = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    UIImageView *imageViewForUPS = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,50, 50)];
    [imageViewForUPS setCenter:leftViewForUPS.center];
    [imageViewForUPS setImage:upsImage];
    [leftViewForUPS addSubview:imageViewForUPS];
    UPSTextField.leftView = leftViewForUPS;
    UPSTextField.leftViewMode = UITextFieldViewModeAlways;
    UPSTextField.tag = 1;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    button.layer.cornerRadius = 4.0;
    button.frame= CGRectMake(0.0, 0.0, 60, 35);
    [button addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flex,doneButton, nil]];
    UPSTextField.inputAccessoryView = keyboardDoneButtonView;
    fedexTextField.inputAccessoryView = keyboardDoneButtonView;
}

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *aButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(goRegister)];
    self.navigationItem.rightBarButtonItem = aButton;
    NSString *title = nil;
    if(_isFromSettings){
        title = @"返回";
    }
    else{
        title = @"跳过";
    }
    UIBarButtonItem *bButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = bButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (IBAction)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

- (void)goBack{
    if(_isFromSettings){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)goRegister{
    NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
    if(currentUser){
        usrn =  [currentUser valueForKey:@"userName"];
        pswd = [currentUser valueForKey:@"passWord"];
        NSString *authStr = [[NSString alloc] initWithFormat:@"%@:%@",usrn,pswd];
      //  NSString *authStr = @"habuer:123456789";
        NSData *plainData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];
        if([UPSTextField.text isEqualToString:@""] && [fedexTextField.text isEqualToString:@""]){
            UIAlertController *alert =   [UIAlertController
                                          alertControllerWithTitle:@"账号为空"
                                          message:@"请至少填写一个快递运营商账号在提交"
                                          preferredStyle:UIAlertControllerStyleAlert];;
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"知道了"
                                 style:UIAlertActionStyleDefault
                                 handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
            if(![UPSTextField.text isEqualToString:@""]){
                [jsonDic setObject:UPSTextField.text forKey:@"UPS"];
            }
            if(![fedexTextField.text isEqualToString:@""]){
                [jsonDic setObject:fedexTextField.text forKey:@"Fedex"];
            }
            [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkLinkAccount andParams:jsonDic andMaxTimeOut:40 andAcceptType:nil andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                if(res.statusCode == BLNetworkLinkAccountSuccess){
                    [self saveLinkedAccounts];
                    UIAlertController *alert =   [UIAlertController
                                                  alertControllerWithTitle:@"关联成功"
                                                  message:@"您已成功将eShip账号和快递账号绑定"
                                                  preferredStyle:UIAlertControllerStyleAlert];;
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"知道了"
                                         style:UIAlertActionStyleDefault
                                         handler:nil];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else if(res.statusCode == BLNetworkLinkAccountConflict){
                    UIAlertController *alert =   [UIAlertController
                                                  alertControllerWithTitle:@"出错了"
                                                  message:@"您提交的账号已被关联，请换一个再试"
                                                  preferredStyle:UIAlertControllerStyleAlert];;
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"知道了"
                                         style:UIAlertActionStyleDefault
                                         handler:nil];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    UIAlertController *alert =   [UIAlertController
                                                  alertControllerWithTitle:@"出错了"
                                                  message:@"关联账号出错了请稍后再试"
                                                  preferredStyle:UIAlertControllerStyleAlert];;
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"知道了"
                                         style:UIAlertActionStyleDefault
                                         handler:nil];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
        
    }
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"未登录"
                                      message:@"请先登录再进行查询"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action){
                                 [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)saveLinkedAccounts{
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    if(![UPSTextField.text isEqualToString:@""]){
        [jsonDic setObject:UPSTextField.text forKey:@"UPS"];
    }
    if(![fedexTextField.text isEqualToString:@""]){
        [jsonDic setObject:fedexTextField.text forKey:@"Fedex"];
    }
    [[NSUserDefaults standardUserDefaults] setValue:jsonDic forKey:@"LinkedAccount"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == 0){
        [UPSTextField becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 1){
        [UPSTextField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
