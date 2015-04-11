#DDReverseGeo

DDReverseGeo provides the reverse geocoding query in a queue format. It simplify the original querying flow while querying multiple locations.

##How to use
```objective-c
CLLocation *location1 = [[CLLocation alloc] initWithLatitude:45.5236111 longitude:-122.675];
CLLocation *location2 = [[CLLocation alloc] initWithLatitude:37.775 longitude:-122.4183333];

DDReverseGeo *geoQueue = [DDReverseGeo geoQueue];

[geoQueue queryLocation:location1 result:^(CLPlacemark *placemark, NSError *error) {
    if (!error) {
        NSString *address1 = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
        self.textView1.text = address1;
    }
}];

[geoQueue queryLocation:location2 result:^(CLPlacemark *placemark, NSError *error) {
    if (!error) {
        NSString *address2 = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
        self.textView2.text = address2;
    }
}];
```
