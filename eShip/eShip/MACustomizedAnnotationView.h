//
//  MACustomizedAnnotationView.h
//  eShip
//
//  Created by Bin Lang on 5/14/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAAnnotationView.h>
#import "MACustomCalloutView.h"

@interface MACustomizedAnnotationView : MAAnnotationView

@property (nonatomic, strong) MACustomCalloutView *calloutView;

@property (nonatomic, strong) NSString *carrier;

@end
