//
//  Created by LEE CHIEN-MING on 7/29/13.
//  Copyright (c) 2013 iamds. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NSObject+NullPrevention.h"

@interface DSGeoReverseManager : NSObject
{
    NSDictionary *_currentLocationGeoInfo;
}
//已經更新後的地理位置名稱資訊
@property (nonatomic, readonly) NSDictionary *currentLocationGeoInfo;


+(void)requestWithFinishBlock:(void(^)(NSDictionary *geoDict))successfulBlock
                    failBlock:(void(^)(NSString *errString))handlingBlock
         atLocationCoordinate:(CLLocationCoordinate2D)aCoordinate;


+(void)requestWithFinishBlock:(void (^)(NSArray *placeMarks, CLLocation *nearByLocation))successfulBlock
                    failBlock:(void (^)(NSError *error))handlingBlock
                    atAddress:(NSString *)aString;

+(DSGeoReverseManager *)sharedManager;

//Return a short name represented the user current geo location
-(NSString *)getGeoShortName;

//Return a formatedAddress
-(NSString *)getFormatedAddress;


-(BOOL)inGeocoding;


-(void)cancelGeocodingOperation;

@end
