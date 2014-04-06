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
#import "BikeAnnotationView.h"


typedef enum : NSUInteger {
    kFilterAll,
    kFilterFree,
    kFilterReserved,
    kFilterTaken
} FilterBike;

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) NSMutableArray *shownAnnotationArray;

@property (nonatomic, strong) NSMutableArray *stationAnnotationArray;
@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, assign) FilterBike filter;
@property (nonatomic, strong) NSString *filterStatus;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startUpdatingLocation];
    [self zoomMap];
    
    _filter = kFilterAll;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _annotationArray = [[NSMutableArray alloc]init];
    _shownAnnotationArray = [[NSMutableArray alloc] init];
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
- (void) showBikes:(NSMutableArray *) bikeArray
{
    [_mapView removeAnnotations:_annotationArray];
    [_annotationArray removeAllObjects];
    for (Bike * bike in bikeArray)
    {
        BikeAnnotation * bikeAnn = [[BikeAnnotation alloc] initBike:bike];
        [_annotationArray addObject: bikeAnn];
        
    }
    [self refreshBikeAnnotationView];
}
- (void) showBike:(Bike *) bike
{
    BOOL isOnMap = false;
    for (BikeAnnotation *ann in _annotationArray)
    {
        if (ann.bikeID == bike.bikeID)
        {
            if (bike.coord.latitude == ann.coordinate.latitude && bike.coord.longitude == ann.coordinate.longitude && bike.status == ann.status)
            {
                return;
            }
            if ([_shownAnnotationArray containsObject:ann] ) {
                
                if ([bike.status isEqualToString: _filterStatus])
                {   isOnMap =YES;
                    [_shownAnnotationArray removeObject:ann];
                }
                [_mapView removeAnnotation:ann];
            }
            
            [_annotationArray removeObject:ann];
            break;
        }
    }
    
    BikeAnnotation *annotation = [[BikeAnnotation alloc] initBike:bike];
    [_annotationArray addObject:annotation];
 
    if(isOnMap || _filter == kFilterAll	){
        [_shownAnnotationArray addObject:annotation];
        [_mapView addAnnotation:annotation];
        
    }
    

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
    
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString * bikeAnnotationIdentifier = @"BikeAnnotation";
    if ([annotation isKindOfClass:[BikeAnnotation class]])
    {
        BikeAnnotation *ann = (BikeAnnotation *) annotation;
        
        BikeAnnotationView * annotationView = (BikeAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:bikeAnnotationIdentifier];
        
        if (!annotationView)
        {
            annotationView = [[BikeAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:bikeAnnotationIdentifier];
        }
        annotationView.annotation = ann;
        [annotationView refreshStatus];
        [annotationView setNeedsDisplay];
        return  annotationView;
    }
    else if ([annotation isKindOfClass:[StationAnnotation class]])
    {
         static NSString * stationAnnotation = @"StationAnnotation";
        StationAnnotationView * annotationView = [[StationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:stationAnnotation];
        [annotationView setNeedsDisplay];
        return  annotationView;
    }
    
    return nil;
}

- (void) refreshBikeAnnotationView
{
    [_mapView removeAnnotations:_annotationArray];
    [_shownAnnotationArray removeAllObjects];
    
    
    if (_filter == kFilterAll)
    {
        [_mapView addAnnotations:_annotationArray];
        return;
        
    }
    
      for (BikeAnnotation* annotation in _annotationArray) {
        if ( [annotation.status isEqualToString:_filterStatus])
        {
            [_mapView addAnnotation:annotation];
            [_shownAnnotationArray addObject:annotation];
        }
    }
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

- (IBAction)currentLocationTapped:(id)sender {
    _mapView.centerCoordinate = _locationManager.location.coordinate;
}
- (IBAction)StatusSegmentChanged:(id)sender {
    
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    
    _filter = segControl.selectedSegmentIndex;
    
    switch (_filter) {
        case kFilterAll:
            _filterStatus = @"";
            break;
        case kFilterFree:
            _filterStatus = @"Free";
            break;
            
        case kFilterReserved:
            _filterStatus = @"Reserved";
            break;
            
        case kFilterTaken:
            _filterStatus = @"Taken";
            break;
            
        default:
            break;
    }

    [self refreshBikeAnnotationView];
}
@end
