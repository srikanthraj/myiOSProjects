//
//  ViewController.m
//  NavigationControllerPrac
//
//  Created by admin on 2016-10-04.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
#import "UIKit/UIKit.h"
#import "RecipeDetailViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *recipieTextField;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
       
        RecipeDetailViewController *destViewController = segue.destinationViewController;
        destViewController.recipeName = self.recipieTextField.text;
    }
}


@end
