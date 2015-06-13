//
//  BLShipObject.h
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLRateObject.h"

@interface BLFedexShipObject : NSObject

@property (nonatomic, strong) NSDictionary *senderAddress;

@property (nonatomic, strong) NSDictionary *receiverAddress;

@property (nonatomic, strong) NSDictionary *senderContact;

@property (nonatomic, strong) NSDictionary *recipientContact;

@property (nonatomic, strong) NSDictionary *dutyPayor;

@property (nonatomic, strong) NSDictionary *dimensions;

@property (nonatomic, strong) NSDictionary *weight;

@property (nonatomic, strong) NSDictionary *value;

@property (nonatomic, strong) NSArray *commodities;

@property (nonatomic, strong) NSArray *customerReferences;

@property (nonatomic, strong) NSArray *packageLineitems;


+ (BLFedexShipObject *)sharedInstance;

- (void)setWithRateObject:(BLRateObject *)rateObject;

- (void)setSender:(NSDictionary *)sender andReceiver:(NSDictionary *)receiver;

- (void)setCommodities:(NSDictionary *)commodities;

@end
