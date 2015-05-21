//
//  BLNetwork.h
//  eShip
//
//  Created by Bin Lang on 5/19/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkHanlder)(NSURLResponse* response, NSData* data, NSError* connectionError);

@interface BLNetwork : NSObject

+(void)urlConnectionRequest:(NSString *)httpMethodType andrequestType:(NSString *)requestType andParams:(NSDictionary *)params andMaxTimeOut:(NSTimeInterval)timeInterval andResponse:(NetworkHanlder)handler;
@end
