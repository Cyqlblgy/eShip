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

+(void)urlConnectionRequest:(NSString *)httpMethodType andrequestType:(NSString *)requestType andParams:(NSDictionary *)params andMaxTimeOut:(NSTimeInterval)timeInterval andAcceptType:(NSString *)acceptType andAuthorization:(NSString *)authorization andResponse:(NetworkHanlder)handler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString =[[NSString alloc] initWithFormat:@"http://104.131.174.73:8080/useraccount/%@",requestType];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        if(params){
        NSError *error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        [request setHTTPBody:jsonData];
        }
        [request setHTTPMethod:httpMethodType];
        if(authorization){
        [request setValue:authorization forHTTPHeaderField:@"Authorization"];
        }
        
        if(acceptType){
      //  [request setValue:acceptType forHTTPHeaderField:@"Accept"];
        [request setValue:acceptType forHTTPHeaderField:@"Content-type"];
        }
        else{
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        }
        if(timeInterval){
        [request setTimeoutInterval:timeInterval]; //This value is in seconds...
        }
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
