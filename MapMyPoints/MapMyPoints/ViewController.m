//
//  ViewController.m
//  MapMyPoints
//
//  Created by admin on 2016-10-06.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong,nonatomic) MKPointAnnotation *bahamasAnno;

@property (strong,nonatomic) MKPointAnnotation *timesSquareAnno;

@property (strong,nonatomic) MKPointAnnotation *miamiBeachAnno;

@property (strong,nonatomic) MKPointAnnotation *currentAnno;

@property (weak, nonatomic) IBOutlet UISwitch *switchField;

@property(strong, nonatomic) CLLocationManager *locationManager;

@property(nonatomic,assign) BOOL mapIsMoving;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapIsMoving  = NO;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
        [self addAnnotations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bahamasTapped:(id)sender {

    [self centerMap:self.bahamasAnno];
}

- (IBAction)timesSquareTapped:(id)sender {
    [self centerMap:self.timesSquareAnno];
}

- (IBAction)miamiBeachTapped:(id)sender {
    
    [self centerMap:self.miamiBeachAnno];
}
- (IBAction)switchChanged:(id)sender {
    
    if(self.switchField.isOn){
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    }
    
    else {
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
    }
}



-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    
    if(self.mapIsMoving == NO){
        [self centerMap:self.currentAnno];
    
    }
}

-(void) centerMap:(MKPointAnnotation *)centerPoint{
    
    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}

-(void) addAnnotations {
    
    self.bahamasAnno = [[MKPointAnnotation alloc]init];
    
    self.bahamasAnno.coordinate = CLLocationCoordinate2DMake(24.4179212,-78.2105907);
    
    self.bahamasAnno.title = @"The Bahamas";
    
    
    self.timesSquareAnno = [[MKPointAnnotation alloc]init];
    
    self.timesSquareAnno.coordinate = CLLocationCoordinate2DMake(40.758895,-73.9873197);
    
    self.timesSquareAnno.title = @"Times Square,NY";
    
    
    self.miamiBeachAnno = [[MKPointAnnotation alloc]init];
    
    self.miamiBeachAnno.coordinate = CLLocationCoordinate2DMake(25.8139502,-80.1793261);
    
    self.miamiBeachAnno.title = @"Miami Beach,FL";
    
    
    self.currentAnno = [[MKPointAnnotation alloc]init];
    
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0,0.0);
    
    self.currentAnno.title = @"My Current Location";
    
    [self.mapView addAnnotations:@[self.bahamasAnno,self.timesSquareAnno,self.miamiBeachAnno]];
    
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapIsMoving = YES;
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapIsMoving = NO;
}


@end
