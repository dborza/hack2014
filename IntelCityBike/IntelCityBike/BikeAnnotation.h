//
//  BikeAnnotation.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface BikeAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) int bikeID;

- (BikeAnnotation *)initWithLocation:(CLLocationCoordinate2D) coord bikeID:(int)bikeId;
@end
