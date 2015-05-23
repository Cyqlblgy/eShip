//
//  TrackingDetailViewModel.h
//  eShip
//
//  Created by Bin Lang on 5/23/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingDetailViewModel : UIView

@property (strong, nonatomic) NSMutableString *date;
@property (weak, nonatomic) NSString *city;
@property (weak, nonatomic) NSString *state;
@property (weak, nonatomic) NSString *country;
@property (weak, nonatomic) NSString *des;


- (id)initWithFrame:(CGRect)frame andParams:(NSDictionary *)params;
@end
