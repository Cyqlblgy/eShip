//
//  MineViewController.m
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController (){
    NSArray *textArray;
    NSArray *imageNameArray;
}

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    textArray = [[NSArray alloc] initWithObjects:@"我的包裹",@"我的运单",@"我的单证",@"我的账单",@"我的建议",nil];
    imageNameArray = [[NSArray alloc] initWithObjects:@"taobao.png",@"tianmao.png",@"amazon.png",@"ebay.png",nil];
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 4 || section == 8){
        return 10;
    }
    else{
    return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 3 || section == 7){
        return 10;
    }
    else{
        return 2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 3 || section == 7){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        return footerView;
    }
    else{
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 2)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        return footerView;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 4 || section == 8){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        return footerView;
    }
    else{
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 2)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        return footerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineCell"];
    }
    if(indexPath.section>=0 && indexPath.section<4){
    NSString *rowText = [textArray objectAtIndex:indexPath.section];;
    cell.textLabel.text = rowText;
    cell.textLabel.textColor = [UIColor blackColor];
    }
    else if(indexPath.section>=4 && indexPath.section<8){
        NSString *imageName = [imageNameArray objectAtIndex:indexPath.section-4];;
        cell.imageView.image = [UIImage imageNamed:imageName];
    }
    else if(indexPath.section == 8){
        NSString *rowText = [textArray objectAtIndex:4];;
        cell.textLabel.text = rowText;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    return cell;
    
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
