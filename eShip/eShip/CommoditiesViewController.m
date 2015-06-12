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

@interface CommoditiesViewController ()<UIDocumentInteractionControllerDelegate>{
    BOOL isShown;
}

@end

@implementation CommoditiesViewController

@synthesize itemCountry,itemDescription,itemQuantity,shipObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    isShown = NO;
    self.navigationItem.title = @"物品信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(goShip)];
    itemCountry.tag = 0;
    itemQuantity.tag = 1;
    itemDescription.layer.borderWidth = 1.0f;
    itemDescription.layer.cornerRadius = 5.0f;
    itemDescription.layer.masksToBounds = YES;
    itemDescription.layer.borderColor = [[UIColor grayColor] CGColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    if(isShown){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)goShip{
    [self.view endEditing:YES];
    NSDictionary *commodity = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInt:itemQuantity.text.intValue],@"numberOfPieces",
                               itemCountry.text,@"countryOfManufacture",
                               itemDescription.text,@"description",
                               [NSNumber numberWithInt:itemQuantity.text.intValue],@"quantity",
                               @"EA",@"quantityUnits",
                               nil];
    [shipObject setCommodities:commodity];
    NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
    if(currentUser){
        NSString *usrnm = [currentUser valueForKey:@"userName"];
        NSString *pswd= [currentUser valueForKey:@"passWord"];
        NSString *authStr = [[NSString alloc] initWithFormat:@"%@:%@",usrnm,pswd];
        NSData *plainData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];
        long long i = (long long)[[NSDate date] timeIntervalSince1970]* 1000.0;
        NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"Fedex",@"carrier",
                                        [NSNumber numberWithLongLong:i],@"shipDate",
                                        @"INTERNATIONAL_PRIORITY",@"serviceType",
                                        @"REGULAR_PICKUP",@"dropoffType",
                                        @"YOUR_PACKAGING",@"packagingType",
                                        shipObject.senderContact,@"senderContact",
                                        shipObject.senderAddress,@"senderAddress",
                                        shipObject.recipientContact,@"recipientContact",
                                        shipObject.receiverAddress,@"recipientAddress",
                                        @"510087682",@"accountNumber",
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
        [SVProgressHUD showWithStatus:@"下单中..." maskType:SVProgressHUDMaskTypeGradient];
        [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkShip andParams:jsonDictionary andMaxTimeOut:40 andAcceptType:nil andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                     }];
                UIAlertAction* showReceipt = [UIAlertAction
                                     actionWithTitle:@"显示快递单"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action){
                                         NSString *str = [[NSString alloc] initWithFormat:@"%@%@",BLParameters.NetworkGetLabel,trackingNumber];
                                         [SVProgressHUD showWithStatus:@"生成PDF文档中..." maskType:SVProgressHUDMaskTypeGradient];
                                         [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodGet andrequestType:str andParams:nil andMaxTimeOut:40 andAcceptType:@"application/pdf" andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                             [SVProgressHUD dismiss];
                                             NSString * newFilePath = [[self documentPath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@.pdf",trackingNumber]];
                                             BOOL isWriteSuccess = [data writeToFile:newFilePath atomically:YES];
                                             NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                                             if(res.statusCode == 200 && isWriteSuccess){
                                                 NSURL *URL = [NSURL fileURLWithPath:newFilePath];
                                                 
                                                 if (URL) {
                                                     isShown = YES;
                                                     // Initialize Document Interaction Controller
                                                     UIDocumentInteractionController *documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
                                                     
                                                     // Configure Document Interaction Controller
                                                     [documentInteractionController setDelegate:self];
                                                     
                                                     // Preview PDF
                                                     [documentInteractionController presentPreviewAnimated:YES];
                                                 }
                                             }
                                             else{
                                                 UIAlertController * alert1=   [UIAlertController
                                                                               alertControllerWithTitle:@"出错了"
                                                                               message:@"PDF生成过程中出错了"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                 UIAlertAction* ok1 = [UIAlertAction
                                                                      actionWithTitle:@"OK"
                                                                      style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action){
                                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                                      }];
                                                 [alert1 addAction:ok1];
                                                 [self presentViewController:alert1 animated:YES completion:nil];
                                             }
                                         }];
                                     }];
                [alert addAction:showReceipt];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else{
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"出错了"
                                              message:@"在邮寄过程中出错了，请稍后再试"
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action){
                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    

    
    
}

- (NSString *)documentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return documentPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self.navigationController;
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
   [self.view endEditing:YES];
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
