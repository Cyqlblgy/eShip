//
//  BLParams.h
//  eShip
//
//  Created by Bin Lang on 5/19/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BLNetworkTrackSuccess = 200,
    BLNetworkTrackCarrierNotFound = 400,
    BLNetworkTrackNumberNotFound = 404
} BLNetworkTrackResponseCode;

typedef enum {
    BLNetworkLoginSuccess = 200,
} BLNetworkLoginResponseCode;

typedef enum {
    BLNetworkRateSuccess = 200,
} BLNetworkRateResponseCode;

typedef enum {
    BLNetworkRegisterSuccess = 201,
    BLNetworkRegisterDuplicateUserNamrorEmail = 409
} BLNetworkRegisterResponseCode;

typedef enum {
    BLNetworkShipSuccess = 200,
} BLNetworkShipResponseCode;

typedef enum {
    BLNetworkGetLabelSuccess = 200,
} BLNetworkGetLabelResponseCode;

typedef enum {
    BLNetworkGetCustomFileSuccess = 200,
} BLNetworkGetCustomFileResponseCode;

struct BLParamsStruct
{
    __unsafe_unretained NSString * const NetworkHttpMethodPost;
    __unsafe_unretained NSString * const NetworkHttpMethodGet;
    __unsafe_unretained NSString * const NetworkLogin;
    __unsafe_unretained NSString * const NetworkTrack;
    __unsafe_unretained NSString * const NetworkRegister;
    __unsafe_unretained NSString * const NetworkRate;
    __unsafe_unretained NSString * const NetworkShip;
    __unsafe_unretained NSString * const NetworkGetLabel;
    __unsafe_unretained NSString * const NetworkGetCustomFile;
    __unsafe_unretained NSString * const ShipFedex;
    __unsafe_unretained NSString * const ShipUPS;
    __unsafe_unretained NSString * const MapCar;
    __unsafe_unretained NSString * const MapHouse;
};

extern const struct BLParamsStruct BLParameters;
