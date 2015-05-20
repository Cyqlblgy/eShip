//
//  BLParams.h
//  eShip
//
//  Created by Bin Lang on 5/19/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>

struct BLParamsStruct
{
    __unsafe_unretained NSString * const NetworkHttpMethodPost;
    __unsafe_unretained NSString * const NetworkHttpMethodGet;
    __unsafe_unretained NSString * const NetworkHttpMethodPostLogin;
};

extern const struct BLParamsStruct BLParameters;
