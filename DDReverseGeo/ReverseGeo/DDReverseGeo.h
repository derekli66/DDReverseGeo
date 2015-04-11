//
//  DDReverseGeo.h
//  ObjectiveCPractice
//
//  Created by LEE CHIEN-MING on 4/11/15.
//  Copyright (c) 2015 Derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

typedef void (^DDReverseGeocodingResult) (CLPlacemark *placemark, NSError *error);

@interface DDReverseGeo : NSObject
/**
 Class method to return DDReverseGeo instance. Since querying reverse geo is in a queue, 
 naming geoQueue to be more sense while using DDReverseGeo
 
 @return DDReverseGeo instance
 */
+ (DDReverseGeo *)geoQueue;

/**
 Query the location. The result will be show in the result block.
 
 @param location Target location which will be translated in real address
 @param result   Query result block. Be aware that the result block is run under main thread. 
 */
- (void)queryLocation:(CLLocation *)location result:(DDReverseGeocodingResult)result;
@end
