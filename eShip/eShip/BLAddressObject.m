//
//  BLAddressObject.m
//  eShip
//
//  Created by Bin Lang on 5/31/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "BLAddressObject.h"

@implementation BLAddressObject

+ (BLAddressObject *)sharedInstance {
    static BLAddressObject *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _obj = [[BLAddressObject alloc] init];
    });
    return _obj;
}

@end
