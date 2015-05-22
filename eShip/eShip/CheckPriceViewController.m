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

@interface CheckPriceViewController (){
    WYPopoverController* originalpopoverController;
    WYPopoverController* destinationpopoverController;
    WYPopoverController* itemtypepopoverController;
    WYTableViewViewController *originalTableController;
    WYTableViewViewController *destinationTableController;
    WYTableViewViewController *itemtypeTableController;
    UIButton *button,*button1,*button2;
}

@end

@implementation CheckPriceViewController

@synthesize originalPlaceTextField,destinationPlaceTextField,itemTypeTextField,searchButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"运费查询";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, originalPlaceTextField.frame.size.height)];
    [button setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getOriginalList) forControlEvents:UIControlEventTouchUpInside];
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 0, 60, destinationPlaceTextField.frame.size.height)];
    [button1 setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(getDestinationList) forControlEvents:UIControlEventTouchUpInside];
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(0, 0, 60, itemTypeTextField.frame.size.height)];
    [button2 setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(getItemTypeList) forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, originalPlaceTextField.frame.size.height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label.text = @"原寄地";
    [view addSubview:label];
    originalPlaceTextField.leftView = view;
    originalPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    originalPlaceTextField.rightView = button;
    originalPlaceTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, originalPlaceTextField.frame.size.height)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label1.text = @"目的地";
    [view1 addSubview:label1];
    destinationPlaceTextField.leftView = view1;
    destinationPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    destinationPlaceTextField.rightView = button1;
    destinationPlaceTextField.rightViewMode = UITextFieldViewModeAlways;

    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, originalPlaceTextField.frame.size.height)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, originalPlaceTextField.frame.size.height)];
    label2.text = @"物品类型";
    [view2 addSubview:label2];
    itemTypeTextField.leftView = view2;
    itemTypeTextField.leftViewMode = UITextFieldViewModeAlways;
    itemTypeTextField.rightView = button2;
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
    
//    //Login sample
//    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    @"coolboy", @"user_name",
//                                    @"ghdj562", @"password",
//                                    nil];
//    
//    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkLogin andParams:jsonDictionary andMaxTimeOut:20 andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if(connectionError == nil){
//            NSError *error =nil;
//            NSDictionary *da = [NSJSONSerialization JSONObjectWithData:data
//                                                               options:NSJSONReadingMutableContainers
//                                                                 error:&error];
//            if(error == nil){
//            BLCoreData *blcd = [BLCoreData sharedInstance];
//                NSManagedObjectContext *context = blcd.managedObjectContext;
//                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//                
//                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:context];
//                [fetchRequest setEntity:entity];
//                NSError *er= nil;
//                NSArray *result = [context executeFetchRequest:fetchRequest error:&er];
//                if (error) {
//                    NSLog(@"Unable to execute fetch request.");
//                    NSLog(@"%@, %@", error, error.localizedDescription);
//                    
//                } else {
//                    NSLog(@"%@", result);
//                    NSManagedObject *cu = (NSManagedObject *)result[0];
//                    for(NSManagedObject *h in result){
//                        [context deleteObject:h];
//                    }
//                    NSManagedObject *currentUser = [NSEntityDescription
//                                                    insertNewObjectForEntityForName:@"Account"
//                                                    inManagedObjectContext:context];
//                    NSString *basedUserName = [BLBase64 base64StringFromText:[da objectForKey:@"user_name"]];
//                    NSString *basedPassword = [BLBase64 base64StringFromText:@"ghdj562"];
//                    [currentUser setValue:basedUserName forKey:@"userName"];
//                    [currentUser setValue:basedPassword forKey:@"passWord"];
//                    if([da objectForKey:@"email"]){
//                        [currentUser setValue:[da objectForKey:@"email"] forKey:@"email"];
//                    }
//                    if(![[da objectForKey:@"phone"] isKindOfClass:[NSNull class]]){
//                        [currentUser setValue:[da objectForKey:@"phone"] forKey:@"phone"];
//                    }
//                    NSString *user_id = [[NSNumber numberWithLong:[[da objectForKey:@"user_id"] longValue]] stringValue];
//                    [currentUser setValue:user_id forKey:@"userID"];
//                    NSString *register_dae = [[NSNumber numberWithLong:[[da objectForKey:@"register_date"] longValue]] stringValue];
//                    [currentUser setValue:register_dae forKey:@"registerDate"];
//                    NSError *e = nil;
//                    if (![context save:&e]) {
//                        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//                    }
//
//                }
//            }
//        }
//        
//    }];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"blang01", @"user_name",@"langbin0001@gmail.com",@"email",@"123456789", @"password",[NSNull null], @"phone",nil];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkRegister andParams:jsonDictionary andMaxTimeOut:20 andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if(res.statusCode == 201){
            NSLog(@"Succeed");
        }
        else if(res.statusCode == 409){
            NSLog(@"Duplicate username or email");
        }
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
        CGRect rect = button.bounds;
        [originalpopoverController presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.5, rect.size.height) inView:button permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
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
        CGRect rect = button1.bounds;
        [destinationpopoverController presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.5, rect.size.height) inView:button1 permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
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
        CGRect rect = button2.bounds;
        [itemtypepopoverController presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*1.5, rect.size.height) inView:button2 permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
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
@end
