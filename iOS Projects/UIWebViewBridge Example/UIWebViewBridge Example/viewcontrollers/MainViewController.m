//
//  MainViewController.m
//  UIWebViewBridge Example
//
//  Created by Kaoru Kawashima on 3/17/14.
//  Copyright (c) 2014 Kaoru Kawashima. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this file,
//  You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "MainViewController.h"
#import "UIWebViewBridge.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIWebViewBridge *webView;
@property (weak, nonatomic) IBOutlet UILabel *textFromJS;
- (IBAction)triggerJavaScript:(id)sender;
- (IBAction)triggerJSAndCallbackOnClick:(id)sender;

@end

@implementation MainViewController

@synthesize webView = _webView;
@synthesize textFromJS = _textFromJS;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"MainViewController viewDidLoad");
    
    _webView.callbackDelegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)triggerJavaScript:(id)sender
{
    
    [_webView execJavaScript:@"sayHello" arguments:[[NSArray alloc] initWithObjects:@"Hello world", @"I like curry rice", nil]];
    
    [_webView execJavaScript:@"sayHello" arguments:[[NSArray alloc] initWithObjects:@"Good morning world", @"I like katsu curry rice", nil]];
    
}

- (IBAction)triggerJSAndCallbackOnClick:(id)sender
{
    
    [_webView execJavaScript:@"giveMeData" arguments:[[NSArray alloc] initWithObjects:@(3), @"Blah", nil] callback:@selector(processReturnedData:returnValue2:)];
    [_webView execJavaScript:@"giveMeData" arguments:[[NSArray alloc] initWithObjects:@(5), @"Hello world...", nil] callback:@selector(processReturnedData:returnValue2:)];
    
}

- (void)awesomeFunction:(NSString *)text1 text2:(NSString *)text2
{
    
    NSLog(@"I got something from HTML: %@ %@", text1, text2);
    _textFromJS.text = [NSString stringWithFormat:@"%@ %@", text1, text2];
    
}

- (void)processReturnedData:(NSNumber *)returnValue1 returnValue2:(NSString *)returnValue2
{
    
    NSLog(@"processReturnedData: %@ --- %@", returnValue1, returnValue2);
    _textFromJS.text = [NSString stringWithFormat:@"%@ %@", returnValue1, returnValue2];
    
}

@end
