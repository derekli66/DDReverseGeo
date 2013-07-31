//
//  DSViewController.m
//  DSReverseGeocoder
//
//  Created by LEE CHIEN-MING on 7/29/13.
//  Copyright (c) 2013 iamds. All rights reserved.
//

#import "DSViewController.h"
#import "DSGeoReverseManager.h"

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIImage *pinimg = [UIImage imageNamed:@"centerPin.png"];
    UIImageView *pinView = [[UIImageView alloc] initWithImage:pinimg];
    pinView.frame = CGRectMake(0.0f, 0.0f, pinimg.size.width, pinimg.size.height);
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    pinView.center = CGPointMake(appFrame.size.width/2, appFrame.size.height/2);
    self.centerPin = pinView;
    [self.view addSubview:self.centerPin];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.indicatorView stopAnimating];
}

#pragma mark - MKMapViewDelegate
-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    [[DSGeoReverseManager sharedManager] cancelGeocodingOperation];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
        [[DSGeoReverseManager sharedManager] cancelGeocodingOperation];
        [self.indicatorView startAnimating];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CGPoint locationPt = CGPointMake(self.centerPin.center.x, self.centerPin.center.y + self.centerPin.bounds.size.height/2);
    CLLocationCoordinate2D centerCoordinate = [self.mapView convertPoint:locationPt toCoordinateFromView:self.view];
    
    [DSGeoReverseManager requestWithFinishBlock:^(NSDictionary *geoDict) {
       NSString *address = [[DSGeoReverseManager sharedManager] getFormatedAddress];
        [self.textField setText:address];
        [self.indicatorView stopAnimating];
    } failBlock:^(NSString *errString) {
        NSLog(@"error: %@", errString);
        [self.indicatorView stopAnimating];
    } atLocationCoordinate:centerCoordinate];

}
 
@end
