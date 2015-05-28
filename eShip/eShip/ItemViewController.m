//
//  ItemViewController.m
//  eShip
//
//  Created by Bin Lang on 5/27/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "ItemViewController.h"
#import "CheckPriceViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

@synthesize longthTextField,heightTextField,widthTextField,priceTextField,weightTextField,lengthSegment,priceSegment,weightSegment,weightLabel,widthLabel,heightLabel,longLabel,rateObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"寄件地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndgoBack)];
    CGRect frame = weightLabel.frame;
    longthTextField.frame =  CGRectMake(frame.origin.x, longthTextField.frame.origin.y, frame.size.width/3, longthTextField.frame.size.height);
    longLabel.frame = CGRectMake(longthTextField.frame.origin.x, longLabel.frame.origin.y, longthTextField.frame.size.width, longLabel.frame.size.height);
    widthTextField.frame = CGRectMake(frame.origin.x + frame.size.width/3, widthTextField.frame.origin.y, frame.size.width/3, widthTextField.frame.size.height);
    widthLabel.frame = CGRectMake(widthTextField.frame.origin.x, widthLabel.frame.origin.y, widthTextField.frame.size.width, widthLabel.frame.size.height);
    heightTextField.frame = CGRectMake(frame.origin.x + frame.size.width*2/3, heightTextField.frame.origin.y, frame.size.width/3, heightTextField.frame.size.height);
    heightLabel.frame = CGRectMake(heightTextField.frame.origin.x, heightLabel.frame.origin.y, heightTextField.frame.size.width, heightLabel.frame.size.height);
    weightTextField.frame = CGRectMake(weightTextField.frame.origin.x, weightTextField.frame.origin.y, frame.size.width/2, weightTextField.frame.size.height);
    priceTextField.frame = CGRectMake(priceTextField.frame.origin.x, priceTextField.frame.origin.y, frame.size.width/2, priceTextField.frame.size.height);
    priceSegment.frame = CGRectMake(priceTextField.frame.origin.x + priceTextField.frame.size.width + 10, priceSegment.frame.origin.y,priceSegment.frame.size.width, priceSegment.frame.size.height);
    weightSegment.frame = CGRectMake(weightTextField.frame.origin.x + weightTextField.frame.size.width + 10, weightSegment.frame.origin.y,weightSegment.frame.size.width, weightSegment.frame.size.height);
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAndgoBack{
    NSDictionary *size = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt:longthTextField.text.intValue],@"length",
                          [NSNumber numberWithInt:widthTextField.text.intValue],@"width",
                          [NSNumber numberWithInt:heightTextField.text.intValue],@"height",
                          [lengthSegment titleForSegmentAtIndex:lengthSegment.selectedSegmentIndex],@"unit",
                             nil];
    NSDictionary *weight = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithFloat:weightTextField.text.floatValue],@"weight",
                            [weightSegment titleForSegmentAtIndex:weightSegment.selectedSegmentIndex],@"unit",
                            nil];
    NSDictionary *value = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [priceSegment titleForSegmentAtIndex:priceSegment.selectedSegmentIndex],@"currency",
                           [NSNumber numberWithFloat:priceTextField.text.floatValue],@"amount",
                           nil];
    rateObject.size = size;
    rateObject.weight = weight;
    rateObject.value = value;
    NSArray *arrayViewControllers = [self.navigationController viewControllers];
    CheckPriceViewController *vc = (CheckPriceViewController *)[arrayViewControllers objectAtIndex:arrayViewControllers.count-1];
    vc.rateObject = rateObject;
    [self.navigationController popViewControllerAnimated:YES];

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
    return YES;
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
