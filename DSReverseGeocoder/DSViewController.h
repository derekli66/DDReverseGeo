//
//  DSViewController.h
//  DSReverseGeocoder
//
//  Created by LEE CHIEN-MING on 7/29/13.
//  Copyright (c) 2013 iamds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *centerPin;
@end
