//
//  MACustomCalloutView.m
//  eShip
//
//  Created by Bin Lang on 6/13/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//
#define kArrorHeight 10
#define kPortraitMargin 5 
#define kPortraitWidth 70 
#define kPortraitHeight 50
#define kTitleWidth 200
#define kTitleHeight 20

#import "MACustomCalloutView.h"
#import "TTTAttributedLabel.h"
@interface MACustomCalloutView ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) TTTAttributedLabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MACustomCalloutView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews]; }
    return self;
}

- (void)initSubViews {
    // 添加图片,即商户图
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin, kPortraitWidth, kPortraitHeight)];
    self.portraitView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.portraitView];
    // 添加标题,即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"titletitletitletitle";
    [self addSubview:self.titleLabel];
    // 添加副标题,即商户地址
    self.subtitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin * 2 + kTitleHeight, kTitleWidth, kTitleHeight)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    self.subtitleLabel.delegate = self;
    self.subtitleLabel.tag = 10;
    self.subtitleLabel.userInteractionEnabled = YES;
    self.subtitleLabel.text = @"subtitleLabelsubtitleLabelsubtitleLabel";
    [self addSubview:self.subtitleLabel];
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
- (void)setSubtitle:(NSString *)subtitle {
    self.subtitleLabel.text = subtitle;
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:subtitle];
    NSRange range = [subtitle rangeOfString:@"联系方式:"];
    if(range.location != NSNotFound)
    {
        NSRange ran = NSMakeRange(range.location + range.length, attributedStr.length - range.location -range.length);
        NSString *sss = [subtitle substringFromIndex:range.location + range.length];
        [self.subtitleLabel addLinkToPhoneNumber:sss withRange:ran];
        self.subtitleLabel.tag = 20;
    }
    
}
- (void)setImage:(UIImage *)image {
    self.portraitView.image = image;
}


- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor]; self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context {
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]];
}


@end
