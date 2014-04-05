//
//  StationAnnotation.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class Station;

@interface StationAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) int stationID;
@property (nonatomic, assign) int availableBikes;

- (id) initWithStation: (Station *) station;

@end
