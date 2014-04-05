//
//  People.h
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject
@property (nonatomic,strong) NSString * firstName;
@property (nonatomic,strong) NSString * lastName;
@property (nonatomic,strong) NSString * email;
@property (nonatomic,assign)  int persID;
- (id) initWithDict: (NSDictionary *)dict;
- (NSString *) fullName;
@end
