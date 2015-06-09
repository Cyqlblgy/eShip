//
//  FindViewController.m
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "FindViewController.h"
#import "WYTableViewViewController.h"
#import "CheckPriceViewController.h"
#import "BLParams.h"
#import "BLNetwork.h"
#import "SVProgressHUD.h"
#import "TrackingDetailViewController.h"

@interface FindViewController (){
    ZBarReaderViewController *reader;
    WYPopoverController* popoverController;
    WYTableViewViewController *tableController;
    NSDictionary *detailData;
}

@end

@implementation FindViewController
@synthesize shipNumberTextField,scanButton,getListButton,carrierTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"快递追踪";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    CGRect frame = shipNumberTextField.frame;
    shipNumberTextField.tag =0;
    carrierTextField.tag =1;
    scanButton.frame = CGRectMake(frame.origin.x+frame.size.width+ 11 , frame.origin.y, 40, 40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    detailData = nil;
   [self.navigationController navigationBar].hidden = NO;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanNumber:(id)sender {
    reader = [[ZBarReaderViewController alloc] init];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentViewController:reader animated:YES completion:nil];
}

- (IBAction)getCarrierList:(id)sender {
    if(popoverController == nil && tableController == nil){
    tableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CarrierListTableView"];
    tableController.title = @"快递公司";
    tableController.list = [[NSArray alloc] initWithObjects:@"FedEX",@"UPS",nil];
    tableController.preferredContentSize = CGSizeMake(280, (tableController.list.count+1)*44);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    barItem.title = @"完成";
    barItem.target = self;
    barItem.action = @selector(done:);
    [tableController.navigationItem setRightBarButtonItem:barItem];
    tableController.modalInPopover = NO;
    UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:tableController];
    popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    popoverController.delegate = self;
    popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    CGRect rect = getListButton.bounds;
    [popoverController presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.5, rect.size.height) inView:getListButton permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    }
    else{
        [self done:nil];
    }
}

- (IBAction)startTracking:(id)sender {
    [self.view endEditing:YES];
    NSString *requestType = [[NSString alloc] initWithFormat:@"user/%@?carrier=%@&trackingNum=%@",BLParameters.NetworkTrack,carrierTextField.text.lowercaseString,shipNumberTextField.text.lowercaseString];
    [SVProgressHUD showWithStatus:@"Tracking" maskType:SVProgressHUDMaskTypeGradient];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodGet andrequestType:requestType andParams:nil andMaxTimeOut:20 andAcceptType:nil andAuthorization:nil andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        [SVProgressHUD dismiss];
        if(res.statusCode == BLNetworkTrackSuccess){
            NSError *e = nil;
            detailData = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&e];
            [self performSegueWithIdentifier:@"trackIdentifier" sender:self];
        }
        else{
            NSString *errorMessage= nil;
            NSString *errorTitle = @"出错了";
        if(res.statusCode == BLNetworkTrackCarrierNotFound){
            errorMessage = @"无此快递公司";
        }
        else if(res.statusCode == BLNetworkTrackNumberNotFound){
           errorMessage = @"无此快递号";
        }
        else{
            errorMessage = @"追踪过程中出错了";
        }
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:errorTitle
                                          message:errorMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


- (IBAction)done:(id)sender{
    [popoverController dismissPopoverAnimated:YES];
    popoverController.delegate = nil;
    popoverController = nil;
    if(tableController != nil){
        carrierTextField.text = tableController.selectedOne;
    }
    tableController = nil;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return detailData != nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"trackIdentifier"])
    {
        TrackingDetailViewController *vc = [segue destinationViewController];
        vc.parcelDetail = detailData;
        vc.carrier = carrierTextField.text;
    }
}


#pragma ZBarReaderDelegate
- (void)handleCodes:(ZBarSymbolSet *)zcodes{
    for (ZBarSymbol *symbol in zcodes) {
        shipNumberTextField.text = symbol.data;
        [reader dismissViewControllerAnimated:YES completion:nil];
        break;
    }
}

#pragma mark - WYPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == popoverController)
    {
        popoverController.delegate = nil;
        popoverController = nil;
        if(tableController != nil){
            carrierTextField.text = tableController.selectedOne;
        }
        tableController = nil;
    }
}


#pragma UITextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag==1){
        [self getCarrierList:nil];
        [self.view endEditing:YES];
        return NO;
    }
    else{
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
