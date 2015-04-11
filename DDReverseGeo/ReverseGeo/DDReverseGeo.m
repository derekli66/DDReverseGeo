//
//  DDReverseGeo.m
//  ObjectiveCPractice
//
//  Created by LEE CHIEN-MING on 4/11/15.
//  Copyright (c) 2015 Derek. All rights reserved.
//

#import "DDReverseGeo.h"
#import "DDReverseGeoOperation.h"

@interface DDReverseGeo ()
@property (nonatomic, strong) NSOperationQueue *queryQueue;
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation DDReverseGeo

+ (DDReverseGeo *)geoQueue
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queryQueue = [[NSOperationQueue alloc] init];
        _queryQueue.maxConcurrentOperationCount = 1;
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)queryLocation:(CLLocation *)location result:(DDReverseGeocodingResult)result
{
    NSAssert(location != nil, @"The location you are querying is a nil location.");

    DDReverseGeoOperation *operation = [[DDReverseGeoOperation alloc] initWithGeocoder:self.geocoder
                                                                              location:location
                                                                            completion:result];
    [self.queryQueue addOperation:operation];
}

@end
