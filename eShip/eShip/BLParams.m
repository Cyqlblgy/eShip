//
//  BLParams.m
//  eShip
//
//  Created by Bin Lang on 5/19/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "BLParams.h"

const struct BLParamsStruct BLParameters =
{
    .NetworkHttpMethodPost = @"POST",
    .NetworkHttpMethodGet = @"GET",
    .NetworkLogin = @"login",
    .NetworkTrack = @"track",
    .NetworkRegister = @"register",
    .NetworkRate = @"user/rate",
    .NetworkShip = @"user/ship/",
    .NetworkGetLabel = @"user/label/",
    .NetworkGetCustomFile = @"user/invoice/",
    .ShipFedex = @"fedex",
    .ShipUPS = @"ups",
    .MapCar = @"map_car",
    .MapHouse = @"map_house",
};

