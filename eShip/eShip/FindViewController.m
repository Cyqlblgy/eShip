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

@interface FindViewController (){
    ZBarReaderViewController *reader;
    WYPopoverController* popoverController;
    WYTableViewViewController *tableController;
}

@end

@implementation FindViewController
@synthesize shipNumberTextField,scanButton,getListButton,carrierTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快递追踪";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    CGRect frame = shipNumberTextField.frame;
    scanButton.frame = CGRectMake(frame.origin.x+frame.size.width+ 11 , frame.origin.y, 40, 40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
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
    tableController.list = [[NSArray alloc] initWithObjects:@"申通",@"圆通",@"FedEX",@"UPS",@"韵达", nil];
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


- (IBAction)done:(id)sender{
    [popoverController dismissPopoverAnimated:YES];
    popoverController.delegate = nil;
    popoverController = nil;
    if(tableController != nil){
        carrierTextField.text = tableController.selectedOne;
    }
    tableController = nil;
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

@end
