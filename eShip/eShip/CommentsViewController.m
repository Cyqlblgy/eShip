//
//  CommentsViewController.m
//  eShip
//
//  Created by Bin Lang on 6/4/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "CommentsViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)getLabel:(id)sender {
    NSData *plainData = [@"zhouhao:950288" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",BLParameters.NetworkGetLabel,@"794638378719"];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodGet andrequestType:str andParams:nil andMaxTimeOut:40 andAcceptType:@"application/pdf" andAuthorization:nil andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSData *x = data;
     }];
}
@end
