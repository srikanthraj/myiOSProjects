//
//  ViewController.m
//  GeoFenceDemo01
//
//  Created by admin on 2016-12-20.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
@import MapKit;

@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *uiSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statusCheck;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic,assign) BOOL mapisMoving;

@property (strong, nonatomic) MKPointAnnotation *currentAnno;
@property (strong, nonatomic) CLCircularRegion *geoRegion;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Turn Off UI until permissions obtained
    self.uiSwitch.enabled = NO;
    self.statusCheck.enabled = NO;
    
    // Clear Out the Labels
    
    self.eventLabel.text = @"";
    self.statusLabel.text = @"";
    
    self.mapisMoving = NO;
    
    // Setup location manager
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 3; // metres
    
    
    // Zoom the Map very Close
    CLLocationCoordinate2D noLocation;
    //MKCoordinateSpan mySpan;
    //mySpan.latitudeDelta = 500; // metres
    //mySpan.longitudeDelta = 500; // metres
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion];
    
    // Create an Annotation for user's location
    [self addCurrentAnnotation];
    
    // Setup A GeoRegion
    
    [self setUpGeoRegion];
    
    // Check if Device can do geofence
    
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]] == YES) {
        // Regardless of authorization , if device supports it, setup a geo region
        //[self setUpGeoRegion];
        
        CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
        
        if(currentStatus == kCLAuthorizationStatusAuthorizedWhenInUse || currentStatus == kCLAuthorizationStatusAuthorizedAlways) {
            self.uiSwitch.enabled = YES;
        }
        
        else { // If not authorized, request to always get location tracking
            
            [self.locationManager requestAlwaysAuthorization];
        }

    
    // Ask for Notification permissions if App is in Background
    
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication]registerUserNotificationSettings:mySettings];
    }
    
    // Device Does not support geo Region
    
    else {
        self.statusLabel.text = @"GeoRegions are not supported";
    }
}


-(void) locationManger:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus) status {
    
    CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
    
    if(currentStatus == kCLAuthorizationStatusAuthorizedWhenInUse || currentStatus == kCLAuthorizationStatusAuthorizedAlways) {
        self.uiSwitch.enabled = YES;
    }
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
    self.geoRegion = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(40.162469,-74.884583) radius:3 identifier:@"MyRegionIdentifier"];
    
}

- (IBAction)switchTapped:(id)sender {
    
    if(self.uiSwitch.isOn) {
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
        // Start Monitoring Geo region
        [self.locationManager startMonitoringForRegion:self.geoRegion];
        self.statusCheck.enabled  = YES;
    }
    
    else {
        
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
        // Stop Monitoring Geo region
        [self.locationManager stopMonitoringForRegion:self.geoRegion];
        self.statusCheck.enabled  = NO;
    }
    
}

-(void) addCurrentAnnotation {
    self.currentAnno = [[MKPointAnnotation alloc]init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0,0.0);
    self.currentAnno.title = @"My Location";
}

- (IBAction)statusCheckTapped:(id)sender {
    [self.locationManager requestStateForRegion:self.geoRegion];
}


# pragma mark - geofence call backs

-(void) locationManager:(CLLocationManager*)manager didDetermineState:(CLRegionState)state forRegion:(nonnull CLRegion *)region {
    
    if(state == CLRegionStateUnknown){
        self.statusLabel.text = @"Unknown";
       
    }
    
    else if(state == CLRegionStateInside){
        self.statusLabel.text = @"Inside";
       
    }
    
    else if(state == CLRegionStateOutside){
        self.statusLabel.text = @"Outside";
       
    }
    
    else{
        self.statusLabel.text = @"Mystery";
        
    }
    
    
}

# pragma mark - location call backs

// Call back to our class when the location manager updates the location to users location


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {

    // Update the annotation
    
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    if(self.mapisMoving == NO) { // Set Annotation only if Map is not moving
        [self.mapView setCenterCoordinate:self.currentAnno.coordinate animated:YES];
        
    }
    
}

// Enter Region
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    
    
    UILocalNotification *notif = [[UILocalNotification alloc]init];
    notif.fireDate = nil;
    notif.repeatInterval = 0;
    notif.alertTitle = @"Geofence Alert";
    notif.alertBody = @"You Entered the geoFence region";
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    self.eventLabel.text = @"Entered";
}

//Exit Region

- (void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLRegion *)region {
    
    
    UILocalNotification *notif = [[UILocalNotification alloc]init];
    notif.fireDate = nil;
    notif.repeatInterval = 0;
    notif.alertTitle = @"Geofence Alert";
    notif.alertBody = @"You Exited the geoFence region";
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    self.eventLabel.text = @"Exited";
}


@end
