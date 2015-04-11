//
//  ViewController.m
//  DDReverseGeo
//
//  Created by LEE CHIEN-MING on 4/12/15.
//  Copyright (c) 2015 CHIENMING LEE. All rights reserved.
//

#import "ViewController.h"
#import "DDReverseGeo.h"

@import AddressBookUI;

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Sample code to demonstrate querying reverse geo
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:45.5236111 longitude:-122.675];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:37.775 longitude:-122.4183333];
    
    DDReverseGeo *geoQueue = [DDReverseGeo geoQueue];
    
    [geoQueue queryLocation:location1 result:^(CLPlacemark *placemark, NSError *error) {
        if (!error) {
            NSString *address1 = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            self.textView1.text = address1;
        }
        else {
            NSLog(@"Reverse geocoding failed with location1");
        }
    }];
    
    [geoQueue queryLocation:location2 result:^(CLPlacemark *placemark, NSError *error) {
        if (!error) {
            NSString *address2 = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            self.textView2.text = address2;
        }
        else {
            NSLog(@"Reverse geocoding failed with location1");
        }
    }];
}

@end
