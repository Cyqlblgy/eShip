//
//  BLRateObject.m
//  eShip
//
//  Created by Bin Lang on 5/27/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "BLRateObject.h"

@implementation BLRateObject

+ (BLRateObject *)sharedInstance {
    static BLRateObject *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _obj = [[BLRateObject alloc] init];
    });
    return _obj;
}

@end
