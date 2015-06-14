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
#import "FindViewController.h"
#import "BLParams.h"

@interface MapViewController () <MAMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>{
    double lat1,lat2,long1,long2;
    UITapGestureRecognizer *tapGesture;
    NSArray *houseNames;
    NSArray *houseAddresses;
    NSMutableArray *carArray;
    NSArray *carNames;
    NSArray *carNumbers;
}

@end

@implementation MapViewController

@synthesize myMapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftSide)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    myMapView = [[MAMapView alloc] initWithFrame:screenFrame];
    myMapView.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    long1 = 116.492479;
    long2 = 116.715633;
    lat1 = 39.948691;
    lat2 = 39.943349;
    [self.view addSubview:myMapView];
    carArray = [[NSMutableArray alloc] init];
    houseNames = [[NSArray alloc] initWithObjects:@"北京西站",@"UPS北京分公司",@"北京大山子站",@"北京东部操作中心",@"北京亦庄站",@"北京西部操作中心",@"北京亦庄南站",@"北京南部操作中心",@"北京北站",nil];
    houseAddresses = [[NSArray alloc] initWithObjects:@"海淀区田村路43号",@"朝阳区麦子店枣营路甲3号",@"朝阳区酒仙桥北路5号",@"朝阳区来广营西路316号",@"亦庄经济技术开发区东工业区双羊路18号",@"海淀区阜外亮甲1号",@"大兴区亦庄工业区新瀛工业园150号",@"经济技术开发区康定街11号",@"朝阳区万红路5号蓝涛中心",nil];
    carNames = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    carNumbers = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    [self addHouseAnnotationsToMap];
    [self addCarAnnotationsToMap];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.delegate = self;
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [_locationManager requestWhenInUseAuthorization];
    }
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(startUpdatingLocation)
                                   userInfo:nil
                                    repeats:YES];
//    [self startUpdatingLocation];
//    [_locationManager startUpdatingLocation];
    _startLocation = nil;
    
}

- (void)dealloc{
   [self.view removeGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController navigationBar].hidden = NO;
    self.navigationItem.title = @"驿站";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:22.0f],NSFontAttributeName, nil]];
    UIBarButtonItem *aButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Find.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonTapped)];
    self.navigationItem.rightBarButtonItem = aButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showLeftSide)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonTapped{
    FindViewController *contactVC = [[FindViewController alloc] init];
    [self.sidebarController.navigationController pushViewController:contactVC animated:YES];
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
    for(MACustomizedAnnotation *anno in carArray){
        double longAnno = anno.coordinate.longitude;
        double latAnno = anno.coordinate.latitude;
        int lat = arc4random()%3;
        lat = lat -1;
        int lon = arc4random()%3;
        lon = lon -1;
        [anno setCoordinate:CLLocationCoordinate2DMake(latAnno + lat*0.001, longAnno + lon * 0.001)];
    }
}


- (void)addCarAnnotationsToMap{
    for(int i =0 ;i < 9 ;i++){
        int lat = arc4random()%20;
        lat = lat -10;
        int lon = arc4random()%20;
        lon = lon -10;
        MACustomizedAnnotation *carAnno = [[MACustomizedAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat1 + lat*0.03, long1 + lon * 0.03)];
        carAnno.title = [[NSString alloc] initWithFormat:@"小二姓名:%@",[carNames objectAtIndex:i]];
        carAnno.subtitle = [[NSString alloc] initWithFormat:@"联系方式:%@",[carNumbers objectAtIndex:i]];
        carAnno.category = BLParameters.MapCar;
        if(i%2 == 0){
            carAnno.carrier = BLParameters.ShipFedex;
        }
        else{
            carAnno.carrier = BLParameters.ShipUPS;
        }
        [myMapView addAnnotation:carAnno];
        [carArray addObject:carAnno];
    }
}

- (void)addHouseAnnotationsToMap{
    for(int i =0 ;i < 9 ;i++){
        int lat = arc4random()%20;
        lat = lat -10;
        int lon = arc4random()%20;
        lon = lon -10;
        MACustomizedAnnotation *houseAnno = [[MACustomizedAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat1 + lat*0.03, long1 + lon * 0.03)];
        houseAnno.title = [[NSString alloc] initWithFormat:@"栈名:%@",[houseNames objectAtIndex:i]];
        houseAnno.subtitle = [[NSString alloc] initWithFormat:@"地址:%@",[houseAddresses objectAtIndex:i]];
        houseAnno.category = BLParameters.MapHouse;
        if(i%2 == 0){
            houseAnno.carrier = BLParameters.ShipFedex;
        }
        else{
            houseAnno.carrier = BLParameters.ShipUPS;
        }
        [myMapView addAnnotation:houseAnno];
    }
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(self.sidebarController.sidebarIsPresenting){
        return YES;
    }
    else{
        return NO;
    }
}


#pragma MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [myMapView setRegion:[myMapView regionThatFits:region] animated:YES];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MACustomizedAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MACustomizedAnnotationView *annotationView = (MACustomizedAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MACustomizedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
            MACustomizedAnnotation *annabe = (MACustomizedAnnotation *)annotation;
            annotationView.image = [UIImage imageNamed:annabe.category];
            annotationView.canShowCallout = NO;
            annotationView.carrier = annabe.carrier;
            annotationView.centerOffset = CGPointMake(0, -18);
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
