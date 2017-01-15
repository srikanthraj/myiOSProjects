//
//  AppDelegate.m
//  GeoFenceCouponsAssignment
//
//  Created by admin on 2016-12-21.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    application.applicationIconBadgeNumber = 0;
    
    UILocalNotification *localNotif = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    
    if(localNotif){
        
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Exclusive Offer!" message: @"Shop today at ABC and get Get 30% Off - Coupon Code GHJDUFGF" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *aa = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [ac addAction:aa];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [application.keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
    });
    }
    
    return YES;
}

// Received Notification in all states except "Not Running"

- (void) application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    
    application.applicationIconBadgeNumber = 0;
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Exclusive Offer!" message: @"Shop today at ABC and get Get 30% Off - Coupon Code GHJDUFGF" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *aa = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [ac addAction:aa];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [application.keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
    });
    
    
}


@end
