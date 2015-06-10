//
//  SettingsViewController.m
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginAndRegisterViewController.h"

@interface SettingsViewController (){
    NSArray *leftViewTextArray;
    NSArray *hintArray;
}

@end

@implementation SettingsViewController

@synthesize mytableView,currentLabel,registerButton,loginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    leftViewTextArray = [[NSArray alloc] initWithObjects:@"收寄地址",@"快递公司",@"运单标签",@"打印机",@"支付方式", nil];
    hintArray = [[NSArray alloc] initWithObjects:@"寄件人地址/收件人地址/默认地址",@"常用快递公司/默认快递公司",@"标签格式/标签文字/条形码",@"选择默认打印机",@"信用卡/支付宝/贝宝", nil];
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = nil;
    loginButton.backgroundColor = [UIColor lightGrayColor];
    loginButton.tag = 0;
    registerButton.tag = 1;
    registerButton.backgroundColor = [UIColor lightGrayColor];
    currentLabel.backgroundColor = [UIColor whiteColor];
    currentLabel.textColor = [UIColor lightGrayColor];
}


- (void)viewWillAppear:(BOOL)animated{
    [self updateLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return leftViewTextArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 5)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 5)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SettingsCell"];
    }
    NSString *rowText = [leftViewTextArray objectAtIndex:indexPath.section];;
    cell.textLabel.text = rowText;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.detailTextLabel.text = [hintArray objectAtIndex:indexPath.section];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.frame = CGRectMake(100, 0, 200, cell.frame.size.height);
    return cell;

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"logID"]){
        if([loginButton.currentTitle isEqualToString:@"登陆"]){
            LoginAndRegisterViewController *vc = [segue destinationViewController];
        }
        else{
            //[self logOff];
        }
    
    }
    else if([segue.identifier isEqualToString:@"registerID"]){
        if([registerButton.currentTitle isEqualToString:@"注册"]){
            LoginAndRegisterViewController *vc = [segue destinationViewController];
        }
        else{
           // [self forgetPassword];
        }
      
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"logID"]){
        if([loginButton.currentTitle isEqualToString:@"登陆"]){
            return YES;
        }
        else{
            [self logOff];
            [self updateLayout];
            return NO;
        }
    }
    else if([identifier isEqualToString:@"registerID"]){
        if([registerButton.currentTitle isEqualToString:@"注册"]){
            return YES;
        }
        else{
            [self forgetPassword];
            return NO;
        }
    }
    return NO;
}


#pragma Private methods

- (void)logOff{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)forgetPassword{

}

- (void)updateLayout{
    NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
    if(currentUser == nil){
        [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        currentLabel.text = @"当前无用户登录，请登录或者注册";
    }
    else{
        NSString *userName =  [currentUser valueForKey:@"userName"];
        [loginButton setTitle:@"注销" forState:UIControlStateNormal];
        [registerButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        currentLabel.text = [[NSString alloc] initWithFormat:@"当前登录用户 ：%@", userName];;
    }
}

@end
