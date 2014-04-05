//
//  ViewController.h
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BikeWebService.h"
@class BikeSearchCriteria;

@interface ViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate, BikeShowDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (void) search:(BikeSearchCriteria *) criteria;
- (IBAction)mapButtonTapped:(id)sender;
- (IBAction)bikeBuddiesTapped:(id)sender;


- (IBAction)addBuddiesTapped:(id)sender;

@end
