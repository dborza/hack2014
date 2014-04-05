//
//  StationAnnotationView.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface StationAnnotationView : MKAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
- (void) animateBikeChange:(int) newAvailableBikes;
@end
