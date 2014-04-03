//
//  BikeWebService.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bike.h"


@protocol BikeShowDelegate <NSObject>

-(void) showBike:(Bike *) bike;

@end

@interface BikeWebService : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<BikeShowDelegate> delegate;

+ (id) sharedBikeWebService;
- (void) getAllBikes;
- (void) startPooling;
- (void) getAllStations;
@end
