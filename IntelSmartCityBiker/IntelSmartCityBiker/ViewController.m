//
//  ViewController.m
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "ViewController.h"
#import "SearchTableViewController.h"
#import "UIStoryboard+Main.h"
#import "BikeAnnotation.h"
#import "BikeWebService.h"
#import "StationAnnotation.h"
#import "StationAnnotationView.h"
#import "BikeAnnotationView.h"
#import "BikeSearchCriteria.h"
#import "AddBuddiesViewController.h"
#import "People.h"

@interface ViewController ()

@property (nonatomic, strong) SearchTableViewController *searchVC;
@property (nonatomic, strong) UIPopoverController *pop;

@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) NSMutableArray *stationAnnotationArray;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) BikeSearchCriteria *lastCriteria;
@property (nonatomic, strong) NSMutableArray *peopleArr;
@property (nonatomic, strong) NSMutableArray *buddiesArr;


@property (nonatomic, strong) UIPopoverController *peoplePopover;
@property (nonatomic, strong) AddBuddiesViewController *addVC;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchVC = [[UIStoryboard ICBMainStoryboard] instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    _searchVC.delegate = self;
    _pop = [[UIPopoverController alloc] initWithContentViewController:_searchVC];
    [_pop setPopoverContentSize:CGSizeMake(500,580)];
    

    _addVC = [[AddBuddiesViewController alloc] initWithNibName:@"AddBuddiesViewController" bundle:nil];
    _addVC.delegate=self;
    _peoplePopover = [[UIPopoverController alloc] initWithContentViewController:_addVC];
    [_peoplePopover setPopoverContentSize:_addVC.view.frame.size];
    
    [self startUpdatingLocation];
    [self zoomMap];
    
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _annotationArray = [[NSMutableArray alloc]init];
    _stationAnnotationArray = [[NSMutableArray alloc]init];
    [[BikeWebService sharedBikeWebService] setDelegate:self];
    [[BikeWebService sharedBikeWebService] getMyFriends];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//for shake
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
        
        //        [_mapView removeAnnotations:_annotationArray];
        //        [_annotationArray removeAllObjects];
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
            [_mapView removeAnnotation:ann];
            [_stationAnnotationArray removeObject:ann];
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

#pragma mark - MKMapDelegate
-  (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    if ([view isKindOfClass:[BikeAnnotationView class]])
    {
        BikeAnnotation * bikeAnn = (BikeAnnotation *)view.annotation;
        if ([bikeAnn.status isEqualToString:@"Free"])
        {
            [[BikeWebService sharedBikeWebService] reserveBikeWithId:((BikeAnnotationView *)view).bikeID];
        }
        else if
            ([bikeAnn.status isEqualToString:@"Reserved"])
        {
            [[BikeWebService sharedBikeWebService] cancelBikeWithId:((BikeAnnotationView *)view).bikeID];
        }
        [mapView deselectAnnotation:view.annotation animated:YES];
    }
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BikeAnnotation class]])
    {
        static NSString * bikeAnnotationIdentifier = @"bikeAnntotationIdentifier";
        
        BikeAnnotationView * annView = (BikeAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:bikeAnnotationIdentifier];
        
        if (!annView)
        {
            
            annView = [[BikeAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:bikeAnnotationIdentifier];
            
        }
        
       
      
        BikeAnnotation * bikeAnn = (BikeAnnotation *)annotation;
        annView.annotation = annotation;
        annView.canShowCallout = YES;
        annView.bikeID = bikeAnn.bikeID;
        [annView refreshStatus];
        
        UIButton * button = [[UIButton alloc] initWithFrame:(CGRect) {0,0,80,20}];
        button.layer.cornerRadius = 5;
        
        if ([bikeAnn.status isEqualToString:@"Reserved"]) {
               [button setTitle:@"Cancel" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        }
        else
        {
         [button setTitle:@"Reserve" forState:UIControlStateNormal];
         button.backgroundColor = [UIColor redColor];
        }
        
        annView.rightCalloutAccessoryView = button;
        [annView setNeedsDisplay];
        
        return  annView;
    }
    else if ([annotation isKindOfClass:[StationAnnotation class]])
    {
        StationAnnotationView * annotationView = [[StationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"StationAnnotation"];
        //        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"StationAnnotation"];
        //        annotationView.image = [UIImage imageNamed:@"station.png"];
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


- (void) search:(BikeSearchCriteria *) criteria;
{
    [_mapView  removeAnnotations:_annotationArray];
    [_annotationArray removeAllObjects];
    if ([_pop isPopoverVisible])
    {
        [_pop dismissPopoverAnimated:YES];
    }
    
    criteria.coord = _locationManager.location.coordinate;
    [[BikeWebService sharedBikeWebService] searchBikeWithCriteria:criteria];
    _lastCriteria = criteria;
//    [[BikeWebService sharedBikeWebService] searchBike:_locationManager.location.coordinate];
}

- (IBAction)mapButtonTapped:(id)sender {
    _lastCriteria = nil;
    [[BikeWebService sharedBikeWebService] searchBike:_locationManager.location.coordinate];
}

- (IBAction)bikeBuddiesTapped:(id)sender {
    [self refreshBikeBuddies];

}


- (IBAction)searchButtonTapped:(id)sender {
    

    [_pop presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                permittedArrowDirections:UIPopoverArrowDirectionDown
                                animated:YES ];
}
- (IBAction)currentLocationButtonTapped:(id)sender {
    
    [_mapView setCenterCoordinate:_locationManager.location.coordinate];
}

- (void) refreshBikeBuddies
{
    [_mapView  removeAnnotations:_annotationArray];
    [_annotationArray removeAllObjects];
     [[BikeWebService sharedBikeWebService] viewAllMyBuddies];
    
}

- (void) refreshBikes
{
 
    if (_lastCriteria)
    {
        [[BikeWebService sharedBikeWebService] searchBikeWithCriteria:_lastCriteria];
    }
    else
    {
     [[BikeWebService sharedBikeWebService] searchBike:_locationManager.location.coordinate];
    }
}

- (void) receivedPeople:(NSMutableArray *)peopleArr
{
    _peopleArr = peopleArr;
    _addVC.people = _peopleArr;
    
    [[BikeWebService sharedBikeWebService] getMyBuddies];
    if (_peoplePopover.isPopoverVisible)
    {
        [_addVC.peopleTableView reloadData];
    }

}
- (void) receivedBuddies:(NSMutableArray *)peopleArr
{
    _buddiesArr = peopleArr;
    _addVC.people = _peopleArr;
    _addVC.buddies = _buddiesArr;
    if (_peoplePopover.isPopoverVisible)
    {
        [_addVC.peopleTableView reloadData];
    }
    
}

- (IBAction)addBuddiesTapped:(id)sender {
    
    [[BikeWebService sharedBikeWebService] getMyFriends];
    [_peoplePopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                 permittedArrowDirections:UIPopoverArrowDirectionDown
                                 animated:YES ];

}

-(void)addABuddy:(People*) people
{
    if ([_peoplePopover isPopoverVisible])
    {
        [_peoplePopover dismissPopoverAnimated:YES];
    }
    [[BikeWebService sharedBikeWebService] addBuddy:people.persID];
}
@end
