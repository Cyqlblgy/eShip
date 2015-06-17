//
//  MACustomizedAnnotationView.m
//  eShip
//
//  Created by Bin Lang on 5/14/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//
#define kCalloutWidth 290.0 
#define kCalloutHeight 70.0
#define kCalloutExtra  30.0

#import "MACustomizedAnnotationView.h"
#import "MACustomizedAnnotation.h"
#import "BLParams.h"
//@interface MACustomizedAnnotationView ()
//
//@property (nonatomic, strong, readwrite) MACustomCalloutView *calloutView;
//
//@end

@implementation MACustomizedAnnotationView

#pragma mark - Life Cycle
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        if (self.calloutView == nil)
        {
            if([_category isEqualToString:BLParameters.MapCar]){
            self.calloutView = [[MACustomCalloutView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                   kCalloutWidth, kCalloutHeight) hasExtraLabel:NO];
            }
            else{
            self.calloutView = [[MACustomCalloutView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                         kCalloutWidth, kCalloutHeight+kCalloutExtra) hasExtraLabel:YES];
            self.calloutView.extratitle = self.extraTitle;
            }
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f +
                                                  self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y); }
        self.calloutView.image = [UIImage imageNamed:_carrier];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        [self addSubview:self.calloutView];
        
    }
    else {
        [self.calloutView removeFromSuperview];
        
    }
    [super setSelected:selected animated:animated];
}




@end
