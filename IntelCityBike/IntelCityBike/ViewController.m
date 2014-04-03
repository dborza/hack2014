//
//  ViewController.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "ViewController.h"
#import "BikeAnnotation.h"
#import "BikeWebService.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startUpdatingLocation];
    [self zoomMap];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
    [[BikeWebService sharedBikeWebService] getAllBikes];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) startUpdatingLocation
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 100;//meters
    _locationManager.pausesLocationUpdatesAutomatically = YES;
    [_locationManager startUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark - CLLocationManager delegate
-  (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    [_mapView setCenterCoordinate:location.coordinate];
    MKCoordinateRegion region =  _mapView.region;
    
    
    region.span.longitudeDelta =0.01;
    region.span.latitudeDelta =0.01;
    
   
    [_mapView setRegion:region];
    
    [self showBikeAtCoord:location.coordinate];
}

- (void) showBikeAtCoord:(CLLocationCoordinate2D) coord
{
    BikeAnnotation *annotation = [[BikeAnnotation alloc] initWithLocation:coord];
    [_mapView addAnnotation:annotation];
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BikeAnnotation"];
    annotationView.image = [UIImage imageNamed:@"bike1.png"];
   // annotationView.centerOffset = CGPointMake(10, -20);
    
    return  annotationView;
}



#pragma mark - other map methods
- (void) zoomMap
{

    MKCoordinateRegion region = _mapView.region;
    
    region.span.longitudeDelta /=2.0;
    region.span.latitudeDelta /=2.0;
    
    
    [_mapView setRegion:region];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
