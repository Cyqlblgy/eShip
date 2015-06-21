//
//  SettingsViewController.m
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginAndRegisterViewController.h"
#import "LeftViewController.h"
#import "TheSidebarController.h"
#import "LinkAccountViewController.h"

@interface SettingsViewController (){
    NSArray *leftViewTextArray;
    NSArray *hintArray;
}

@end

@implementation SettingsViewController

@synthesize mytableView,currentLabel,loginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    leftViewTextArray = [[NSArray alloc] initWithObjects:@"收寄地址",@"快递公司",@"运单标签",@"关联账号",@"支付方式", nil];
    hintArray = [[NSArray alloc] initWithObjects:@"寄件人地址/收件人地址/默认地址",@"常用快递公司/默认快递公司",@"标签格式/标签文字/条形码",@"绑定快递账号",@"信用卡/支付宝/贝宝", nil];
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = nil;
    loginButton.backgroundColor = [UIColor redColor];
    loginButton.tag = 0;
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    currentLabel.backgroundColor = [UIColor whiteColor];
    currentLabel.textColor = [UIColor lightGrayColor];
}


- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *bButton = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = bButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self updateLayout];
}

- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3){
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"]){
            LinkAccountViewController *linkvc = (LinkAccountViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"linkAccountVC"];
            linkvc.isFromSettings = YES;
          [self.navigationController pushViewController:linkvc animated:YES];
        }
        else{
            UIAlertController *alert =   [UIAlertController
                                          alertControllerWithTitle:@"当前无已登录账号"
                                          message:@"请先登录再绑定快递账号"
                                          preferredStyle:UIAlertControllerStyleAlert];;
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
}

#pragma Private methods

- (void)logOff{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentUser"];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"UPS"]){
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UPS"];
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"Fedex"]){
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Fedex"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    LeftViewController *vc =  (LeftViewController *)self.sidebarController.leftSidebarViewController;
    [vc updateLabel];
}

- (void)updateLayout{
    NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
    if(currentUser == nil){
        [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        currentLabel.text = @"当前无用户登录，请登录或者注册";
    }
    else{
        NSString *userName =  [currentUser valueForKey:@"userName"];
        [loginButton setTitle:@"退出当前账户" forState:UIControlStateNormal];
        currentLabel.text = [[NSString alloc] initWithFormat:@"当前登录用户 ：%@", userName];;
    }
}

- (IBAction)logAction:(id)sender {
    if([loginButton.currentTitle isEqualToString:@"登陆"]){
      //  [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"commentcVC"] animated:YES];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES];
    }
    else if([loginButton.currentTitle isEqualToString:@"退出当前账户"]){
        [self logOff];
    }
    [self updateLayout];
}
@end
