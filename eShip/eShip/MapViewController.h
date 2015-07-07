//
//  MapViewController.h
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapView.h>
#import "TheSidebarController.h"

@interface MapViewController : UIViewController<TheSidebarControllerDelegate>

@property (strong, nonatomic) MAMapView *myMapView;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

@end

