//
//  ViewController.m
//  GeoFenceCouponsAssignment
//
//  Created by admin on 2016-12-21.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
@import MapKit;

@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPointAnnotation *businessAnno;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic,assign) BOOL mapisMoving;
@property (strong, nonatomic) CLCircularRegion *geoRegion;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.mapisMoving = NO;
    self.mapView.camera.altitude *= 1.4;
    
// Create an Annotation for Business Point
    self.businessAnno = [[MKPointAnnotation alloc]init];
    self.businessAnno.coordinate = CLLocationCoordinate2DMake(40.162469,-74.884583);
    self.businessAnno.title = @"Business Location";
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    [self.mapView addAnnotation:self.businessAnno];
    
    
    
  
    
    // Setup Location Manager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    
    self.mapView.showsUserLocation = YES;
    [self.locationManager startUpdatingLocation];
    // Start Monitoring Geo region
    [self.locationManager startMonitoringForRegion:self.geoRegion];
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10; // metres
    
    
    
    // Zoom the Map very Close
    
    CLLocationCoordinate2D noLocation;
    //MKCoordinateSpan mySpan;
    //mySpan.latitudeDelta = 500; // metres
    //mySpan.longitudeDelta = 500; // metres
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion];
    
    
    [self.mapView setCenterCoordinate:self.businessAnno.coordinate animated:YES];
    
    // Setup A GeoRegion
    
    [self setUpGeoRegion];
    
    // Check if Device can do geofence
    
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]] == YES) {
        // Regardless of authorization , if device supports it, setup a geo region
        //[self setUpGeoRegion];
        
        CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
        
        if(currentStatus != kCLAuthorizationStatusAuthorizedWhenInUse || currentStatus != kCLAuthorizationStatusAuthorizedAlways) { // If not authorized, request to always get location tracking
           
            [self.locationManager requestAlwaysAuthorization];
        }
        
        
        // Ask for Notification permissions if App is in Background
        
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:mySettings];
    }
    
    // Device Does not support geo Region
    
    else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"GeoRegions are not supported" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    
    }

    
    [self.locationManager startUpdatingLocation];
    // Start Monitoring Geo region
    [self.locationManager startMonitoringForRegion:self.geoRegion];
}


-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapisMoving = YES;
}

-(void) mapView:(MKMapView *) mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapisMoving = NO;
}

// Function to Setup Geo Region

- (void) setUpGeoRegion {
    // Create the Geographic Region to be monitored
    self.geoRegion = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(self.businessAnno.coordinate.latitude,self.businessAnno.coordinate.longitude) radius:3 identifier:@"MyRegionIdentifier"];
    
}

# pragma mark - location call backs


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // Update the annotation
    

    if(self.mapisMoving == NO) { // Set Annotation only if Map is not moving
        [self.mapView setCenterCoordinate:locations.lastObject.coordinate animated:YES];
        
    }
    
}

// Enter Region
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    
    
    UILocalNotification *notif = [[UILocalNotification alloc]init];
    notif.fireDate = nil;
    notif.repeatInterval = 0;
    notif.alertTitle = @"Exclusive Offer!";
    notif.alertBody = @"Shop today at ABC and get Get 30% Off - Coupon Code GHJDUFGF";
    notif.alertAction = @"OK";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}


@end
