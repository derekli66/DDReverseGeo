//
//  DDGeoOperation.m
//  ObjectiveCPractice
//
//  Created by LEE CHIEN-MING on 4/10/15.
//  Copyright (c) 2015 Derek. All rights reserved.
//

#import "DDReverseGeoOperation.h"

@interface DDReverseGeoOperation ()
@property (nonatomic, strong, readonly) CLGeocoder *geocoder;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, copy) DDReverseGeocodingCompletion completion;
@property (nonatomic, assign, readonly) BOOL reverseGeocodingEnded;
@end

@implementation DDReverseGeoOperation

- (instancetype)initWithGeocoder:(CLGeocoder *)coder location:(CLLocation *)location completion:(DDReverseGeocodingCompletion)completion;
{
    NSAssert(coder, @"The geocoder should not be nil.");
    NSAssert(location, @"The location being passed in is nil.");
    
    self = [super init];
    if (self) {
        _geocoder = coder;
        _location = location;
        _completion = [completion copy];
        _reverseGeocodingEnded = NO;
    }
    return self;
}

- (void)start
{
    __block CLPlacemark *placemark = nil;
    __block NSError *geoerror = nil;
    __block typeof(self) __weak weakSELF = self;
    
    [self.geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!(geoerror = error)) {
            placemark = [placemarks lastObject];
        }
        
        DDReverseGeoOperation *strongSELF = weakSELF;
        
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        strongSELF -> _reverseGeocodingEnded = YES;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (strongSELF.completion) strongSELF.completion(placemark, geoerror);
        });
    }];
}

- (BOOL)isFinished
{
    return self.reverseGeocodingEnded;
}

- (BOOL)isExecuting
{
    return !self.reverseGeocodingEnded;
}

@end
