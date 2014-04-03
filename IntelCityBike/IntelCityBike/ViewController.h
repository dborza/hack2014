//
//  ViewController.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BikeWebService.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate, BikeShowDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
