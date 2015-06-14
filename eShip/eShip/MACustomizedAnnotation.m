//
//  MACustomizedAnnotation.m
//  eShip
//
//  Created by Bin Lang on 5/14/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "MACustomizedAnnotation.h"

@implementation MACustomizedAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize carrier = _carrier;

#pragma mark - life cycle

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}

@end
