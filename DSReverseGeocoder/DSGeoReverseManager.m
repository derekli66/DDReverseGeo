//
//  Created by LEE CHIEN-MING on 7/29/13.
//  Copyright (c) 2013 iamds. All rights reserved.
//

#import "DSGeoReverseManager.h"
#import <MapKit/MapKit.h>

#define DATE_FORMATE @"yyyyMMddhhmmss"

@interface DSGeoReverseManager()
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, copy) void (^reversFinished) (NSDictionary *dict);
@property (nonatomic, copy) void (^reversFailed) (NSString *errString);
@property (nonatomic, copy) void (^geoForwardFinished) (NSArray *placeMarks, CLLocation *nearByLocation);
@property (nonatomic, copy) void (^geoForwardFailed) (NSError *error);
-(NSString *)currentDateString;
-(void)errorCodeHandling:(NSInteger)errorCode;
//use with requestWithFinishBlock method
-(void)blockGetGeoreverseDataByLatitude:(CLLocationDegrees)aLat longitude:(CLLocationDegrees)aLon;
@end

@implementation DSGeoReverseManager
@synthesize currentLocationGeoInfo=_currentLocationGeoInfo;
@synthesize reversFailed, reversFinished;
#pragma mark - Initialization
-(id)init
{
    self = [super init];
    if (self) {
        /*setup geocoding manager and start updating user location*/
        if (!_geoCoder) {
            _geoCoder = [[CLGeocoder alloc] init];
        }
        _currentLocationGeoInfo = nil;
    }
    
    return self;
}

#pragma mark - Class methods
+(DSGeoReverseManager *)sharedManager
{    
    NSAssert([NSThread isMainThread], @"creating manager in other thread than main thread");
    static DSGeoReverseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[DSGeoReverseManager alloc] init];
        }
    });
    return manager;
}

+(void)requestWithFinishBlock:(void(^)(NSDictionary *geoDict))successfulBlock failBlock:(void(^)(NSString *errString))handlingBlock atLocationCoordinate:(CLLocationCoordinate2D)aCoordinate
{
    DSGeoReverseManager *manager = [DSGeoReverseManager sharedManager];
    [manager setReversFinished:successfulBlock];
    [manager setReversFailed:handlingBlock];
    [manager blockGetGeoreverseDataByLatitude:aCoordinate.latitude longitude:aCoordinate.longitude];
}

+(void)requestWithFinishBlock:(void (^)(NSArray *placeMarks, CLLocation *nearByLocation))successfulBlock failBlock:(void (^)(NSError *error))handlingBlock atAddress:(NSString *)aString
{
    DSGeoReverseManager *manager = [DSGeoReverseManager sharedManager];
    [manager setGeoForwardFinished:successfulBlock];
    [manager setGeoForwardFailed:handlingBlock];
    [manager.geoCoder geocodeAddressString:aString completionHandler:^(NSArray *placemarks, NSError *error) {        
        if (error) {
            manager.geoForwardFailed(error);
        }else{
            CLLocation *neartestPoint = ((CLPlacemark *)placemarks[0]).location;
            manager.geoForwardFinished(placemarks, neartestPoint);
        }
    }];
}

#pragma mark - Custom Methods
-(void)errorCodeHandling:(NSInteger)errorCode
{
    switch (errorCode) {
        case kCLErrorLocationUnknown:
            NSLog(NSLocalizedString(@"Location service is currently unavaliable, please try later", @"Location service is currently unavaliable, please try later"));
            break;
        case kCLErrorDenied:
            NSLog(NSLocalizedString(@"Location service is currently unavaliable, please try later", @"Location service is currently unavaliable, please try later"));
            break;
        case  kCLErrorNetwork:
            NSLog(NSLocalizedString(@"Location service is currently unavaliable, please try later", @"Location service is currently unavaliable, please try later"));
            break;
        case  kCLErrorGeocodeFoundNoResult:
            NSLog(NSLocalizedString(@"Can not find location, try later", @"Can not find location, try later"));
            break;
            
        default:
            break;
    }
}
-(NSString *)getGeoShortName
{
    NSMutableArray *shortName = [NSMutableArray array];
    if (_currentLocationGeoInfo) {
        NSDictionary *address = [_currentLocationGeoInfo objectForKey:@"addressDictionary"];
        NSLog(@"address: %@", address);
        NSString *country = stringUnNull([address objectForKey:@"Country"]);
        NSString *state = stringUnNull([address objectForKey:@"State"]); 
        NSString *city = stringUnNull([address objectForKey:@"City"]); 
        NSString *subLocality = stringUnNull([address objectForKey:@"City"]);
        if ([country isEqualToString:state]) {
            [shortName addObject:state];
        }else {
            [shortName addObject:country];
            [shortName addObject:state];
        }
        
        if (![state isEqualToString:city]) {
            [shortName addObject:city];
        }
        
        if (![subLocality isEqualToString:city]) {
            [shortName addObject:subLocality];
        }
    }
    
    return [shortName componentsJoinedByString:@" "];
}

//Return a formatedAddress
-(NSString *)getFormatedAddress
{
    return [[[self.currentLocationGeoInfo objectForKey:@"addressDictionary"] objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@" "];
}


-(BOOL)inGeocoding
{
    return [self.geoCoder isGeocoding];
}


-(void)cancelGeocodingOperation
{
    [self.geoCoder cancelGeocode];
}

-(NSString *)currentDateString
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:DATE_FORMATE];
    [outputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSString *timestamp_str = [outputFormatter stringFromDate:[NSDate date]];
	return timestamp_str;
}

//use with requestWithFinishBlock method
-(void)blockGetGeoreverseDataByLatitude:(CLLocationDegrees)aLat longitude:(CLLocationDegrees)aLon
{
    CLLocationCoordinate2D location2D = CLLocationCoordinate2DMake(aLat, aLon);
    CLLocation *locationObject = [[CLLocation alloc] initWithLatitude:location2D.latitude longitude:location2D.longitude];

    __block DSGeoReverseManager *__weak wSELF = self;
    
    [self.geoCoder reverseGeocodeLocation:locationObject completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil || [error isKindOfClass:[NSNull class]] == YES) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocation *newLocation = placemark.location;
                NSString *latString = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
                NSString *lonString = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
                NSDictionary *placeInfo = [NSDictionary dictionaryWithObjectsAndKeys: lonString, @"longitude",
                                                                                      latString, @"latitude",
                                                                                      placemark.name, @"name",
                                                                                      placemark.addressDictionary, @"addressDictionary",
                                                                                      placemark.ISOcountryCode, @"ISOcountryCode",
                                                                                      placemark.country, @"country",
                                                                                      placemark.postalCode, @"postalCode",
                                                                                      placemark.administrativeArea, @"administrativeArea",
                                                                                      placemark.subAdministrativeArea, @"subAdministrativeArea",
                                                                                      placemark.locality, @"locality",
                                                                                      placemark.subLocality, @"subLocality",
                                                                                      placemark.thoroughfare, @"thoroughfare",
                                                                                      placemark.subThoroughfare, @"subThoroughfare",
                                                                                      placemark.region, @"region",
                                                                                      nil];
                
                if (_currentLocationGeoInfo != nil) {
                    _currentLocationGeoInfo = placeInfo;
                }else {
                    _currentLocationGeoInfo = placeInfo;
                }
                
                if (wSELF.reversFinished != nil) wSELF.reversFinished(placeInfo);
                
            }else {
                NSLog(@"No place information is avaliable. No placemark avabliable!");
              if (wSELF.reversFailed != nil) wSELF.reversFailed(@"No place information is avaliable");
            }
        }else {
            NSLog(@"Reverse Geocode Location is not avaliable after requested by CLGeocoder");
            if (wSELF.reversFailed != nil) {
                wSELF.reversFailed([error localizedDescription]);
                [wSELF errorCodeHandling:[error code]];
            }
        }
    }];
}
@end
