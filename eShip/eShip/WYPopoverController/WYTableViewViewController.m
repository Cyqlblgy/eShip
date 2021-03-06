//
//  WYTableViewViewController.m
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "WYTableViewViewController.h"

@interface WYTableViewViewController (){
}

@end

@implementation WYTableViewViewController

@synthesize selectedOne,list;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:@"WYSettingsTableViewCell" forIndexPath:indexPath];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CarrierListCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarrierListCell"];
    }
    [cell setTintColor:[UIColor redColor]];
    NSString *rowText = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = rowText;
    if(_cellTextFont){
    cell.textLabel.font  = _cellTextFont;
    }
    cell.textLabel.numberOfLines = 2;
    if([selectedOne isEqualToString:rowText]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if(_imageList){
    cell.imageView.image = [UIImage imageNamed:[_imageList objectAtIndex:indexPath.row]];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedOne = [list objectAtIndex:indexPath.row];
    [tableView reloadData];
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
