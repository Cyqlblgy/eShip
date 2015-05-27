//
//  LogViewController.m
//  eShip
//
//  Created by Bin Lang on 5/26/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
