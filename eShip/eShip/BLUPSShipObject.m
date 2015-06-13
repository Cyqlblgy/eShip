//
//  BLUPSShipObject.m
//  eShip
//
//  Created by Bin Lang on 6/13/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "BLUPSShipObject.h"

@implementation BLUPSShipObject

+ (BLUPSShipObject *)sharedInstance {
    static BLUPSShipObject *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _obj = [[BLUPSShipObject alloc] init];
    });
    return _obj;
}

- (void)setWithRateObject:(BLRateObject *)rateObject{
    _shipFrom = [[NSMutableDictionary alloc] init];
    _shipTo = [[NSMutableDictionary alloc] init];
    _packages = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *oAddress = [rateObject.originalAddress mutableCopy];
    NSMutableDictionary *dAddress = [rateObject.destinationAddress mutableCopy];
    [oAddress removeObjectForKey:@"countryName"];
    [oAddress removeObjectForKey:@"residential"];
    [oAddress removeObjectForKey:@"urbanizationCode"];
    [dAddress removeObjectForKey:@"countryName"];
    [dAddress removeObjectForKey:@"residential"];
    [dAddress removeObjectForKey:@"urbanizationCode"];
    [_shipFrom setValue:oAddress forKey:@"address"];
    [_shipTo setValue:dAddress forKey:@"address"];
    
    NSMutableDictionary *unitMutable = [[NSMutableDictionary alloc] init];
    NSString *unit = [rateObject.size valueForKey:@"unit"];
    if([unit isEqualToString:@"CM"] ){
        [unitMutable setValue:@"CM" forKey:@"code"];
        [unitMutable setValue:@"Centimeters" forKey:@"description"];
    }
    else{
        [unitMutable setValue:@"IN" forKey:@"code"];
        [unitMutable setValue:@"Inches" forKey:@"description"];
    }
    
    NSDictionary *dimensions = [[NSDictionary alloc] initWithObjectsAndKeys:
                                unitMutable,@"unitOfMeasurement",
                                [rateObject.size valueForKey:@"length"],@"length",
                                [rateObject.size valueForKey:@"width"],@"width",
                                [rateObject.size valueForKey:@"height"],@"height",
                                nil];
    
    [_packages setValue:dimensions forKey:@"dimensions"];
    [_packages setValue:[NSNull null] forKey:@"description"];
    [_packages setValue:[NSNull null] forKey:@"referenceNumber"];
    [_packages setValue:[NSNull null] forKey:@"additionalHandlingIndicator"];
    [_packages setValue:[NSNull null] forKey:@"packageServiceOptions"];
    [_packages setValue:[NSNull null] forKey:@"commodity"];
    
    NSMutableDictionary *weightMutable = [[NSMutableDictionary alloc] init];
    NSString *measure = [rateObject.weight valueForKey:@"unit"];
    if([measure isEqualToString:@"KG"] ){
        [weightMutable setValue:@"KG" forKey:@"code"];
        [weightMutable setValue:@"Kilograms" forKey:@"description"];
    }
    else{
        [weightMutable setValue:@"LBS" forKey:@"code"];
        [weightMutable setValue:@"Pounds" forKey:@"description"];
    }
    NSDictionary *packageWeight = [[NSDictionary alloc] initWithObjectsAndKeys:
                                weightMutable,@"unitOfMeasurement",
                                [rateObject.weight valueForKey:@"weight"],@"weight",
                                nil];
    [_packages setValue:packageWeight forKey:@"packageWeight"];
}

- (void)setSender:(NSDictionary *)sender andReceiver:(NSDictionary *)receiver{
    NSDictionary *senderPhoneNumber = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [sender valueForKey:@"phoneNumber"],@"number",nil];
    [_shipFrom setValue:[sender valueForKey:@"personName"] forKey:@"name"];
    [_shipFrom setValue:[sender valueForKey:@"personName"] forKey:@"attentionName"];
    [_shipFrom setValue:senderPhoneNumber forKey:@"phone"];
    [_shipFrom setValue:[sender valueForKey:@"emailAddress"] forKey:@"emailAddress"];
    
    
    NSDictionary *receiverPhoneNumber = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [receiver valueForKey:@"phoneNumber"],@"number",nil];
    [_shipTo setValue:[receiver valueForKey:@"personName"] forKey:@"name"];
    [_shipTo setValue:[receiver valueForKey:@"personName"] forKey:@"attentionName"];
    [_shipTo setValue:receiverPhoneNumber forKey:@"phone"];
    [_shipTo setValue:[receiver valueForKey:@"emailAddress"] forKey:@"emailAddress"];
}

- (void)setCommodities:(NSDictionary *)commodities{
    NSDictionary *packaging = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         [commodities valueForKey:@"description"],@"description",
                                         @"02",@"code",nil];
    [_packages setValue:packaging forKey:@"packaging"];
    _packageContent = [[NSArray alloc] initWithObjects:_packages, nil];
}

@end
