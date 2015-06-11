//
//  TrackingDetailViewModel.m
//  eShip
//
//  Created by Bin Lang on 5/23/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "TrackingDetailViewModel.h"

@implementation TrackingDetailViewModel

- (id)initWithFrame:(CGRect)frame andParams:(NSDictionary *)params{
   self = [super initWithFrame:frame];
    [self setParams:params];
    [self addLabels];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 3.5f;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor lightGrayColor];
   return  self;
}

- (void)setParams:(NSDictionary *)params{
    NSDictionary *place = [params valueForKey:@"place"];
    if(![[place valueForKey:@"city"] isEqual:[NSNull null]]){
        _city = [place valueForKey:@"city"];
    }
    
    if(![[place valueForKey:@"state"] isEqual:[NSNull null]]){
        _state = [place valueForKey:@"state"];
    }
    _country = [place valueForKey:@"country"];
    _des = [params valueForKey:@"description"];
    _date = [params valueForKey:@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *sDate = [dateFormatter dateFromString:_date];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _date = [[dateFormatter stringFromDate:sDate] mutableCopy];
}

- (void)addLabels{
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-20, 25)];
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.frame.size.width-20, 25)];
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, self.frame.size.width-20, 25)];
    UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, self.frame.size.width-20, 25)];
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, self.frame.size.width-20, 25)];
    dateLabel.text = [[NSString alloc] initWithFormat:@"时间： %@", _date];
    if(_city != nil){
        cityLabel.text = [[NSString alloc] initWithFormat:@"城市： %@", _city];
    }
    else{
        cityLabel.text = @"城市： Unknow city";
    }
    if(_state != nil){
        stateLabel.text = [[NSString alloc] initWithFormat:@"省份： %@", _state];
    }
    else{
        stateLabel.text = @"省份： Unknow state";
    }
    if(_country !=nil){
        countryLabel.text = [[NSString alloc] initWithFormat:@"国家： %@", _country];
    }
    else{
        countryLabel.text = @"国家： Unknow country";
    }
    desLabel.text = [[NSString alloc] initWithFormat:@"描述： %@", _des];
    [self addSubview:dateLabel];
    [self addSubview:cityLabel];
    [self addSubview:stateLabel];
    [self addSubview:countryLabel];
    [self addSubview:desLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
