//
//  MapViewController.m
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MKUserLocation.h>
#import <MapKit/MKPointAnnotation.h>

@interface MapViewController () <MKMapViewDelegate, MKAnnotation, CLLocationManagerDelegate>{
    NSMutableArray *locations;
    NSMutableArray *users;
    NSMutableArray *currentusers;
}

@end

@implementation MapViewController

@synthesize myMapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"eShip";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    myMapView.delegate = self;
    
    users = [NSMutableArray arrayWithCapacity:10];
    locations = [NSMutableArray arrayWithCapacity:10];
    currentusers = [NSMutableArray arrayWithCapacity:10];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.delegate = self;
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
    _startLocation = nil;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController navigationBar].hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [myMapView setRegion:[myMapView regionThatFits:region] animated:YES];
    
    for(int i =0 ; i< 10 ; i++){
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationDegrees longitude = userLocation.coordinate.longitude - 0.01*i + random()%360 * 0.0001;
        CLLocationDegrees latitude  = userLocation.coordinate.latitude + 0.01*i + random()%360 * 0.0001;
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        point.coordinate = location.coordinate;
        [self.myMapView addAnnotation:point];
    }
    
}

#pragma CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    _startLocation = nil;
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        _startLocation = nil;
        _locationManager.delegate = nil;
        [_locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    _startLocation= nil;
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    _startLocation = newLocation;
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _startLocation = manager.location;
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        
        myMapView.showsUserLocation = YES;
        
    }
}

#pragma MKAnnotation

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        pinView.image = [UIImage imageNamed:@"Ball.png"];    //as suggested by Squatch
    }
    else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

@end
