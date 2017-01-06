//
//  ViewController.m
//  DeviceMotionDemo
//
//  Created by admin on 2016-12-21.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) CMMotionManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CMMotionManager alloc]init];
    
    [self.manager startDeviceMotionUpdates];
    

    self.manager.deviceMotionUpdateInterval = 0.01;
    
    ViewController * __weak weakSelf = self;
    
    // Create a parallel thread here
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [self.manager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *data, NSError *error) {
        
        // Do work here
        double x= data.gravity.x;
        double y= data.gravity.y;
        
        double rotation = -atan2(x, -y);
        
        // Update on UI always takes place on the Main Thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            weakSelf.imageView.transform = CGAffineTransformMakeRotation(rotation);
        }];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
