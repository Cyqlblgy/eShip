//
//  AddressViewController.m
//  eShip
//
//  Created by Bin Lang on 5/27/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "AddressViewController.h"
#import "TSLocateView.h"
#import "CheckPriceViewController.h"

@interface AddressViewController (){
    NSString *provinceCode;
    NSString *countryCode;
}

@end

@implementation AddressViewController
@synthesize stateTextField,countryTextField,cityTextField,addressTextFiedl1,addressTextField2,zipCodeTextField,isOriginal,rateObject,confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = addressTextFiedl1.frame;
    countryTextField.frame = CGRectMake(frame.origin.x, countryTextField.frame.origin.y, frame.size.width/3, countryTextField.frame.size.height);
    stateTextField.frame = CGRectMake(frame.origin.x + frame.size.width/3, stateTextField.frame.origin.y, frame.size.width/3, stateTextField.frame.size.height);
    cityTextField.frame = CGRectMake(frame.origin.x + frame.size.width*2/3, cityTextField.frame.origin.y, frame.size.width/3, cityTextField.frame.size.height);
    addressTextFiedl1.tag = 0;
    addressTextField2.tag = 1;
    zipCodeTextField.tag = 2;
    countryTextField.tag = 3;
    stateTextField.tag = 4;
    cityTextField.tag = 5;
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    if(isOriginal){
        self.navigationItem.title = @"寄件地址";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    }
    else{
        self.navigationItem.title = @"目的地址";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    }
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSArray *streelines = [[NSArray alloc] initWithObjects:addressTextFiedl1.text,addressTextField2.text,nil];
    NSDictionary *Address = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   cityTextField.text,@"city",
                                   @"SH",@"stateOrProvinceCode",
                                   zipCodeTextField.text,@"postalCode",
                                   [NSNull null],@"urbanizationCode",
                                   @"CN",@"countryCode",
                                   countryTextField.text,@"countryName",
                                   [NSNumber numberWithBool:NO],@"residential",
                                   streelines,@"streetLines",
                                   nil];
    if(isOriginal){
        rateObject.originalAddress = Address;
    }
    else{
        rateObject.destinationAddress = Address;
    }
    CheckPriceViewController *vc = (CheckPriceViewController *)segue.destinationViewController;
    vc.rateObject = rateObject;
}


- (IBAction)saveAddress:(id)sender {
    NSArray *streelines ;
    if(![addressTextField2.text isEqualToString:@""] && addressTextField2.text != nil){
    streelines= [[NSArray alloc] initWithObjects:addressTextFiedl1.text,addressTextField2.text,nil];
    }
    else{
    streelines= [[NSArray alloc] initWithObjects:addressTextFiedl1.text,nil];
    }
    NSDictionary *Address = [[NSDictionary alloc] initWithObjectsAndKeys:
                             cityTextField.text,@"city",
                             provinceCode,@"stateOrProvinceCode",
                             zipCodeTextField.text,@"postalCode",
                             [NSNull null],@"urbanizationCode",
                             countryCode,@"countryCode",
                             countryTextField.text,@"countryName",
                             [NSNumber numberWithBool:NO],@"residential",
                             streelines,@"streetLines",
                             nil];
    if(isOriginal){
        rateObject.originalAddress = Address;
    }
    else{
        rateObject.destinationAddress = Address;
    }
    NSArray *arrayViewControllers = [self.navigationController viewControllers];
    
    CheckPriceViewController *vc = (CheckPriceViewController *)[arrayViewControllers objectAtIndex:arrayViewControllers.count-1];
    vc.rateObject = rateObject;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showCityAndProvincePicker{
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"选择国家/省/城市" delegate:self];
    [locateView showInView:self.view];
}


#pragma TextFieldDelegate implementation

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag ==0 || textField.tag ==1 || textField.tag ==2 ){
        return YES;
    }
    else{
        [self.view endEditing:YES];
        [self showCityAndProvincePicker];
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == 0){
        [addressTextField2 becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 1){
        [zipCodeTextField becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 2){
        [zipCodeTextField resignFirstResponder];
        return YES;
    }
    return NO;
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        TSLocateView *locateView = (TSLocateView *)actionSheet;
        countryTextField.text = locateView.address.country;
        stateTextField.text = locateView.address.state;
        cityTextField.text = locateView.address.city;
        provinceCode = locateView.address.provinceCode;
        countryCode = locateView.address.countryCode;
    }
}
@end
