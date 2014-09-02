//
//  TestViewController1.m
//  ANESampleiOS
//
//  Created by Kaoru Kawashima on 11/6/13.
//  Copyright (c) 2013 Kaoru Kawashima. All rights reserved.
//

#import "ViewControllerProgrammatic.h"

@interface ViewControllerProgrammatic ()

@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewControllerProgrammatic

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textfield = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 100.0f, 300.0f, 30.0f)];
    self.textfield.borderStyle = UITextBorderStyleRoundedRect;
    self.textfield.delegate = self;
    [self.view addSubview:self.textfield];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //pressMeButton = button;
    button.frame = CGRectMake(110.0f, 200.0f, 100.0f, 30.0f);
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Press Me!" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 150.0f, 200.0f, 30.0f)];
    self.label.text = @"Hello World!";
    [self.view addSubview:self.label];
    
    // navigation bar
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Hello!" style:UIBarButtonItemStyleBordered target:self action:@selector(doSomething)];
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.leftBarButtonItem = barButton;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"My View";
    self.navigationItem.backBarButtonItem = barBackButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed
{
    
    self.label.text = self.textfield.text;
    
}

-(void)doSomething
{
    
    NSLog(@"close now");
    //self.label.text = @"Hello tapped";
    
    if (self.navigationController) {
        
        [self.navigationController.view removeFromSuperview];
        
    } else {
        
        NSLog(@"controller nil");
        [self.view removeFromSuperview];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    //this tells the operating system to remove the keyboard from the forefront
    [textField resignFirstResponder];
    
    // returns NO. instead of adding a line break, the textfield resigns
    return NO;
    
}

@end
