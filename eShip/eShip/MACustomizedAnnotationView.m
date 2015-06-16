//
//  MACustomizedAnnotationView.m
//  eShip
//
//  Created by Bin Lang on 5/14/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//
#define kCalloutWidth 290.0 
#define kCalloutHeight 70.0

#import "MACustomizedAnnotationView.h"
#import "MACustomizedAnnotation.h"
//@interface MACustomizedAnnotationView ()
//
//@property (nonatomic, strong, readwrite) MACustomCalloutView *calloutView;
//
//@end

@implementation MACustomizedAnnotationView{
    UITapGestureRecognizer *singleFingerTap;
}
#define kWidth          40.f
#define kHeight         40.f
#define kTimeInterval   0.15f

#pragma mark - Life Cycle
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        if (self.calloutView == nil)
        {
            self.calloutView = [[MACustomCalloutView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                   kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f +
                                                  self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y); }
        self.calloutView.image = [UIImage imageNamed:_carrier];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        [self addSubview:self.calloutView];
        //singleFingerTap= [[UITapGestureRecognizer alloc] initWithTarget:self
        //                                                         action:@selector(handleSingleTap:)];
        //[self.calloutView addGestureRecognizer:singleFingerTap];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pickNext" object:nil];
       // [self.calloutView removeGestureRecognizer:singleFingerTap];
        [self.calloutView removeFromSuperview];
        
    }
    [super setSelected:selected animated:animated];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.calloutView removeGestureRecognizer:singleFingerTap];
    [self.calloutView removeFromSuperview];
}


@end
