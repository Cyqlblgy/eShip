//
//  MACustomizedAnnotation.h
//  eShip
//
//  Created by Bin Lang on 5/14/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAAnnotation.h>

@interface MACustomizedAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) NSMutableArray *animatedImages;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
