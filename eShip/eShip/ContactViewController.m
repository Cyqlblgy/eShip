//
//  ContactViewController..m
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "ContactViewController.h"
#import "CommoditiesViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize senderName,senderPhone,senderEmail,recipentName,recipentPhone,recipentEmail,shipObject,rateObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收/寄件人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNext)];
    shipObject = [BLShipObject sharedInstance];
    [shipObject setWithRateObject:rateObject];
    senderName.tag = 0;
    senderPhone.tag = 1;
    senderEmail.tag = 2;
    recipentName.tag = 3;
    recipentPhone.tag = 4;
    recipentEmail.tag = 5;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goNext{
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
    [shipObject setSender:contact1 andReceiver:contact2];
    CommoditiesViewController *commodityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"commodityVC"];
    commodityVC.shipObject = shipObject;
    [self.navigationController pushViewController:commodityVC animated:YES];
   //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"shipVC"] animated:YES];
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
