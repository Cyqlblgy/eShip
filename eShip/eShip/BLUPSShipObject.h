//
//  BLUPSShipObject.h
//  eShip
//
//  Created by Bin Lang on 6/13/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLRateObject.h"

@interface BLUPSShipObject : NSObject

@property (nonatomic, strong) NSMutableDictionary *shipFrom;

@property (nonatomic, strong) NSMutableDictionary *shipTo;

@property (nonatomic, strong) NSMutableDictionary *packages;

@property (nonatomic, strong) NSArray *packageContent;


+ (BLUPSShipObject *)sharedInstance;

- (void)setWithRateObject:(BLRateObject *)rateObject;

- (void)setSender:(NSDictionary *)sender andReceiver:(NSDictionary *)receiver;

- (void)setCommodities:(NSDictionary *)commodities;
@end
