//
//  BLRateObject.h
//  eShip
//
//  Created by Bin Lang on 5/27/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLRateObject : NSObject

@property (nonatomic, strong) NSDictionary *originalAddress;

@property (nonatomic, strong) NSDictionary *destinationAddress;

@property (nonatomic, strong) NSDictionary *size;

@property (nonatomic, strong) NSDictionary *weight;

@property (nonatomic, strong) NSDictionary *value;

@property (nonatomic, strong) NSString *originalState;

@property (nonatomic, strong) NSString *destinationState;


+ (BLRateObject *)sharedInstance;

@end
