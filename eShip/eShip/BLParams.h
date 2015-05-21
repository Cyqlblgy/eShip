//
//  BLParams.h
//  eShip
//
//  Created by Bin Lang on 5/19/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BLNetworkTrackSuccess = 400,
    BLNetworkTrackNotFound = 404
} BLNetworkTrackResponseCode;

typedef enum {
    BLNetworkLoginSuccess = 200,
} BLNetworkLoginResponseCode;

struct BLParamsStruct
{
    __unsafe_unretained NSString * const NetworkHttpMethodPost;
    __unsafe_unretained NSString * const NetworkHttpMethodGet;
    __unsafe_unretained NSString * const NetworkLogin;
    __unsafe_unretained NSString * const NetworkTrack;
};

extern const struct BLParamsStruct BLParameters;
