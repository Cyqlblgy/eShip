//
//  CheckPriceViewController.m
//  eShip
//
//  Created by Bin Lang on 5/10/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "CheckPriceViewController.h"
#import "WYPopoverController.h"
#import "WYTableViewViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"
#import "BLCoreData.h"
#import "TSLocateView.h"
#import "AddressViewController.h"
#import "ItemViewController.h"
#import "RateResultViewController.h"
#import "SVProgressHUD.h"

@interface CheckPriceViewController (){
    WYPopoverController* originalpopoverController;
    WYPopoverController* destinationpopoverController;
    WYPopoverController* itemtypepopoverController;
    WYTableViewViewController *originalTableController;
    WYTableViewViewController *destinationTableController;
    WYTableViewViewController *itemtypeTableController;
    NSArray *rateResults;
    NSString *usrnm,*pswd;
}

@end

@implementation CheckPriceViewController

@synthesize originalPlaceTextField,destinationPlaceTextField,itemTypeTextField,searchButton,originalButton,destinationButton,itemTypeButton,rateObject;

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
    
    searchButton.layer.cornerRadius = 5;
    searchButton.layer.masksToBounds = YES;
    
    rateObject = [[BLRateObject alloc] init];
    NSDictionary *rate1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"USD",@"currency",
                          @"117.29",@"amount",
                          nil];
    NSDictionary *fe = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"Fedex",@"carrier",
                          rate1 ,@"rate",
                        [NSNumber numberWithInt:1],@"transitDays",
                        nil];
    NSDictionary *rate2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"RMB",@"currency",
                           @"558.63",@"amount",
                           nil];
    NSDictionary *fe1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"UPS",@"carrier",
                        rate2 ,@"rate",
                        [NSNumber numberWithInt:1],@"transitDays",
                        nil];
   // rateResults = [[NSArray alloc] initWithObjects:fe,fe1,nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController navigationBar].hidden = NO;
    if(rateObject.originalAddress){
        originalPlaceTextField.text = [[NSString alloc] initWithFormat:@"%@ %@",[rateObject.originalAddress objectForKey:@"countryName"],[rateObject.originalAddress objectForKey:@"city"]];
    }
    if(rateObject.destinationAddress){
        destinationPlaceTextField.text = [[NSString alloc] initWithFormat:@"%@ %@",[rateObject.destinationAddress objectForKey:@"countryName"],[rateObject.destinationAddress objectForKey:@"city"]];
    }
    if(rateObject.size){
        itemTypeTextField.text = [[NSString alloc] initWithFormat:@"%@*%@*%@ %@",[rateObject.size objectForKey:@"length"],[rateObject.size objectForKey:@"width"],[rateObject.size objectForKey:@"height"], [rateObject.size objectForKey:@"unit"]];
    }
    searchButton.enabled = rateObject.size && rateObject.originalAddress && rateObject.destinationAddress;
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

- (void)viewWillDisappear:(BOOL)animated{
    rateResults = nil;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SearchPrice:(id)sender {
    NSString *authStr = [[NSString alloc] initWithFormat:@"%@:%@",usrnm,pswd];
    NSData *plainData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];
//    NSArray *streetLines1 = [[NSArray alloc] initWithObjects:@"东川路800号", nil];
//    NSDictionary *senderAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                   @"Shanghai",@"city",
//                                   @"SH",@"stateOrProvinceCode",
//                                   @"200240",@"postalCode",
//                                   [NSNull null],@"urbanizationCode",
//                                   @"CN",@"countryCode",
//                                   [NSNull null],@"countryName",
//                                   [NSNumber numberWithBool:NO],@"residential",
//                                   streetLines1,@"streetLines",
//                                   nil];
//    NSArray *streetLines2 = [[NSArray alloc] initWithObjects:@"269 Mill Rd", nil];
//    NSDictionary *receiverAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                   @"Chelmsford",@"city",
//                                   @"MA",@"stateOrProvinceCode",
//                                   @"01824",@"postalCode",
//                                   [NSNull null],@"urbanizationCode",
//                                   @"US",@"countryCode",
//                                   [NSNull null],@"countryName",
//                                   [NSNumber numberWithBool:NO],@"residential",
//                                   streetLines2,@"streetLines",
//                                   nil];
//    NSDictionary *size = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                     [NSNumber numberWithInt:10],@"length",
//                                     [NSNumber numberWithInt:10],@"width",
//                                     [NSNumber numberWithInt:10],@"height",
//                                     @"CM",@"unit",
//                                     nil];
//    NSDictionary *weight = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          [NSNumber numberWithFloat:1.1999999999999999555910790149937383830547332763671875],@"weight",
//                          @"KG",@"unit",
//                          nil];
//    NSDictionary *value = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            @"CNY",@"currency",
//                            [NSNumber numberWithFloat:3000],@"amount",
//                            nil];
    long long i = (long long)[[NSDate date] timeIntervalSince1970]* 1000.0;
    NSMutableDictionary *originalAddress1 = [rateObject.originalAddress mutableCopy];
    [originalAddress1 setValue:[NSNull null] forKey:@"countryName"];
    NSMutableDictionary *destinyAddress1 = [rateObject.destinationAddress mutableCopy];
    [destinyAddress1 setValue:[NSNull null] forKey:@"countryName"];
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    originalAddress1,@"senderAddress",
                                    destinyAddress1,@"recipientAddress",
                                    rateObject.size,@"size",
                                    rateObject.weight,@"weight",
                                    rateObject.value,@"value",
                                    [NSNumber numberWithLongLong:i],@"shipTime",
                                    nil];
    [SVProgressHUD showWithStatus:@"查询价格中" maskType:SVProgressHUDMaskTypeGradient];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkRate andParams:jsonDictionary andMaxTimeOut:40 andAcceptType:nil andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        NSError *e = nil;
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if(res.statusCode == BLNetworkRateSuccess){
         rateResults = [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingMutableContainers
                                          error:&e];
            if(rateResults.count != 0){
               [self performSegueWithIdentifier:@"checkIdentifier" sender:self];
            }
        }
        else if (res.statusCode == BLNetworkRateBadRequest){
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"出错了"
                                          message:@"当前eShip账号没有绑定快递运营商的账号"
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"知道了"
                                 style:UIAlertActionStyleDefault
                                 handler:nil];
            UIAlertAction* goback = [UIAlertAction
                                     actionWithTitle:@"去注册"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action){
                                         [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"] animated:YES];
                                     }];
            [alert addAction:goback];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (res.statusCode == BLNetworkRateBadRequest){
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"出错了"
                                          message:@"价格查询中出现了错误，请稍后再试"
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"知道了"
                                 style:UIAlertActionStyleDefault
                                 handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }

    }];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"originalAddress"] || [identifier isEqualToString:@"destinationAddress"] || [identifier isEqualToString:@"itemIdentifier"]){
        return YES;
    }
    else{
        return rateResults!=nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"originalAddress"])
    {
        AddressViewController *vc = [segue destinationViewController];
        vc.rateObject = rateObject;
        vc.isOriginal = YES;
    }
    else if([[segue identifier] isEqualToString:@"destinationAddress"]){
        AddressViewController *vc = [segue destinationViewController];
        vc.rateObject = rateObject;
        vc.isOriginal = NO;
    }
    else if([[segue identifier] isEqualToString:@"itemIdentifier"]){
        ItemViewController *vc = [segue destinationViewController];
        vc.rateObject = rateObject;
    }
    else if([[segue identifier] isEqualToString:@"checkIdentifier"]){
        RateResultViewController *vc = [segue destinationViewController];
        vc.shipInfo = rateResults;
        vc.rateObject = rateObject;
    }
    
}


#pragma Prive methods

- (void)getOriginalList{
    if(originalpopoverController == nil && originalTableController == nil){
        originalTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CarrierListTableView"];
        originalTableController.title = @"原寄地";
        originalTableController.list = [[NSArray alloc] initWithObjects:@"浙江",@"上海",@"北京",@"广州",@"深圳", nil];
        originalTableController.preferredContentSize = CGSizeMake(280, (originalTableController.list.count+1)*44);
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        barItem.title = @"完成";
        barItem.target = self;
        barItem.tag = 0;
        barItem.action = @selector(done:);
        [originalTableController.navigationItem setRightBarButtonItem:barItem];
        originalTableController.modalInPopover = NO;
        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:originalTableController];
        originalpopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        originalpopoverController.delegate = self;
        originalpopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        CGRect rect = originalButton.bounds;
        [originalpopoverController presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.5, rect.size.height) inView:originalButton permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    }
    else{
        [self done:nil];
    }
}

- (void)getDestinationList{
    if(destinationpopoverController == nil && destinationTableController == nil){
        destinationTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CarrierListTableView"];
        destinationTableController.title = @"目的地";
        destinationTableController.list = [[NSArray alloc] initWithObjects:@"浙江",@"上海",@"北京",@"广州",@"深圳", nil];
        destinationTableController.preferredContentSize = CGSizeMake(280, (destinationTableController.list.count+1)*44);
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        barItem.title = @"完成";
        barItem.target = self;
        barItem.tag = 1;
        barItem.action = @selector(done:);
        [destinationTableController.navigationItem setRightBarButtonItem:barItem];
        destinationTableController.modalInPopover = NO;
        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:destinationTableController];
        destinationpopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        destinationpopoverController.delegate = self;
        destinationpopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        CGRect rect = destinationButton.bounds;
        [destinationpopoverController presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.5, rect.size.height) inView:destinationButton permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    }
    else{
        [self done:nil];
    }
}

- (void)getItemTypeList{
    if(itemtypepopoverController == nil && itemtypeTableController == nil){
        itemtypeTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CarrierListTableView"];
        itemtypeTableController.title = @"物品类型";
        itemtypeTableController.list = [[NSArray alloc] initWithObjects:@"化妆品",@"保健品",@"电子产品",@"食品",@"衣物", nil];
        itemtypeTableController.preferredContentSize = CGSizeMake(280, (itemtypeTableController.list.count+1)*44);
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        barItem.title = @"完成";
        barItem.target = self;
        barItem.tag = 2;
        barItem.action = @selector(done:);
        [itemtypeTableController.navigationItem setRightBarButtonItem:barItem];
        itemtypeTableController.modalInPopover = NO;
        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:itemtypeTableController];
        itemtypepopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        itemtypepopoverController.delegate = self;
        itemtypepopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        CGRect rect = itemTypeButton.bounds;
        [itemtypepopoverController presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.5, rect.size.height) inView:itemTypeButton permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    }
    else{
        [self done:nil];
    }

}

- (IBAction)done:(id)sender{
    if(sender){
        UIBarButtonItem *item = (UIBarButtonItem *)sender;
        if(item.tag == 0){
            [originalpopoverController dismissPopoverAnimated:YES];
            originalpopoverController.delegate = nil;
            originalpopoverController = nil;
            if(originalTableController != nil){
                originalPlaceTextField.text = originalTableController.selectedOne;
            }
            originalTableController = nil;
        }
        else if(item.tag == 1){
            [destinationpopoverController dismissPopoverAnimated:YES];
            destinationpopoverController.delegate = nil;
            destinationpopoverController = nil;
            if(destinationTableController != nil){
                destinationPlaceTextField.text = destinationTableController.selectedOne;
            }
            destinationTableController = nil;
        }
        else if(item.tag == 2){
            [itemtypepopoverController dismissPopoverAnimated:YES];
            itemtypepopoverController.delegate = nil;
            itemtypepopoverController = nil;
            if(itemtypeTableController != nil){
                itemTypeTextField.text = itemtypeTableController.selectedOne;
            }
            itemtypeTableController = nil;
            
        }
    }
}

#pragma mark - WYPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == originalpopoverController)
    {
        originalpopoverController.delegate = nil;
        originalpopoverController = nil;
        if(originalTableController != nil){
            originalPlaceTextField.text = originalTableController.selectedOne;
        }
        originalTableController = nil;
    }
    else if (controller == destinationpopoverController)
    {
        destinationpopoverController.delegate = nil;
        destinationpopoverController = nil;
        if(destinationTableController != nil){
            destinationPlaceTextField.text = destinationTableController.selectedOne;
        }
        destinationTableController = nil;
    }
    else if (controller == itemtypepopoverController)
    {
        itemtypepopoverController.delegate = nil;
        itemtypepopoverController = nil;
        if(itemtypeTableController != nil){
            itemTypeTextField.text = itemtypeTableController.selectedOne;
        }
        itemtypeTableController = nil;
    }
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag == 0){
        [self performSegueWithIdentifier:@"originalAddress" sender:self];
    }
    else if(textField.tag == 1){
        [self performSegueWithIdentifier:@"destinationAddress" sender:self];
    }
    else if(textField.tag == 2){
        [self performSegueWithIdentifier:@"itemIdentifier" sender:self];
    }
    return NO;
}

@end
