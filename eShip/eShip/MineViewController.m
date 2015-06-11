//
//  MineViewController.m
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineNextTableViewCell.h"

@interface MineViewController (){
    NSArray *textArray,*nextTextArray;
    NSArray *imageNameArray,*nextImageNameArray;
}

@end

@implementation MineViewController

@synthesize mytableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    textArray = [[NSArray alloc] initWithObjects:@"我的包裹",@"我的运单",@"我的单证",@"我的账单",@"我的建议",nil];
    nextTextArray = [[NSArray alloc] initWithObjects:@"淘宝",@"天猫商城",@"亚马逊",@"易趣",nil];
    imageNameArray = [[NSArray alloc] initWithObjects:@"mine1.png",@"mine2.png",@"mine3.png",@"mine4.png",@"mine5.png",nil];
    nextImageNameArray = [[NSArray alloc] initWithObjects:@"taobao.png",@"tianmao.png",@"amazon.png",@"ebay.png",nil];
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *bButton = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = bButton;
    CGRect frame = mytableView.frame;
    mytableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.view.frame.size.height);
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 || section == 3){
        return 1;
    }
    else if(section == 1 || section == 2 ){
        return 4;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2 || section == 3 || section == 4){
        return 10;
    }
    else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return  80;
    }
    else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 2 || section == 3 || section == 4){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        return footerView;
    }
    else{
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 5)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        return footerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Mine1Cell"];
        
        if (cell == nil) {
            cell = (MineTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
        if(currentUser){
            NSString *userName =  [currentUser valueForKey:@"userName"];
            cell.userNameField.text = userName;
        }
        else{
            cell.userNameField.text = @"未登录";
        }
        [cell.currentUserLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:20.0f]];
        [cell.userNameField setFont:[UIFont fontWithName:@"ArialHebrew-Light" size:18.0f]];
        cell.logoImage.image = [UIImage imageNamed:@"Logo.png"];
        cell.logoImage.layer.cornerRadius = 5;
        cell.logoImage.layer.masksToBounds = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 1.0f;
        //[cell.contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        //[cell.contentView.layer setBorderWidth:1.0f];
        return cell;
    }
    MineNextTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Mine2Cell"];
    
    if (cell == nil) {
        cell = (MineNextTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"MineNextTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    if(indexPath.section == 1){
        cell.myImage.image = [UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]];
        cell.myLabel.text = [textArray objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 2){
        cell.myImage.image = [UIImage imageNamed:[nextImageNameArray objectAtIndex:indexPath.row]];
        cell.myLabel.text = [nextTextArray objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 3){
        cell.myImage.image = [UIImage imageNamed:[imageNameArray objectAtIndex:4]];
        cell.myLabel.text = [textArray objectAtIndex:4];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
        if(currentUser){
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"] animated:YES];
        }
        else{
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES];
        }
    }
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
