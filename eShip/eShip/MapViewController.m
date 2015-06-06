//
//  MapViewController.m
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "MapViewController.h"
#import "MACustomizedAnnotation.h"
#import "MACustomizedAnnotationView.h"
#import <MAMapKit/MAMapView.h>
#import <MAMapKit/MAPointAnnotation.h>
#import <MAMapKit/MAUserLocation.h>
#import <MAMapKit/MAAnnotationView.h>
#import <MAMapKit/MAAnnotation.h>
#import <MAMapKit/MAMapKit.h>
#import "TheSidebarController.h"

@interface MapViewController () <MAMapViewDelegate,CLLocationManagerDelegate>{
    NSMutableArray *locations;
    NSMutableArray *users;
    NSMutableArray *currentusers;
    double lat1,lat2,long1,long2;
    MACustomizedAnnotation *annotation1;
    MACustomizedAnnotation *annotation2;
    NSMutableArray *carImages;
}

@end

@implementation MapViewController

@synthesize myMapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    myMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 60, screenFrame.size.width, screenFrame.size.height-70)];
    myMapView.delegate = self;
    long1 = 116.492479;
    long2 = 116.715633;
    lat1 = 39.948691;
    lat2 = 39.943349;
    [self.view addSubview:myMapView];
    carImages = [[NSMutableArray alloc] init];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_1.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_2.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_3.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_4.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_3.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_4.png"]];
//    users = [NSMutableArray arrayWithCapacity:10];
//    locations = [NSMutableArray arrayWithCapacity:10];
//    currentusers = [NSMutableArray arrayWithCapacity:10];
    [self addCarAnnotationWithCoordinate1:CLLocationCoordinate2DMake(lat1, long1)];
    [self addCarAnnotationWithCoordinate2:CLLocationCoordinate2DMake(lat2, long2)];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.delegate = self;
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [_locationManager requestWhenInUseAuthorization];
    }
   [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(startUpdatingLocation)
                                   userInfo:nil
                                    repeats:YES];
//    [self startUpdatingLocation];
//    [_locationManager startUpdatingLocation];
    _startLocation = nil;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController navigationBar].hidden = NO;
    self.navigationItem.title = @"eShip";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(showLeftSide)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showLeftSide{
    if(self.sidebarController.sidebarIsPresenting)
    {
        [self.sidebarController dismissSidebarViewController];
    }
    else
    {
        [self.sidebarController presentLeftSidebarViewControllerWithStyle:SidebarTransitionStyleWunderlist];
    }
}

- (void)startUpdatingLocation{
    lat1  = lat1 + 0.001;
    lat2  = lat2 - 0.001;
    long1 = long1 - 0.001;
    long2 = long2 + 0.001;
    [annotation1 setCoordinate:CLLocationCoordinate2DMake(lat1, long1)];
    [annotation2 setCoordinate:CLLocationCoordinate2DMake(lat2, long2)];
}

-(void)addCarAnnotationWithCoordinate1:(CLLocationCoordinate2D)coordinate{
    annotation1 = [[MACustomizedAnnotation alloc] initWithCoordinate:coordinate];
    annotation1.animatedImages   = carImages;
    annotation1.title            = @"AutoNavi";
   // annotation1.subtitle         = [NSString stringWithFormat:@"Car: %lu images",(unsigned long)[self.animatedCarAnnotation.animatedImages count]];
    [myMapView addAnnotation:annotation1];
}

-(void)addCarAnnotationWithCoordinate2:(CLLocationCoordinate2D)coordinate{
    annotation2 = [[MACustomizedAnnotation alloc] initWithCoordinate:coordinate];
    annotation2.animatedImages   = carImages;
    annotation2.title            = @"AutoNavi";
    // annotation1.subtitle         = [NSString stringWithFormat:@"Car: %lu images",(unsigned long)[self.animatedCarAnnotation.animatedImages count]];
    [myMapView addAnnotation:annotation2];
}


#pragma MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [myMapView setRegion:[myMapView regionThatFits:region] animated:YES];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MACustomizedAnnotation class]])
    {
        static NSString *animatedAnnotationIdentifier = @"AnimatedAnnotationIdentifier";
        
        MACustomizedAnnotationView *annotationView = (MACustomizedAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:animatedAnnotationIdentifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MACustomizedAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:animatedAnnotationIdentifier];
            
            annotationView.canShowCallout   = YES;
            annotationView.draggable        = YES;
        }
        
        return annotationView;
    }
    
    return nil;
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [myMapView setRegion:[myMapView regionThatFits:region] animated:YES];
//    
//    for(int i =0 ; i< 10 ; i++){
//        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//        CLLocationDegrees longitude = userLocation.coordinate.longitude - 0.01*i + random()%360 * 0.0001;
//        CLLocationDegrees latitude  = userLocation.coordinate.latitude + 0.01*i + random()%360 * 0.0001;
//        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
//        point.coordinate = location.coordinate;
//        [self.myMapView addAnnotation:point];
//    }
//    
//}

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
//    CLLocation *fakeLocation = [[CLLocation alloc] initWithLatitude:42.356426 longitude:-71.061993];
//    _locationManager.location = fakeLocation;
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

#pragma mark - TheSidebarController Delegate Methods
- (void)sidebarController:(TheSidebarController *)sidebarController willShowViewController:(UIViewController *)viewController
{
    NSLog(@"sidebarController:%@ willShowViewController:%@", sidebarController, viewController);
}

- (void)sidebarController:(TheSidebarController *)sidebarController didShowViewController:(UIViewController *)viewController
{
    NSLog(@"sidebarController:%@ didShowViewController:%@", sidebarController, viewController);
}

- (void)sidebarController:(TheSidebarController *)sidebarController willHideViewController:(UIViewController *)viewController
{
    NSLog(@"sidebarController:%@ willHideViewController:%@", sidebarController, viewController);
}

- (void)sidebarController:(TheSidebarController *)sidebarController didHideViewController:(UIViewController *)viewController
{
    NSLog(@"sidebarController:%@ didHideViewController:%@", sidebarController, viewController);
}

#pragma MKAnnotation



//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    MKAnnotationView *pinView = nil;
//    if(annotation != mapView.userLocation)
//    {
//        static NSString *defaultPinID = @"com.invasivecode.pin";
//        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//        if ( pinView == nil )
//            pinView = [[MKAnnotationView alloc]
//                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
//        
//        //pinView.pinColor = MKPinAnnotationColorGreen;
//        pinView.canShowCallout = YES;
//        //pinView.animatesDrop = YES;
//        pinView.image = [UIImage imageNamed:@"Ball.png"];    //as suggested by Squatch
//    }
//    else {
//        [mapView.userLocation setTitle:@"I am here"];
//    }
//    return pinView;
//}

@end
