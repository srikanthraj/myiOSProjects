//
//  ViewController.m
//  KeyboardDemo
//
//  Created by admin on 2016-10-05.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Notify us when the keyboard is about to appear - Register ourselves i.e self to listen to the event
    NSNotificationCenter *ctr = [NSNotificationCenter defaultCenter];
    [ctr addObserver:self selector:@selector(moveKeyboardInResponseToWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    
    
    [ctr addObserver:self selector:@selector(moveKeyboardInResponseToWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

//De register for Notifications when we are done - when the View controller is dealloc in its life cycle

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resignTapped:(id)sender {
    
    [self.textField resignFirstResponder];
}


-(void)moveKeyboardInResponseToWillShowNotification :(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    CGRect kbRect;
    kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue];
    
    [self.view layoutSubviews];
    
    //Animate!
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.bottomConstraint.constant = kbRect.size.height;
    [self.view layoutSubviews];
    [UIView commitAnimations];
 
    
}



-(void)moveKeyboardInResponseToWillHideNotification :(NSNotification *) notification
{
    
    NSDictionary *info = [notification userInfo];
    CGRect kbRect;
    
    kbRect = CGRectZero;
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue];
    
    [self.view layoutSubviews];
    
    //Animate!
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.bottomConstraint.constant = kbRect.size.height;
    [self.view layoutSubviews];
    [UIView commitAnimations];

    
    
}
@end
