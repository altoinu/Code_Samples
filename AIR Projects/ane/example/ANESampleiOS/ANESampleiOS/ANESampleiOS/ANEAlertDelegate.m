//
//  ANEAlertDelegate.m
//  ANESampleiOS
//
//  Created by Kaoru Kawashima on 11/6/13.
//  Copyright (c) 2013 Kaoru Kawashima. All rights reserved.
//

#import "ANEAlertDelegate.h"

@implementation ANEAlertDelegate

@synthesize context = _context;

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString* code;
    NSString* level;
    
    if (buttonIndex == 0) {
        
        NSLog(@"%@", @"OK clicked");
        code = @"okClicked";
        level = @"okLevel";
        
    } else {
        
        NSLog(@"%@", @"CANCEL clicked");
        code = @"cancelClicked";
        level = @"cancelLevel";
        
    }
    
    FREDispatchStatusEventAsync(_context, (const uint8_t*) [code UTF8String], (const uint8_t*) [level UTF8String]);
    
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}

-(void) alertViewCancel:(UIAlertView *)alertView {
    
}

@end
