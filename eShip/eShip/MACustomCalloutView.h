//
//  MACustomCalloutView.h
//  eShip
//
//  Created by Bin Lang on 6/13/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MACustomCalloutView : UIView

@property (nonatomic, strong) UIImage *image; //商户图
@property (nonatomic, copy) NSString *title; //商户名
@property (nonatomic, copy) NSString *subtitle; //地址
@property (nonatomic, copy) NSString *extratitle; //地址

- (id)initWithFrame:(CGRect)frame hasExtraLabel:(BOOL)extra;

@end
