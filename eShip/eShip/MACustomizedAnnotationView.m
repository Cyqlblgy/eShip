//
//  MACustomizedAnnotationView.m
//  eShip
//
//  Created by Bin Lang on 5/14/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "MACustomizedAnnotationView.h"
#import "MACustomizedAnnotation.h"

@implementation MACustomizedAnnotationView

#define kWidth          40.f
#define kHeight         40.f
#define kTimeInterval   0.15f

@synthesize imageView = _imageView;

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setBounds:CGRectMake(0.f, 0.f, kWidth, kHeight)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark - Utility

- (void)updateImageView
{
    MACustomizedAnnotation *animatedAnnotation = (MACustomizedAnnotation *)self.annotation;
    self.imageView.image = [UIImage imageNamed:@"animatedCar_1.png"];
    
//    if ([self.imageView isAnimating])
//    {
//        [self.imageView stopAnimating];
//    }
//    
//    self.imageView.animationImages      = animatedAnnotation.animatedImages;
//    self.imageView.animationDuration    = kTimeInterval * [animatedAnnotation.animatedImages count];
//    self.imageView.animationRepeatCount = 0;
//    [self.imageView startAnimating];
}

#pragma mark - Override

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    [self updateImageView];
}

@end
