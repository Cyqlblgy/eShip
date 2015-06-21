//
//  ContactViewController..m
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "ContactViewController.h"
#import "CommoditiesViewController.h"
#import "BLParams.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize senderName,senderPhone,senderEmail,recipentName,recipentPhone,recipentEmail,shipObject,rateObject,upsShipObject,shipCarrier;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收/寄件人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNext)];
    shipObject = [BLFedexShipObject sharedInstance];
    upsShipObject = [BLUPSShipObject sharedInstance];
    if([shipCarrier isEqualToString:BLParameters.ShipFedex]){
        [shipObject setWithRateObject:rateObject];
    }
    else{
        [upsShipObject setWithRateObject:rateObject];
    }
    senderName.tag = 0;
    senderPhone.tag = 1;
    senderEmail.tag = 2;
    recipentName.tag = 3;
    recipentPhone.tag = 4;
    recipentEmail.tag = 5;
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
    senderPhone.inputAccessoryView = keyboardDoneButtonView;
    recipentPhone.inputAccessoryView = keyboardDoneButtonView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}

- (IBAction)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goNext{
    if([senderName.text isEqualToString:@""] || [senderPhone.text isEqualToString:@""]  || [recipentName.text isEqualToString:@""] || [recipentPhone.text isEqualToString:@""]){
    UIAlertController *alert =   [UIAlertController
                                  alertControllerWithTitle:@"信息不完全"
                                  message:@"请保证完成必填信息再保存"
                                  preferredStyle:UIAlertControllerStyleAlert];;
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    }
    else{
    NSDictionary *contact1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              senderName.text,@"personName",
                              senderPhone.text,@"phoneNumber",
                              senderEmail.text,@"emailAddress",
                              nil];
    NSDictionary *contact2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              recipentName.text,@"personName",
                              recipentPhone.text,@"phoneNumber",
                              recipentEmail.text, @"emailAddress",
                              nil];
    if([shipCarrier isEqualToString:BLParameters.ShipFedex]){
        [shipObject setSender:contact1 andReceiver:contact2];
    }
    else{
        [upsShipObject setSender:contact1 andReceiver:contact2];
    }
    CommoditiesViewController *commodityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"commodityVC"];
    commodityVC.shipObject = shipObject;
    commodityVC.upsShipObject = upsShipObject;
    commodityVC.shipCarrier = shipCarrier;
    [self.navigationController pushViewController:commodityVC animated:YES];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = textField.frame.origin.y / 2; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma TextFieldDelegate implementation

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField: textField up: YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == 0){
        [senderName becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 1){
        [senderEmail becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 2){
        [recipentName becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 3){
        [recipentPhone becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 4){
        [recipentEmail becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 5){
        [recipentEmail resignFirstResponder];
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
