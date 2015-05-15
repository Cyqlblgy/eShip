//
//  MapViewController.h
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapView.h>

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MAMapView *myMapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

@end

