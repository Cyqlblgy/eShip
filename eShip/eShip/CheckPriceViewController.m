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
#import "BLBase64.h"
#import "TSLocateView.h"

@interface CheckPriceViewController (){
    WYPopoverController* originalpopoverController;
    WYPopoverController* destinationpopoverController;
    WYPopoverController* itemtypepopoverController;
    WYTableViewViewController *originalTableController;
    WYTableViewViewController *destinationTableController;
    WYTableViewViewController *itemtypeTableController;
   // UIButton *button,*button1,*button2;
}

@end

@implementation CheckPriceViewController

@synthesize originalPlaceTextField,destinationPlaceTextField,itemTypeTextField,searchButton,originalButton,destinationButton,itemTypeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"运费查询";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [originalButton setFrame:CGRectMake(0, 0, 60, originalPlaceTextField.frame.size.height)];
    [originalButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [originalButton addTarget:self action:@selector(showCityAndProvincePicker) forControlEvents:UIControlEventTouchUpInside];
    [destinationButton setFrame:CGRectMake(0, 0, 60, destinationPlaceTextField.frame.size.height)];
    [destinationButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [destinationButton addTarget:self action:@selector(getDestinationList) forControlEvents:UIControlEventTouchUpInside];
    [itemTypeButton setFrame:CGRectMake(0, 0, 60, itemTypeTextField.frame.size.height)];
    [itemTypeButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [itemTypeButton addTarget:self action:@selector(getItemTypeList) forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, originalPlaceTextField.frame.size.height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label.text = @"原寄地";
    [view addSubview:label];
    originalPlaceTextField.leftView = view;
    originalPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    originalPlaceTextField.rightView = originalButton;
    originalPlaceTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, originalPlaceTextField.frame.size.height)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label1.text = @"目的地";
    [view1 addSubview:label1];
    destinationPlaceTextField.leftView = view1;
    destinationPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    destinationPlaceTextField.rightView = destinationButton;
    destinationPlaceTextField.rightViewMode = UITextFieldViewModeAlways;

    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, originalPlaceTextField.frame.size.height)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label2.text = @"物品类型";
    [view2 addSubview:label2];
    itemTypeTextField.leftView = view2;
    itemTypeTextField.leftViewMode = UITextFieldViewModeAlways;
    itemTypeTextField.rightView = itemTypeButton;
    itemTypeTextField.rightViewMode= UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController navigationBar].hidden = NO;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SearchPrice:(id)sender {
    NSData *plainData = [@"zhouhao:950288" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];
    NSArray *streetLines1 = [[NSArray alloc] initWithObjects:@"东川路800号", nil];
    NSDictionary *senderAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"Shanghai",@"city",
                                   @"SH",@"stateOrProvinceCode",
                                   @"200240",@"postalCode",
                                   [NSNull null],@"urbanizationCode",
                                   @"CN",@"countryCode",
                                   [NSNull null],@"countryName",
                                   [NSNumber numberWithBool:NO],@"residential",
                                   streetLines1,@"streetLines",
                                   nil];
    NSArray *streetLines2 = [[NSArray alloc] initWithObjects:@"269 Mill Rd", nil];
    NSDictionary *receiverAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"Chelmsford",@"city",
                                   @"MA",@"stateOrProvinceCode",
                                   @"01824",@"postalCode",
                                   [NSNull null],@"urbanizationCode",
                                   @"US",@"countryCode",
                                   [NSNull null],@"countryName",
                                   [NSNumber numberWithBool:NO],@"residential",
                                   streetLines2,@"streetLines",
                                   nil];
    NSDictionary *size = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithInt:10],@"length",
                                     [NSNumber numberWithInt:10],@"width",
                                     [NSNumber numberWithInt:10],@"height",
                                     @"CM",@"unit",
                                     nil];
    NSDictionary *weight = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithFloat:1.1999999999999999555910790149937383830547332763671875],@"weight",
                          @"KG",@"unit",
                          nil];
    NSDictionary *value = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"CNY",@"currency",
                            [NSNumber numberWithFloat:3000],@"amount",
                            nil];
    long long i = (long long)[[NSDate date] timeIntervalSince1970]* 1000.0;
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    senderAddress,@"senderAddress",
                                    receiverAddress,@"recipientAddress",
                                    size,@"size",
                                    weight,@"weight",
                                    value,@"value",
                                    [NSNumber numberWithLongLong:i],@"shipTime",
                                    nil];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:@"user/rate" andParams:jsonDictionary andMaxTimeOut:40 andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSData *x = data;
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    }];
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


- (void)showCityAndProvincePicker{
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
    [locateView showInView:self.view];
}
@end
