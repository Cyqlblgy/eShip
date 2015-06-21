//
//  CommoditiesViewController.m
//  eShip
//
//  Created by Bin Lang on 6/2/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "CommoditiesViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"
#import "SVProgressHUD.h"
#import "FileDisplayViewController.h"
#import "WYPopoverController/WYPopoverController.h"
#import "WYPopoverController/WYTableViewViewController.h"

@interface CommoditiesViewController ()<WYPopoverControllerDelegate>{
    WYPopoverController *destinationpopoverController;
    WYTableViewViewController * pickTableController;
}

@end

@implementation CommoditiesViewController

@synthesize itemCountry,itemDescription,itemQuantity,shipObject,upsShipObject,shipCarrier,methodLabel,methodTextField,descriptionLabel,accountTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物品信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(goShip)];
    itemCountry.tag = 0;
    itemQuantity.tag = 1;
    accountTextField.tag = 2;
    methodTextField.tag = 3;
    itemDescription.layer.borderWidth = 1.0f;
    itemDescription.layer.cornerRadius = 5.0f;
    itemDescription.layer.masksToBounds = YES;
    itemDescription.layer.borderColor = [[UIColor grayColor] CGColor];
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
    itemQuantity.inputAccessoryView = keyboardDoneButtonView;
    accountTextField.inputAccessoryView = keyboardDoneButtonView;
}

- (void)viewWillAppear:(BOOL)animated{
    if([shipCarrier isEqualToString:BLParameters.ShipFedex]){
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"Fedex"]){
            accountTextField.text =  [[NSUserDefaults standardUserDefaults] valueForKey:@"Fedex"];
        }
    }
    else{
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"UPS"]){
            accountTextField.text =  [[NSUserDefaults standardUserDefaults] valueForKey:@"UPS"];
        }
        methodLabel.hidden = YES;
        methodTextField.hidden = YES;
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, methodLabel.frame.origin.y, descriptionLabel.frame.size.width, descriptionLabel.frame.size.height);
        itemDescription.frame = CGRectMake(itemDescription.frame.origin.x, methodTextField.frame.origin.y, itemDescription.frame.size.width, itemDescription.frame.size.height);
    }
}

- (void)viewWillDisappear:(BOOL)animated{
   [self.view endEditing:YES];
}

- (IBAction)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

- (void)goShip{
    [self.view endEditing:YES];
    if([itemCountry.text isEqualToString:@""] || [itemQuantity.text isEqualToString:@""]  || [itemDescription.text isEqualToString:@""] || [accountTextField.text isEqualToString:@""] || ([shipCarrier isEqualToString:BLParameters.ShipFedex] &&[methodTextField.text isEqualToString:@""]) ){
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
    NSDictionary *commodity = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInt:itemQuantity.text.intValue],@"numberOfPieces",
                               itemCountry.text,@"countryOfManufacture",
                               itemDescription.text,@"description",
                               [NSNumber numberWithInt:itemQuantity.text.intValue],@"quantity",
                               @"EA",@"quantityUnits",
                               nil];
    NSDictionary *jsonDictionary;
    long long i = (long long)[[NSDate date] timeIntervalSince1970]* 1000.0;
    if([shipCarrier isEqualToString:BLParameters.ShipFedex]){
        [shipObject setCommodities:commodity];;
        jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Fedex",@"carrier",
                          [NSNumber numberWithLongLong:i],@"shipDate",
                          methodTextField.text,@"serviceType",
                          @"REGULAR_PICKUP",@"dropoffType",
                          @"YOUR_PACKAGING",@"packagingType",
                          shipObject.senderContact,@"senderContact",
                          shipObject.senderAddress,@"senderAddress",
                          shipObject.recipientContact,@"recipientContact",
                          shipObject.receiverAddress,@"recipientAddress",
                          accountTextField.text,@"accountNumber",
                          @"SENDER", @"paymentType",
                          [NSNull null], @"responsibleParty",
                          @"SENDER", @"dutyPaymentType",
                          shipObject.dutyPayor, @"dutyPayor",
                          shipObject.value, @"customValue",
                          @"NON_DOCUMENTS",@"documentContentType",
                          shipObject.commodities, @"commodities",
                          [NSNumber numberWithInt:1],@"packageNum",
                          shipObject.packageLineitems,@"packageLineItems",
                          nil];
    }
    else{
        [upsShipObject setCommodities:commodity];
        jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                          upsShipObject.shipFrom,@"shipFrom",
                          upsShipObject.shipTo,@"shipTo",
                          upsShipObject.packageContent,@"packages",
                          nil];

    }
    
    NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
    if(currentUser){
        NSString *usrnm = [currentUser valueForKey:@"userName"];
        NSString *pswd= [currentUser valueForKey:@"passWord"];
        NSString *authStr = [[NSString alloc] initWithFormat:@"%@:%@",usrnm,pswd];
        NSData *plainData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];
        NSString *request = [[NSString alloc] initWithFormat:@"%@%@",BLParameters.NetworkShip,[shipCarrier lowercaseString]];
        [SVProgressHUD showWithStatus:@"下单中..." maskType:SVProgressHUDMaskTypeGradient];
        [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:request andParams:jsonDictionary andMaxTimeOut:40 andAcceptType:nil andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [SVProgressHUD dismiss];
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSError *e = nil;
            if(res.statusCode == BLNetworkShipSuccess){
                NSDictionary *shipResults = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&e];
                NSString *trackingNumber = [shipResults valueForKey:@"trackingNum"];
                NSString *alertMessage = [[NSString alloc] initWithFormat:@"包裹运单号：%@",trackingNumber];
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"包裹成功寄出"
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action){
                                         FileDisplayViewController *fileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fileVC"];
                                         fileVC.trackingNumber = trackingNumber;
                                         [self.navigationController pushViewController:fileVC animated:YES];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else{
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"出错了"
                                              message:@"在邮寄过程中出错了，请稍后再试"
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"好的"
                                     style:UIAlertActionStyleDefault
                                     handler:nil];
                UIAlertAction* goback = [UIAlertAction
                                     actionWithTitle:@"回到地图"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action){
                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                     }];
                [alert addAction:goback];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
      }
    }
}

- (void)pickNextStep{
    [self.view endEditing:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    pickTableController = [storyboard instantiateViewControllerWithIdentifier:@"CarrierListTableView"];
    pickTableController.title = @"选择快递方式";
    pickTableController.list = [[NSArray alloc] initWithObjects:@"EUROPE_FIRST_INTERNATIONAL_PRIORITY",@"FEDEX_1_DAY_FREIGHT",@"FEDEX_2_DAY",@"FEDEX_2_DAY_AM",@"FEDEX_2_DAY_FREIGHT",@"FEDEX_3_DAY_FREIGHT",@"FEDEX_DISTANCE_DEFERRED",@"FEDEX_EXPRESS_SAVER",@"FEDEX_FIRST_FREIGHT",@"FEDEX_FREIGHT_ECONOMY",@"FEDEX_FREIGHT_PRIORITY",@"FEDEX_GROUND",@"FEDEX_NEXT_DAY_AFTERNOON",@"FEDEX_NEXT_DAY_EARLY_MORNING",@"FEDEX_NEXT_DAY_END_OF_DAY",@"FEDEX_NEXT_DAY_FREIGHT",@"FEDEX_NEXT_DAY_MID_MORNING",@"FIRST_OVERNIGHT",@"GROUND_HOME_DELIVERY",@"INTERNATIONAL_ECONOMY",@"INTERNATIONAL_ECONOMY_FREIGHT",@"INTERNATIONAL_FIRST",@"INTERNATIONAL_PRIORITY",@"INTERNATIONAL_PRIORITY_FREIGHT",@"PRIORITY_OVERNIGHT",@"SAME_DAY",@"SAME_DAY_CITY",@"SMART_POST", @"STANDARD_OVERNIGHT",nil];
    pickTableController.cellTextFont =  [ UIFont fontWithName: @"Arial" size: 14.0 ];
    pickTableController.tableView.scrollEnabled = YES;
    pickTableController.preferredContentSize = CGSizeMake(280, (pickTableController.list.count+1)*44);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    barItem.title = @"完成";
    barItem.tintColor = [UIColor whiteColor];
    barItem.target = self;
    barItem.tag = 1;
    barItem.action = @selector(done:);
    [pickTableController.navigationItem setRightBarButtonItem:barItem];
    pickTableController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    pickTableController.modalInPopover = NO;
    UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:pickTableController];
    [contentViewController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:22.0f],NSFontAttributeName, [UIColor whiteColor] ,NSForegroundColorAttributeName ,nil]];
    destinationpopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    destinationpopoverController.theme = [WYPopoverTheme themeForIOS6];
    destinationpopoverController.delegate = self;
    destinationpopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    [destinationpopoverController presentPopoverAsDialogAnimated:YES];
}

- (IBAction)done:(id)sender{
    [destinationpopoverController dismissPopoverAnimated:YES];
    destinationpopoverController.delegate = nil;
    destinationpopoverController = nil;
    if(pickTableController != nil){
        NSString *picked = pickTableController.selectedOne;
        methodTextField.text = picked;
    }
    pickTableController = nil;
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

- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    const int movementDistance = textView.frame.origin.y / 2; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WYPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == destinationpopoverController)
    {
        destinationpopoverController.delegate = nil;
        destinationpopoverController = nil;
        pickTableController = nil;
    }
}

#pragma TextFieldDelegate implementation

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag == 3){
        [self pickNextStep];
        return NO;
    }
    else{
    return YES;
    }
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
        [itemQuantity becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 1){
        [itemQuantity resignFirstResponder];
        return YES;
    }
    return NO;
}

#pragma TextViewDelegate implementation

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self animateTextView:textView up:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self animateTextView:textView up:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
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
