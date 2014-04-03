//
//  BikeWebService.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BikeWebService : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
+ (id) sharedBikeWebService;
- (void) getAllBikes;
@end
