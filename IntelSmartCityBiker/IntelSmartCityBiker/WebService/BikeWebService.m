//
//  BikeWebService.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "BikeWebService.h"
#import "JSONKit.h"
#import "Bike.h"
#import "Station.h"
#import <MapKit/MapKit.h>
#import "BikeWSRequest.h"
#import "BikeSearchCriteria.h"
#import "People.h"

NSString *const DanIP = @"http://danborza.com:8080";
NSString *const MihaiIP = @"http://10.41.0.136:8080";

#define PoolTime  2



@interface BikeWebService()


@property (nonatomic, strong) NSURLConnection * urlConnection;
@property (nonatomic, strong) NSMutableData * data;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *stationTimer;
@property (nonatomic, strong) JSONDecoder *decoder;
@property (nonatomic, assign) WSType connectionType;
@property (nonatomic, strong) NSTimer * requestTimer;
@property (nonatomic, strong) NSMutableArray *requestsArray;
@end

@implementation BikeWebService



- (BikeWebService *) init
{

    self = [super init];
    
    if(self)
    {
         _decoder = [[JSONDecoder alloc] init];
        _requestsArray = [[NSMutableArray alloc] init];
        _requestTimer = [[NSTimer alloc] initWithFireDate:[NSDate date ] interval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_requestTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

+ (BikeWebService *) sharedBikeWebService{
    static BikeWebService *sharedBikeService =nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBikeService = [[self alloc] init];
    });
    
    return sharedBikeService;
    
}

- (void) timerFired:(NSTimer *)timer
{
    if ([_requestsArray count]>0)
    {
        [self startNextRequest];
    }
}

- (void) getAllStations
{
    
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/stations",DanIP] ];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypeStations];
    [self enqueueRequest:bikeReq];

}

- (void) addBuddy:(int) friendID
{

    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/api/addBuddy?me=1&buddy=%d",DanIP,friendID] ];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypeAddPeople];
    [self enqueueRequest:bikeReq];

}
- (void) getMyBuddies
{
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/people/1/buddies",DanIP] ];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypeBuddies];
    [self enqueueRequest:bikeReq];

}

- (void) viewAllMyBuddies
{
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/api/getBikesOfBuddies/1",DanIP] ];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypeBuddiesBikes];
    [self enqueueRequest:bikeReq];

}

- (void) getMyFriends
{

    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/people",DanIP] ];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypePeople];
    [self enqueueRequest:bikeReq];

}

-(void) searchBike: (CLLocationCoordinate2D) coord
{
    //&status=Free
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/bikes/search/getNearestFreeOrReservedMatchingBike?lon=%.4f&lat=%.4f",DanIP,coord.longitude,coord.latitude] ];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypeSearch];
    [self enqueueRequest:bikeReq];
}

-(void) searchBikeWithCriteria: (BikeSearchCriteria *) searchCriteria
{
    //&status=Free
    
    NSString * urlString = [NSString stringWithFormat:@"%@/bikes/search/getNearestFreeOrReservedMatchingBike?lon=%.4f&lat=%.4f&gender=%@&type=%@&color=%@",DanIP,searchCriteria.coord.longitude, searchCriteria.coord.latitude,searchCriteria.gender?searchCriteria.gender:@"",searchCriteria.type?searchCriteria.type:@"",searchCriteria.color];
    

    NSURL *url = [[NSURL alloc] initWithString: urlString ];
   
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypeSearch];
    [self enqueueRequest:bikeReq];
}


- (void) reserveBikeWithId:(int) bikeID
{

    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/bikes/search/updateStatusForBikeId?id=%d&status=Reserved",DanIP,bikeID]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypeReserve];
    [self enqueueRequest:bikeReq];

}

- (void) cancelBikeWithId:(int) bikeID
{
    
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/bikes/search/updateStatusForBikeId?id=%d&status=Free",DanIP,bikeID]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    BikeWSRequest *bikeReq =[[BikeWSRequest alloc] initWithRequest:request type:kWSTypeReserve];
    [self enqueueRequest:bikeReq];
    
}

#pragma mark -  internal methods

- (void) enqueueRequest:(BikeWSRequest *) bikeRequest
{
    [_requestsArray addObject:bikeRequest];
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startNextRequest];
    });

}
- (void) startNextRequest
{
    if (!_urlConnection && [_requestsArray count]>0)
    {
        BikeWSRequest   *bikeRequest = (BikeWSRequest *)[_requestsArray objectAtIndex:0];
        _urlConnection = [[NSURLConnection alloc] initWithRequest:bikeRequest.request delegate:self startImmediately:YES];
        _connectionType = bikeRequest.type;
    }

}

- (NSDictionary *) decodeBikes:(NSData *) bikes
{
    
    NSDictionary * dict = [_decoder objectWithData:bikes];
    NSDictionary * bikesDict = [dict objectForKey:@"_embedded"];
    NSArray *bikesArray = [bikesDict objectForKey:@"bikes"];
    
    for (NSDictionary *oneBikeDict in bikesArray ) {
        
        Bike * oneBike = [[Bike alloc] initWithDict:oneBikeDict];
        if (_delegate && [_delegate respondsToSelector:@selector(showBike:)])
        {
            [_delegate showBike:oneBike];
        }
    }
    return dict;
}

- (NSDictionary *) decodeBuddyBikes:(NSData *) bikes
{
    
    NSDictionary * dict = [_decoder objectWithData:bikes];
    NSArray *bikesArray = dict;
    
    for (NSDictionary *oneBikeDict in bikesArray ) {
        
        Bike * oneBike = [[Bike alloc] initWithDict:oneBikeDict];
        if (_delegate && [_delegate respondsToSelector:@selector(showBike:)])
        {
            [_delegate showBike:oneBike];
        }
    }
    return dict;
}

- (NSDictionary *) decodePeople:(NSData *) people
{
    
    NSDictionary * dict = [_decoder objectWithData:people];
    NSDictionary * bikesDict = [dict objectForKey:@"_embedded"];
    NSArray *bikesArray = [bikesDict objectForKey:@"people"];
    
    NSMutableArray *allPeople = [[NSMutableArray alloc] init];
    
    for (NSDictionary *oneBikeDict in bikesArray ) {
        
        People * onePers = [[People alloc] initWithDict:oneBikeDict];
       
        [allPeople addObject:onePers];
    }
    
    if ( _connectionType == kWSTypeBuddies)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(receivedBuddies:)])
        {
            [_delegate receivedBuddies:allPeople];
        }
 
    }
    else if ( _connectionType == kWSTypePeople) {
        if (_delegate && [_delegate respondsToSelector:@selector(receivedPeople:)])
        {
            [_delegate receivedPeople:allPeople];
        }
    }

    return dict;
}

- (NSDictionary *) decodeStations:(NSData *) bikes
{
    
    NSDictionary * dict = [_decoder objectWithData:bikes];
    NSDictionary * stationsDict = [dict objectForKey:@"_embedded"];
    NSArray *stationsArray = [stationsDict objectForKey:@"stations"];
    
    for (NSDictionary *oneStationDict in stationsArray ) {
        
        Station * oneStation = [[Station alloc] initWithDict:oneStationDict];
        if (_delegate && [_delegate respondsToSelector:@selector(showStation:)])
        {
            [_delegate showStation:oneStation];
        }
    }
    return dict;
}

- (void) processResponse: (NSMutableData *)data
{
    
    NSString *s = [[NSString alloc] initWithBytes:_data.bytes length:[_data length] encoding:NSUTF8StringEncoding];
    NSLog(@"Response received: %@",s);
    switch (_connectionType) {
        case kWSTypeSearch:
        {
            [self decodeBikes:data];
        }
            break;
        case kWSTypeBuddiesBikes:
        {
            [self decodeBuddyBikes:data];
        }
            break;

        case kWSTypeStations:
        {
            [self decodeStations:data];
        }
            break;

        case kWSTypePeople:
        {
            [self decodePeople:data];
            
        }
            break;
        case kWSTypeBuddies:
        {
            [self decodePeople:data];
            
        }
            break;
        case kWSTypeAddPeople:
        {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getMyBuddies];
                
            });

            if (_delegate && ([_delegate respondsToSelector:@selector(refreshBikeBuddies)]))
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_delegate refreshBikeBuddies];
                    
                });
                
            }

        }
            break;
        case kWSTypeReserve:
            if (_delegate && ([_delegate respondsToSelector:@selector(refreshBikes)]))
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_delegate refreshBikes];
                });
                
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - nsurlconnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_urlConnection cancel];
    _urlConnection = nil;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     BikeWSRequest *bikeRequest = (BikeWSRequest *)[_requestsArray objectAtIndex:0];
    if (bikeRequest.request == connection.currentRequest) {
        [_requestsArray removeObject:bikeRequest];
    }
    
    [self processResponse:_data];

    [_urlConnection cancel];
    _urlConnection = nil;
    _connectionType = kWSTypeNone;
    [self startNextRequest];
}

// #pragma mark - stations and bike pooling
//
//- (void) stationsPool{
//    
//    
//    NSError *error = nil;
//    NSURLResponse *response = nil;
//    
//    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/stations",DanIP] ];
//    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:5 ];
//    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    if (!error)
//    {
//        [self performSelectorOnMainThread:@selector(decodeStations:) withObject:responseData waitUntilDone:YES];
//    }
//    
//    //   [self performSelector:@selector(longBikesPool) withObject:nil];
//    //  NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
//    if (_stationTimer == nil)
//    {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _stationTimer = [NSTimer scheduledTimerWithTimeInterval:PoolTime target:self selector:@selector(stationsTimerFired:) userInfo:nil repeats:NO];
//        });
//    }
//    //    [self performSelector:@selector(longBikesPool) withObject:nil afterDelay:PoolTime];
//    
//}


//- (void) longBikesPool{
//    
//    
//    NSError *error = nil;
//    NSURLResponse *response = nil;
//    
//    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/bikes/?page=0&size=10000",DanIP] ];
//    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:5 ];
//    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    if (!error)
//    {
//        [self performSelectorOnMainThread:@selector(decodeBikes:) withObject:responseData waitUntilDone:YES];
//    }
//    
// //   [self performSelector:@selector(longBikesPool) withObject:nil];
//  //  NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
//    if (_timer == nil)
//    {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
//        });
//    }
////    [self performSelector:@selector(longBikesPool) withObject:nil afterDelay:PoolTime];
//   
//}
//
//-(void) stationsTimerFired:(NSTimer *)timer{
//    
//    _stationTimer = nil;
//    [self performSelectorInBackground:@selector(stationsPool) withObject:nil];
//}
//
//-(void) timerFired:(NSTimer *)timer{
//
//    _timer = nil;
//    [self performSelectorInBackground:@selector(longBikesPool) withObject:nil];
//}
//
//- (void) startStationsPooling
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self performSelectorInBackground:@selector(stationsPool) withObject:nil];
//    });
//    
//}
//
//- (void) startPooling
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self performSelectorInBackground:@selector(longBikesPool) withObject:nil];
//    });
//
//}
@end
