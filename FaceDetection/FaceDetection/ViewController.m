//
//  ViewController.m
//  FaceDetection
//
//  Created by admin on 2016-10-04.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
#import "CoreImage/CoreImage.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *facePicture;

-(void) markFaces:(UIImageView *)facePicture;
-(void) faceDetector;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)faceDetector
{
    
    
    NSLog(@"iOS Version is %@",[[UIDevice currentDevice] systemVersion]);
    
    // Load the picture for face detection
    UIImageView* image = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"test.jpg"]];
    
    [image setTransform:CGAffineTransformMakeScale(1, -1)];
    
    // flip the entire window to make everything right side up
    [self.view.window setTransform:CGAffineTransformMakeScale(1, -1)];
    
    // Draw the face detection image
   [self.view.window addSubview:image];
    
    // Execute the method used to markFaces in background
    [self markFaces:image];
}

-(void) markFaces:(UIImageView *)facePicture {
    
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    
    
    NSArray* features = [detector featuresInImage:image];
    
    
    NSLog(@"Number of Faces is %lu",(unsigned long)[features count]);
    
    
    for(CIFaceFeature* faceFeature in features){
        
    
        CGFloat faceWidth = faceFeature.bounds.size.width;
         UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        
        
        
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        // add the new view to create a box around the face
        [self.view.window addSubview:faceView];
        
        
        if(faceFeature.hasLeftEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            [self.view.window addSubview:leftEyeView];
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the rightEyeView based on the face
            [leftEye setCenter:faceFeature.rightEyePosition];
            // round the corners
            leftEye.layer.cornerRadius = faceWidth*0.15;
            // add the new view to the window
            [self.view.window addSubview:leftEye];
        }        if(faceFeature.hasMouthPosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* mouth = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            // change the background color for the mouth to green
            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
            // set the position of the mouthView based on the face
            [mouth setCenter:faceFeature.mouthPosition];
            // round the corners
            mouth.layer.cornerRadius = faceWidth*0.2;
            // add the new view to the window
            [self.view.window addSubview:mouth];
        }
    }
    
    
    
    
}


- (IBAction)submitTapped:(id)sender {
    [self faceDetector];
     //[self.view.window addSubview:self.facePicture];
}

@end
