//
//  ShipViewController.m
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "ShipViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"
#import "BLCoreData.h"
#import "TSLocateView.h"
#import "AddressViewController.h"
#import "ItemViewController.h"
#import "SVProgressHUD.h"
#import "WYPopoverController.h"
#import "WYTableViewViewController.h"
#import "ContactViewController.h"

@interface ShipViewController (){
    WYPopoverController* carrierpopoverController;
    WYTableViewViewController *carrierTableController;
    NSArray *rateResults;
    NSString *usrnm,*pswd;
}

@end

@implementation ShipViewController

@synthesize originalButton,originalPlaceTextField,destinationButton,destinationPlaceTextField,itemTypeButton,itemTypeTextField,carrierTextField,carrierButton,shipButton,rateObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约寄件";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [originalButton setFrame:CGRectMake(0, 0, 40, originalPlaceTextField.frame.size.height)];
    [originalButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [destinationButton setFrame:CGRectMake(0, 0, 40, destinationPlaceTextField.frame.size.height)];
    [destinationButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [itemTypeButton setFrame:CGRectMake(0, 0, 40, itemTypeTextField.frame.size.height)];
    [itemTypeButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [carrierButton setFrame:CGRectMake(0, 0, 40, itemTypeTextField.frame.size.height)];
    [carrierButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [carrierButton addTarget:self action:@selector(getCarrierList:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, originalPlaceTextField.frame.size.height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label.text = @"原寄地";
    [view addSubview:label];
    originalPlaceTextField.leftView = view;
    originalPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    originalPlaceTextField.rightView = originalButton;
    originalPlaceTextField.rightViewMode = UITextFieldViewModeAlways;
    originalPlaceTextField.tag = 0;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, originalPlaceTextField.frame.size.height)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label1.text = @"目的地";
    [view1 addSubview:label1];
    destinationPlaceTextField.leftView = view1;
    destinationPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    destinationPlaceTextField.rightView = destinationButton;
    destinationPlaceTextField.rightViewMode = UITextFieldViewModeAlways;
    destinationPlaceTextField.tag = 1;
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, originalPlaceTextField.frame.size.height)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label2.text = @"包裹信息";
    [view2 addSubview:label2];
    itemTypeTextField.leftView = view2;
    itemTypeTextField.leftViewMode = UITextFieldViewModeAlways;
    itemTypeTextField.rightView = itemTypeButton;
    itemTypeTextField.rightViewMode= UITextFieldViewModeAlways;
    itemTypeTextField.tag = 2;
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, carrierTextField.frame.size.height)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, carrierTextField.frame.size.height)];
    label3.text = @"包裹信息";
    [view3 addSubview:label3];
    carrierTextField.leftView = view3;
    carrierTextField.leftViewMode = UITextFieldViewModeAlways;
    carrierTextField.rightView = carrierButton;
    carrierTextField.rightViewMode= UITextFieldViewModeAlways;
    carrierTextField.tag = 3;

    
    shipButton.layer.cornerRadius = 5;
    shipButton.layer.masksToBounds = YES;
    rateObject = [[BLRateObject alloc] init];

}

- (void)viewWillAppear:(BOOL)animated{
    if(rateObject.originalAddress){
        originalPlaceTextField.text = [[NSString alloc] initWithFormat:@"%@ %@",[rateObject.originalAddress objectForKey:@"countryName"],[rateObject.originalAddress objectForKey:@"city"]];
    }
    if(rateObject.destinationAddress){
        destinationPlaceTextField.text = [[NSString alloc] initWithFormat:@"%@ %@",[rateObject.destinationAddress objectForKey:@"countryName"],[rateObject.destinationAddress objectForKey:@"city"]];
    }
    if(rateObject.size){
        itemTypeTextField.text = [[NSString alloc] initWithFormat:@"%@*%@*%@ %@",[rateObject.size objectForKey:@"length"],[rateObject.size objectForKey:@"width"],[rateObject.size objectForKey:@"height"], [rateObject.size objectForKey:@"unit"]];
    }
    shipButton.enabled = rateObject.size && rateObject.originalAddress && rateObject.destinationAddress;
    NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
    if(currentUser){
        usrnm =  [currentUser valueForKey:@"userName"];
        pswd = [currentUser valueForKey:@"passWord"];
    }
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"未登录"
                                      message:@"请先登录再进行查询"
                                      preferredStyle:UIAlertControllerStyleAlert];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"oAddress"] || [identifier isEqualToString:@"dAddress"] || [identifier isEqualToString:@"iIdentifier"] || [identifier isEqualToString:@"shipAction"]){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"oAddress"])
    {
        AddressViewController *vc = [segue destinationViewController];
        vc.rateObject = rateObject;
        vc.isShip = YES;
        vc.isOriginal = YES;
    }
    else if([[segue identifier] isEqualToString:@"dAddress"]){
        AddressViewController *vc = [segue destinationViewController];
        vc.rateObject = rateObject;
        vc.isOriginal = NO;
        vc.isShip = YES;
    }
    else if([[segue identifier] isEqualToString:@"iIdentifier"]){
        ItemViewController *vc = [segue destinationViewController];
        vc.rateObject = rateObject;
    }
    else if([[segue identifier] isEqualToString:@"shipAction"]){
        ContactViewController *vc = [segue destinationViewController];
        vc.rateObject = rateObject;
        vc.shipCarrier = [carrierTextField.text lowercaseString];
    }
    
}

- (IBAction)getCarrierList:(id)sender {
    if(carrierpopoverController == nil && carrierTableController == nil){
        carrierTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CarrierListTableView"];
        carrierTableController.title = @"快递公司";
        carrierTableController.list = [[NSArray alloc] initWithObjects:@"FedEX",@"UPS",nil];
        carrierTableController.preferredContentSize = CGSizeMake(280, (carrierTableController.list.count+1)*44);
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        barItem.title = @"完成";
        barItem.target = self;
        barItem.action = @selector(done:);
        [carrierTableController.navigationItem setRightBarButtonItem:barItem];
        carrierTableController.modalInPopover = NO;
        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:carrierTableController];
        carrierpopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        carrierpopoverController.delegate = self;
        carrierpopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        CGRect rect = carrierButton.bounds;
        [carrierpopoverController presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.5, rect.size.height) inView:carrierButton permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    }
    else{
        [self done:nil];
    }
}

- (IBAction)done:(id)sender{
    [carrierpopoverController dismissPopoverAnimated:YES];
    carrierpopoverController.delegate = nil;
    carrierpopoverController = nil;
    if(carrierTableController != nil){
        carrierTextField.text = carrierTableController.selectedOne;
    }
    carrierTableController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == carrierpopoverController)
    {
        carrierpopoverController.delegate = nil;
        carrierpopoverController = nil;
        if(carrierTableController != nil){
            carrierTextField.text = carrierTableController.selectedOne;
        }
        carrierTableController = nil;
    }
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag == 0){
        [self performSegueWithIdentifier:@"oAddress" sender:self];
    }
    else if(textField.tag == 1){
        [self performSegueWithIdentifier:@"dAddress" sender:self];
    }
    else if(textField.tag == 2){
        [self performSegueWithIdentifier:@"iIdentifier" sender:self];
    }
    else if(textField.tag == 3){
        [self getCarrierList:nil];
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

//- (IBAction)ship:(id)sender {
//    NSData *plainData = [@"zhouhao:950288" dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
//    NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];
//
//        NSArray *streetLines1 = [[NSArray alloc] initWithObjects:@"东川路800号", nil];
//        NSDictionary *senderAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                       @"Shanghai",@"city",
//                                       @"SH",@"stateOrProvinceCode",
//                                       @"200240",@"postalCode",
//                                       [NSNull null],@"urbanizationCode",
//                                       @"CN",@"countryCode",
//                                       [NSNull null],@"countryName",
//                                       [NSNumber numberWithBool:NO],@"residential",
//                                       streetLines1,@"streetLines",
//                                       nil];
//        NSArray *streetLines2 = [[NSArray alloc] initWithObjects:@"269 Mill Rd", nil];
//        NSDictionary *receiverAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                       @"Chelmsford",@"city",
//                                       @"MA",@"stateOrProvinceCode",
//                                       @"01824",@"postalCode",
//                                       [NSNull null],@"urbanizationCode",
//                                       @"US",@"countryCode",
//                                       [NSNull null],@"countryName",
//                                       [NSNumber numberWithBool:NO],@"residential",
//                                       streetLines2,@"streetLines",
//                                       nil];
//        NSDictionary *size = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                         [NSNumber numberWithInt:108],@"length",
//                                         [NSNumber numberWithInt:5],@"width",
//                                         [NSNumber numberWithInt:5],@"height",
//                                         @"CM",@"units",
//                                         nil];
//       NSDictionary *weightObject = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            @"KG",@"value",
//                            nil];
//        NSDictionary *weight = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              [NSNumber numberWithInt:1],@"value",
//                              weightObject,@"units",
//                              nil];
//    
//        NSDictionary *value = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                @"CNY",@"currency",
//                                [NSNumber numberWithFloat:100],@"amount",
//                                nil];
//    NSDictionary *contact1 = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          @"Zhang Laosan",@"personName",
//                          @"02188888888",@"phoneNumber",
//                          @"zls@hotmail.com",@"emailAddress",
//                          nil];
//    NSDictionary *contact2 = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              @"James Cook",@"personName",
//                              @"4123560000",@"phoneNumber",
//                              nil];
//    long long i = (long long)[[NSDate date] timeIntervalSince1970]* 1000.0;
//    NSDictionary *responsibleParty = [[NSDictionary alloc] initWithObjectsAndKeys:
//                               @"510087682",@"accountNumber",
//                               contact1,@"contact",
//                               senderAddress,@"address",
//                               nil];
//    NSDictionary *dutyPayor = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                responsibleParty,@"responsibleParty",
//                              nil];
//    NSDictionary *commodity = [[NSDictionary alloc] initWithObjectsAndKeys:
//                               [NSNumber numberWithInt:1],@"numberOfPieces",
//                               @"China",@"countryOfManufacture",
//                               @"Books",@"description",
//                               weight, @"weight",
//                               [NSNumber numberWithInt:1],@"quantity",
//                               @"EA",@"quantityUnits",
//                               value,@"unitPrice",
//                               value,@"customsValue",
//                               nil];
//    NSArray *commodities = [[NSArray alloc] initWithObjects:commodity, nil];
//    
//    
//    /*Unnecessary customerRefrence*/
//    
//    NSDictionary *customerReference1 = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                        @"CUSTOMER_REFERENCE",@"customerReferenceType",
//                                        @"CR1234", @"value",
//                                        nil];
//    NSDictionary *customerReference2 = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                        @"INVOICE_NUMBER",@"customerReferenceType",
//                                        @"IV1234", @"value",
//                                        nil];
//    NSDictionary *customerReference3 = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                        @"P_O_NUMBER",@"customerReferenceType",
//                                        @"PO1234", @"value",
//                                        nil];
//    NSArray *customerReferences = [[NSArray alloc] initWithObjects:customerReference1,customerReference2,customerReference3, nil];
//    
//    
//    NSDictionary *packageLineitem = [[NSDictionary alloc] initWithObjectsAndKeys:
//                               [NSNumber numberWithInt:1],@"sequenceNumber",
//                               [NSNumber numberWithInt:1],@"groupPackageCount",
//                               weight,@"weight",
//                               size,@"dimensions",
//                             //  customerReferences,@"customerReferences",
//                               nil];
//    NSArray *packageLineitems = [[NSArray alloc] initWithObjects:packageLineitem, nil];
//    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                    @"Fedex",@"carrier",
//                                    [NSNumber numberWithLongLong:i],@"shipDate",
//                                    @"INTERNATIONAL_PRIORITY",@"serviceType",
//                                    @"REGULAR_PICKUP",@"dropoffType",
//                                    @"YOUR_PACKAGING",@"packagingType",
//                                    contact1,@"senderContact",
//                                    senderAddress,@"senderAddress",
//                                    contact2,@"recipientContact",
//                                    receiverAddress,@"recipientAddress",
//                                    @"510087682",@"accountNumber",
//                                    @"SENDER", @"paymentType",
//                                    [NSNull null], @"responsibleParty",
//                                    @"SENDER", @"dutyPaymentType",
//                                    dutyPayor, @"dutyPayor",
//                                    value, @"customValue",
//                                    @"NON_DOCUMENTS",@"documentContentType",
//                                    commodities, @"commodities",
//                                    [NSNumber numberWithInt:1],@"packageNum",
//                                    packageLineitems,@"packageLineItems",
//                                    nil];
//    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkShip andParams:jsonDictionary andMaxTimeOut:40 andAcceptType:nil andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//        NSData *wwww= data;
////        if(res.statusCode == BLNetworkRateSuccess){
////            rateResults = [NSJSONSerialization JSONObjectWithData:data
////                                                          options:NSJSONReadingMutableContainers
////                                                            error:&e];
////            if(rateResults.count != 0){
////                [self performSegueWithIdentifier:@"checkIdentifier" sender:self];
////            }
////        }
//    }];
//
//}
@end
