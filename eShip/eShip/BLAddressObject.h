//
//  BLAddressObject.h
//  eShip
//
//  Created by Bin Lang on 5/31/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLAddressObject : NSObject

@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *provinceCode;
@property (strong, nonatomic) NSString *countryCode;

+ (BLAddressObject *)sharedInstance;

@end
