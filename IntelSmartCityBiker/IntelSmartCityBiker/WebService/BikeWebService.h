//
//  BikeWebService.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bike.h"
#import "Station.h"
#import "BikeSearchCriteria.h"


@protocol BikeShowDelegate <NSObject>

-(void) showBike:(Bike *) bike;
-(void) showStation:(Station *) station;
-(void) receivedPeople:(NSMutableArray *) peopleArr;
-(void) refreshBikes;
-(void) refreshBikeBuddies;


@end

@interface BikeWebService : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<BikeShowDelegate> delegate;

+ (id) sharedBikeWebService;
- (void) getAllBikes;
- (void) startPooling;
- (void) getAllStations;
- (void) startStationsPooling;
- (void) searchBikeWithCriteria:(BikeSearchCriteria *) searchCriteria;
- (void) searchBike: (CLLocationCoordinate2D) coord;
- (void) reserveBikeWithId:(int) bikeID;
- (void) cancelBikeWithId:(int) bikeID;
- (void) getMyFriends;
- (void) addBuddy:(int) friendID;
- (void) viewAllMyBuddies;

@end
