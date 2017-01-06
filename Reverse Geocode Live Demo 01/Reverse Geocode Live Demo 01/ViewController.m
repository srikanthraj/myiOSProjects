//
//  ViewController.m
//  Reverse Geocode Live Demo 01
//
//  Created by admin on 2016-12-18.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;
@import MapKit;

@interface ViewController () <MKMapViewDelegate>
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *geoCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;

@property (assign,nonatomic) BOOL lookupUp;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.geocoder = [[CLGeocoder alloc]init];
    self.geoCodeLabel.text = nil;
    self.geoCodeLabel.alpha = 0.5;
    self.lookupUp = NO;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self executeTheLookUp];
}



# pragma mark - Private

-(void)executeTheLookUp {
    
    if(self.lookupUp == NO) {
        self.lookupUp = YES; // Starting the lookup
    CLLocationCoordinate2D coord = [self locationAtCenterOfMapView];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
        [self startReverseGeoCodeLocation:loc];
    }
}

-(CLLocationCoordinate2D) locationAtCenterOfMapView {
    
    CGPoint centerOfPin = CGPointMake(CGRectGetMidX(self.pinIcon.bounds), CGRectGetMidY(self.pinIcon.bounds)); // in Image View coord space

    return [self.mapView convertPoint:centerOfPin toCoordinateFromView:self.pinIcon];
}


-(void) startReverseGeoCodeLocation :(CLLocation *)location {
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error){
        
        if(error) {
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"There was a problem reverse geocoding" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:ac animated:YES completion:nil];
            return;
        }
        
        // Grab some interesting bits of CLPlacemark
        
        NSMutableSet *mappedPlacesDescs = [NSMutableSet new];
        
        for(CLPlacemark *p in placemarks) {
            
            // Add Name of placemark
            
            if(p.name !=nil)
                [mappedPlacesDescs addObject:p.name];
            
            // Add name of Administrative Area
            
            if(p.administrativeArea !=nil)
                [mappedPlacesDescs addObject:p.administrativeArea];
            
            // Add name of Country
            
            if(p.country !=nil)
                [mappedPlacesDescs addObject:p.country];
            
            // Add Areas of Interest which is an array
            
            [mappedPlacesDescs addObjectsFromArray:p.areasOfInterest];
            
        }
        
        self.geoCodeLabel.text = [[mappedPlacesDescs allObjects]componentsJoinedByString:@"\n"];
        
        // Setting Back the alpha to 1.0
            self.geoCodeLabel.alpha = 1.0;
        // Set Lookup to No again
        self.lookupUp = NO;
    }];
}

@end
