//
//  BLNetwork.m
//  eShip
//
//  Created by Bin Lang on 5/19/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "BLNetwork.h"
#import "BLParams.h"

@implementation BLNetwork

+(void)urlConnectionRequest:(NSString *)requestType andParams:(NSDictionary *)params andMaxTimeOut:(NSTimeInterval)timeInterval andResponse:(NetworkHanlder)handler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://104.131.174.73:8080/useraccount"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [request setHTTPMethod:requestType];
   //     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Accept"];
   //     [request setHTTPBody:postData];
        [request setTimeoutInterval:timeInterval]; //This value is in seconds...
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(response,data,error);
            });
        }];
        
    });
}
@end
