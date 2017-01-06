//
//  ViewController.m
//  TestTextField
//
//  Created by admin on 2016-11-17.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
#import "AJWValidator.h"
@interface ViewController () <UITextFieldDelegate, AJWValidatorDelegate>

@property (strong, nonatomic) AJWValidator *validator;
@property (copy, nonatomic) NSString *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *errorsTextView;
@end

// AJWValidator *validator;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.textField.delegate = self;
    self.errorsTextView.text = NSLocalizedString(@"No errors 😐 ", nil);
    [self.textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    
   
    //[self.textField ajw_attachValidator:self.validator];
    
}


- (void)textFieldTextChanged:(UITextField *)sender

{

    NSLog(@"Changed");
    if([self validateEmailWithString:sender.text]){
        UIColor *validGreen = [UIColor colorWithRed:0.27 green:0.63 blue:0.27 alpha:1];
        self.textField.backgroundColor = [validGreen colorWithAlphaComponent:0.3];
        self.errorsTextView.text = NSLocalizedString(@"No errors 😃", nil);
        self.errorsTextView.textColor = validGreen;

    }
    
    else {
        UIColor *invalidRed = [UIColor colorWithRed:0.89 green:0.18 blue:0.16 alpha:1];
        self.textField.backgroundColor = [invalidRed colorWithAlphaComponent:0.3];
        self.errorsTextView.text = NSLocalizedString(@"errors  😧", nil);
        self.errorsTextView.textColor = invalidRed;
    }
    
       }



    - (BOOL)validateEmailWithString:(NSString*)checkString
    {
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
    }
    



@end
