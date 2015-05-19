//
//  DDGeoOperation.h
//  ObjectiveCPractice
//
//  Created by LEE CHIEN-MING on 4/10/15.
//  Copyright (c) 2015 Derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

typedef void (^DDReverseGeocodingCompletion) (CLPlacemark *placemark, NSError *error);

@interface DDReverseGeoOperation : NSOperation

/**
 DDReverseGeoOperation intializer
 
 @param coder      CLGeocoder instance
 @param location   Target location
 @param completion Completion block. The form of the completion block is as same as DDReverseGeocodingResult.
 
 @return DDReverseGeoOperation instance
 */
- (instancetype)initWithGeocoder:(CLGeocoder *)coder location:(CLLocation *)location completion:(DDReverseGeocodingCompletion)completion;
@end
