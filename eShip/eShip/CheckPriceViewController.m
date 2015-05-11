//
//  CheckPriceViewController.m
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "CheckPriceViewController.h"

@interface CheckPriceViewController ()

@end

@implementation CheckPriceViewController

@synthesize originalPlaceTextField,destinationPlaceTextField,itemTypeTextField,searchButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, originalPlaceTextField.frame.size.height)];
    [button setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    button.layer.borderWidth = 0.4f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, originalPlaceTextField.frame.size.width/3, originalPlaceTextField.frame.size.height)];
    label.text = @"原寄地";
    originalPlaceTextField.rightView = button;
    originalPlaceTextField.rightViewMode = UITextFieldViewModeAlways;
    destinationPlaceTextField.rightView = button;
    destinationPlaceTextField.rightViewMode = UITextFieldViewModeAlways;
    itemTypeTextField.rightView = button;
    itemTypeTextField.rightViewMode= UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SearchPrice:(id)sender {
}
@end
