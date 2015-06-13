//
//  BLFedexShipObject.m
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "BLFedexShipObject.h"

@implementation BLFedexShipObject

+ (BLFedexShipObject *)sharedInstance {
    static BLFedexShipObject *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _obj = [[BLFedexShipObject alloc] init];
    });
    return _obj;
}

- (void)setWithRateObject:(BLRateObject *)rateObject{
    _senderAddress = rateObject.originalAddress;
    _receiverAddress = rateObject.destinationAddress;
//    NSArray *streetLines1 = [[NSArray alloc] initWithObjects:@"东川路800号", nil];
//    _senderAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                   @"Shanghai",@"city",
//                                   @"SH",@"stateOrProvinceCode",
//                                   @"200240",@"postalCode",
//                                   [NSNull null],@"urbanizationCode",
//                                   @"CN",@"countryCode",
//                                   [NSNull null],@"countryName",
//                                   [NSNumber numberWithBool:NO],@"residential",
//                                   streetLines1,@"streetLines",
//                                   nil];
//    NSArray *streetLines2 = [[NSArray alloc] initWithObjects:@"269 Mill Rd", nil];
//    _receiverAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                     @"Chelmsford",@"city",
//                                     @"MA",@"stateOrProvinceCode",
//                                     @"01824",@"postalCode",
//                                     [NSNull null],@"urbanizationCode",
//                                     @"US",@"countryCode",
//                                     [NSNull null],@"countryName",
//                                     [NSNumber numberWithBool:NO],@"residential",
//                                     streetLines2,@"streetLines",
//                                     nil];
    NSMutableDictionary *sizeMutable = [rateObject.size mutableCopy];
    [sizeMutable setValue:[sizeMutable valueForKey:@"unit"] forKey:@"units"];
    [sizeMutable removeObjectForKey:@"unit"];
    _dimensions = sizeMutable;
    NSMutableDictionary *weightMutable = [rateObject.weight mutableCopy];
    NSDictionary *weightObject = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [weightMutable valueForKey:@"unit"],@"value",
                                  nil];
    _weight = [[NSDictionary alloc] initWithObjectsAndKeys:
               [weightMutable valueForKey:@"weight"],@"value",
               weightObject,@"units",
               nil];
    _value = rateObject.value;
    NSDictionary *packageLineitem = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithInt:1],@"sequenceNumber",
                                     [NSNumber numberWithInt:1],@"groupPackageCount",
                                     _weight,@"weight",
                                     _dimensions,@"dimensions",
                                     //  customerReferences,@"customerReferences",
                                     nil];
    _packageLineitems = [[NSArray alloc] initWithObjects:packageLineitem, nil];
}

- (void)setSender:(NSDictionary *)sender andReceiver:(NSDictionary *)receiver{
    _senderContact = sender;
    _recipientContact = receiver;
    NSDictionary *responsibleParty = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"510087682",@"accountNumber",
                                      _senderContact,@"contact",
                                      _senderAddress,@"address",
                                      nil];
    _dutyPayor = [[NSDictionary alloc] initWithObjectsAndKeys:
                               responsibleParty,@"responsibleParty",
                               nil];
}

- (void)setCommodities:(NSDictionary *)commodities{
    NSMutableDictionary *commodity = [commodities mutableCopy];
    [commodity setValue:_value forKey:@"unitPrice"];
    [commodity setValue:_value forKey:@"customsValue"];
    [commodity setValue:_weight forKey:@"weight"];
    _commodities = [[NSArray alloc] initWithObjects:commodity, nil];
}

@end
