//
//  BikeWSRequest.h
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kWSTypeReserve,
    kWSTypeSearch,
    kWSTypeStations,
    kWSTypePeople,
    kWSTypeAddPeople,
    kWSTypeBuddiesBikes,
    kWSTypeBuddies,
    kWSTypeNone,
    
    
} WSType;

@interface BikeWSRequest : NSObject
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, assign) WSType type;

- (id) initWithRequest: (NSURLRequest *) request type:(WSType) type;
@end
