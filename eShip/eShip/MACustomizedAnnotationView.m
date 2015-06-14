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

@implementation MACustomizedAnnotationView

#define kWidth          40.f
#define kHeight         40.f
#define kTimeInterval   0.15f

#pragma mark - Life Cycle
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return; }
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
    }
    else {
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

//- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
//    
//    if (self)
//    {
//        [self setBounds:CGRectMake(0.f, 0.f, kWidth, kHeight)];
//        [self setBackgroundColor:[UIColor clearColor]];
//        
//        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        [self addSubview:self.imageView];
//    }
//    
//    return self;
//}
//
//#pragma mark - Utility
//
//- (void)updateImageView
//{
//    MACustomizedAnnotation *animatedAnnotation = (MACustomizedAnnotation *)self.annotation;
//    self.imageView.image = [UIImage imageNamed:@"animatedCar_1.png"];
//    
////    if ([self.imageView isAnimating])
////    {
////        [self.imageView stopAnimating];
////    }
////    
////    self.imageView.animationImages      = animatedAnnotation.animatedImages;
////    self.imageView.animationDuration    = kTimeInterval * [animatedAnnotation.animatedImages count];
////    self.imageView.animationRepeatCount = 0;
////    [self.imageView startAnimating];
//}
//
//#pragma mark - Override
//
//- (void)setAnnotation:(id<MAAnnotation>)annotation
//{
//    [super setAnnotation:annotation];
//    
//    [self updateImageView];
//}

@end
