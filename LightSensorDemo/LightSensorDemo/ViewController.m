//
//  ViewController.m
//  LightSensorDemo
//
//  Created by admin on 2016-12-21.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageNeedle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(react) name:UIScreenBrightnessDidChangeNotification object:nil];
    
}


-(void) react {

    double brightness = [[UIScreen mainScreen]brightness];
    CGAffineTransform rotate = CGAffineTransformMakeRotation((brightness - M_PI) - M_PI_2);

    self.imageNeedle.transform = rotate;
}


@end
