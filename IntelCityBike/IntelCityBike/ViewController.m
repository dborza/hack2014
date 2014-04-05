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
#import "StationAnnotation.h"
#import "StationAnnotationView.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) NSMutableArray *stationAnnotationArray;

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
    _annotationArray = [[NSMutableArray alloc]init];
    _stationAnnotationArray = [[NSMutableArray alloc]init];
    [[BikeWebService sharedBikeWebService] setDelegate:self];
    //[[BikeWebService sharedBikeWebService] getAllStations];
    
    [[BikeWebService sharedBikeWebService] startPooling];
    [[BikeWebService sharedBikeWebService] startStationsPooling];
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [_mapView removeAnnotations:_annotationArray];
        [_annotationArray removeAllObjects];
    }
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

#pragma mark - bike show delegate
- (void) showStation:(Station *)station{
 
    
    for (StationAnnotation *ann in _stationAnnotationArray)
    {
        if (ann.stationID == station.stationId)
        {
            if (ann.availableBikes == station.availableBikes)
            {
                return;
            }
            else
            {
                ann.availableBikes = station.availableBikes;
                StationAnnotationView *annView = (StationAnnotationView *)[_mapView viewForAnnotation:ann];
                [annView animateBikeChange:ann.availableBikes];
                return;
            }
            
//            [_mapView removeAnnotation:ann];
//            [_stationAnnotationArray removeObject:ann];
            break;
        }
    }

    
    StationAnnotation *annotation = [[StationAnnotation alloc] initWithStation:station];
    [_stationAnnotationArray addObject:annotation];
    [_mapView addAnnotation:annotation];

    
}
- (void) showBike:(Bike *) bike
{
    for (BikeAnnotation *ann in _annotationArray)
    {
        if (ann.bikeID == bike.bikeID)
        {
            if (bike.coord.latitude == ann.coordinate.latitude && bike.coord.longitude == ann.coordinate.longitude)
            {
                return;
            }
            [_mapView removeAnnotation:ann];
            [_annotationArray removeObject:ann];
            break;
        }
    }
    
    BikeAnnotation *annotation = [[BikeAnnotation alloc] initBike:bike];
    [_annotationArray addObject:annotation];
    [_mapView addAnnotation:annotation];
    
    //[self showBikeAtCoord:bike.coord];
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
    
  //  [self showBikeAtCoord:location.coordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString * bikeAnnotation = @"BikeAnnotation";
    if ([annotation isKindOfClass:[BikeAnnotation class]])
    {
        BikeAnnotation *ann = (BikeAnnotation *) annotation;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:bikeAnnotation];
        
        NSString * bikeIcon = @"Blue.png";

        if (ann.color && ![ann.color isEqualToString:@""])
        {
            bikeIcon = [NSString stringWithFormat:@"%@.png",ann.color];
        }
        annotationView.image = [UIImage imageNamed:bikeIcon];
                [annotationView setNeedsDisplay];
        return  annotationView;
    }
    else if ([annotation isKindOfClass:[StationAnnotation class]])
    {
         static NSString * stationAnnotation = @"StationAnnotation";
        StationAnnotationView * annotationView = [[StationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:stationAnnotation];
        [annotationView setNeedsDisplay];
//        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"StationAnnotation"];
   //    annotationView.image = [UIImage imageNamed:@"station.png"];
        return  annotationView;
    }

    
   // annotationView.centerOffset = CGPointMake(10, -20);
    
    return nil;
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
