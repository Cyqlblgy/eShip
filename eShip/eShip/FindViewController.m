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
@synthesize navigationBar,navigationItem,shipNumberTextField,scanButton,getListButton,carrierTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = navigationBar.frame;
    navigationBar.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+10);
    navigationBar.translucent = YES;
    UILabel *label = [[UILabel alloc] initWithFrame: frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:25.0];
    label.textAlignment=UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"快递追踪";
    navigationItem.titleView = label;
    frame = shipNumberTextField.frame;
    scanButton.frame = CGRectMake(frame.origin.x+frame.size.width+ 11 , frame.origin.y, 40, 40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    tableController.preferredContentSize = CGSizeMake(280, 350);
    tableController.title = @"快递公司";
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
        carrierTextField.text = tableController.selectedCarrier;
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
            carrierTextField.text = tableController.selectedCarrier;
        }
        tableController = nil;
    }
}

@end
