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
    ZBarReaderViewController *myreader;
    WYPopoverController* popoverController;
    WYTableViewViewController *tableController;
    NSDictionary *detailData;
    UIButton *getListButton,*scanButton;
}

@end

@implementation FindViewController
@synthesize shipNumberTextField,carrierTextField,searchButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"快递追踪";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    shipNumberTextField.tag =0;
    carrierTextField.tag =1;

    searchButton.layer.cornerRadius = 5;
    searchButton.layer.masksToBounds = YES;
    UIImage *numberImage = [UIImage imageNamed:@"shipNumber"];
    UIView *leftViewForNumber = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, numberImage.size.height)];
    UIImageView *imageViewForNumber = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,numberImage.size.width, numberImage.size.height)];
    [imageViewForNumber setCenter:leftViewForNumber.center];
    [imageViewForNumber setImage:numberImage];
    [leftViewForNumber addSubview:imageViewForNumber];
    shipNumberTextField.leftView = leftViewForNumber;
    shipNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *numberImage1 = [UIImage imageNamed:@"scanner"];
    UIView *rightViewForNumber = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, numberImage1.size.height)];
    scanButton = [[UIButton alloc] initWithFrame:CGRectMake(60,0,numberImage1.size.width, numberImage1.size.height)];
    [scanButton addTarget:self action:@selector(scanNumber:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton setCenter:rightViewForNumber.center];
    [scanButton setBackgroundImage:numberImage1 forState:UIControlStateNormal];
    [rightViewForNumber addSubview:scanButton];
    shipNumberTextField.rightView = rightViewForNumber;
    shipNumberTextField.rightViewMode = UITextFieldViewModeAlways;
    shipNumberTextField.layer.borderColor=[[UIColor whiteColor]CGColor];
    shipNumberTextField.layer.borderWidth= 0.1f;
    
    UIImage *carrierImage = [UIImage imageNamed:@"carrier"];
    UIView *leftViewForCarrier = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, carrierImage.size.height)];
    UIImageView *imageViewForCarrier = [[UIImageView alloc] initWithFrame:CGRectMake(60,0,carrierImage.size.width, carrierImage.size.height)];
    [imageViewForCarrier setCenter:leftViewForCarrier.center];
    [imageViewForCarrier setImage:carrierImage];
    [leftViewForCarrier addSubview:imageViewForCarrier];
    carrierTextField.leftView = leftViewForCarrier;
    carrierTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *carrierImage1 = [UIImage imageNamed:@"next"];
    UIView *rightViewForCarrier = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, carrierImage1.size.height)];
    getListButton = [[UIButton alloc] initWithFrame:CGRectMake(60,0,carrierImage1.size.width, carrierImage1.size.height)];
    [getListButton addTarget:self action:@selector(getCarrierList:) forControlEvents:UIControlEventTouchUpInside];
    [getListButton setCenter:rightViewForCarrier.center];
    [getListButton setBackgroundImage:carrierImage1 forState:UIControlStateNormal];
    [rightViewForCarrier addSubview:getListButton];
    carrierTextField.rightView = rightViewForCarrier;
    carrierTextField.rightViewMode = UITextFieldViewModeAlways;

    carrierTextField.layer.borderColor=[[UIColor whiteColor]CGColor];
    carrierTextField.layer.borderWidth= 0.1f;
    
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
    myreader = [[ZBarReaderViewController alloc] init];
    myreader.readerDelegate = self;
    myreader.supportedOrientationsMask = ZBarOrientationMaskAll;
    myreader.showsCameraControls = NO;
    myreader.showsZBarControls = NO;
    ZBarImageScanner *scanner = myreader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self.navigationController pushViewController:myreader animated:YES];
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
    [SVProgressHUD showWithStatus:@"快件追踪中" maskType:SVProgressHUDMaskTypeGradient];
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
        [self.navigationController popViewControllerAnimated:YES];
        break;
    }
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
    [self.navigationController popViewControllerAnimated:YES];
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
