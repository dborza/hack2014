//
//  BikeAnnotationView.h
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BikeAnnotationView : MKAnnotationView
@property (nonatomic,assign) int bikeID;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
- (void) refreshStatus;
@end
