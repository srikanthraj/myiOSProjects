//
//  ViewController.m
//  DrumKitAssignment
//
//  Created by admin on 2016-12-21.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
@import AudioToolbox;
@import AVFoundation.AVAudioPlayer;

@interface ViewController ()


@property(nonatomic,assign) SystemSoundID beepA;
@property(nonatomic,assign) SystemSoundID beepB;
@property(nonatomic,assign) SystemSoundID beepC;
@property(nonatomic,assign) SystemSoundID beepD;
@property(strong,nonatomic) AVAudioPlayer *player;


@property(nonatomic,assign) BOOL beepAGood;
@property(nonatomic,assign) BOOL beepBGood;
@property(nonatomic,assign) BOOL beepCGood;
@property(nonatomic,assign) BOOL beepDGood;
@property(nonatomic,assign) BOOL longSongGood;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the sound / Create the sound ID
    NSString *soundAPath = [[NSBundle mainBundle] pathForResource:@"beep-01" ofType:@"wav"];
    NSURL *urlA = [NSURL fileURLWithPath:soundAPath];
    
    NSString *soundBPath = [[NSBundle mainBundle] pathForResource:@"beep-02" ofType:@"wav"];
    NSURL *urlB = [NSURL fileURLWithPath:soundBPath];
    
    
    NSString *soundCPath = [[NSBundle mainBundle] pathForResource:@"beep-03" ofType:@"wav"];
    NSURL *urlC = [NSURL fileURLWithPath:soundCPath];
    
    NSString *soundDPath = [[NSBundle mainBundle] pathForResource:@"beep-04" ofType:@"wav"];
    
    NSURL *urlD = [NSURL fileURLWithPath:soundDPath];
    
    
    NSString *longSongPath = [[NSBundle mainBundle] pathForResource:@"song" ofType:@"mp3"];
    
    NSURL *longSongURL = [NSURL fileURLWithPath:longSongPath];
    
    
    
    // Legacy C Code
    // __bridge == C - Level cast
    // Tells ARC stop taking note of the casted object
    // Casting -> Don't generate Meta Data
    // We are responsible for freeing the memory using the dealloc method
    
    
    // For Short Sound A
    
    OSStatus statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlA, &_beepA);
    
    if(statusReport == kAudioServicesNoError){
        self.beepAGood = YES;
    }
    
    else {
        self.beepAGood = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could Not load short Sound 1" message:@"Short Sound 1 Problem" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
         
    }
    
    
    // For Short Sound B
    
    statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlB, &_beepB);
    
    if(statusReport == kAudioServicesNoError){
        self.beepBGood = YES;
    }
    
    else {
        self.beepBGood = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could Not load short Sound 2" message:@"Short Sound 2 Problem" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

    // For Short Sound C
    
    statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlC, &_beepC);
    
    if(statusReport == kAudioServicesNoError){
        self.beepCGood = YES;
    }
    
    else {
        self.beepCGood = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could Not load short Sound 3" message:@"Short Sound 3 Problem" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
    // For Short Sound D
    
    statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlD, &_beepD);
    
    if(statusReport == kAudioServicesNoError){
        self.beepDGood = YES;
    }
    
    else {
        self.beepDGood = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could Not load short Sound 4" message:@"Short Sound 4 Problem" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    // Setup AV Audio Player
    
    NSError *err;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:longSongURL error:&err];
    
    if(!self.player) {
        
        self.longSongGood = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could Not load MP3 song" message:[err localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else {
        self.longSongGood = YES;
    }
    
}

- (IBAction)shortSound1Tapped:(id)sender {
    
    if(self.beepAGood){
        AudioServicesPlaySystemSound(self.beepA);
    }
}

- (IBAction)shortSound2Tapped:(id)sender {
    
    if(self.beepBGood){
        AudioServicesPlaySystemSound(self.beepB);
    }
}
- (IBAction)shortSound3Tapped:(id)sender {
    
    if(self.beepCGood){
        AudioServicesPlaySystemSound(self.beepC);
    }
}

- (IBAction)shortSound4Tapped:(id)sender {
    
    if(self.beepDGood){
        AudioServicesPlaySystemSound(self.beepD);
    }
}

- (IBAction)playLongSongTapped:(id)sender {
    
    if(self.longSongGood) {
        [self.player play];
        
    }
    
}
- (IBAction)stopLongSongTapped:(id)sender {
    
    if(self.longSongGood) {
        [self.player stop];
    }
}

-(void) dealloc {
    
    
    if(self.beepAGood){
        AudioServicesDisposeSystemSoundID(self.beepA);
    }
    
    if(self.beepBGood){
        AudioServicesDisposeSystemSoundID(self.beepB);
    }
    
    if(self.beepCGood){
        AudioServicesDisposeSystemSoundID(self.beepC);
    }
    
    if(self.beepDGood){
        AudioServicesDisposeSystemSoundID(self.beepD);
    }

}

@end
