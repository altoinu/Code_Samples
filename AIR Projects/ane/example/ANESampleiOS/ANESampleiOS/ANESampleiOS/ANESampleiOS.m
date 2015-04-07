//
//  ANESampleiOS.m
//  ANESampleiOS
//
//  Created by Kaoru Kawashima on 10/7/13.
//  Copyright (c) 2013 Kaoru Kawashima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANEAlertDelegate.h"
#import "ViewControllerProgrammatic.h"
#import "FlashRuntimeExtensions.h"

ViewControllerProgrammatic *customView;
UINavigationController *customViewNav;
UIWindow *customWindow;

ANEAlertDelegate *alertDelegate;

FREObject showAlertMessage(FREContext context, void* funcData, uint32_t argc, FREObject argv[]) {
    // argc ... argument count, uint
    // argv ... argument values, Array
    
    // AS3 Number to Obj C double
    //double number1;
    //FREGetObjectAsDouble(argv[0], &number);
    //FREObject returnValue = nil;
    //FRENewObjectFromDouble(number1, &returnValue);
    
    // AS3 int to Obj C int32_t
    //int32_t int1;
    //FREGetObjectAsInt32(argv[0], &int1);
    //FREObject returnValue = nil;
    //FRENewObjectFromInt32(int1, &returnValue);
    
    // AS3 uint to Obj C uint32_t
    //uint32_t uint1;
    //FREGetObjectAsUint32(argv[0], &uint1);
    //FREObject returnValue = nil;
    //FRENewObjectFromUint32(uint1, &returnValue);
    
    // AS3 String to Obj C NSString
    //uint32_t string1Length;
    //const uint8_t *string1;
    //FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
    //NSString *string1ObjC = [NSString stringWithUTF8String:(char*)string1];
    //const char *str = [string1ObjC UTF8String];
    //FREObject returnValue;
    //FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &returnValue);
    
    // AS3 Boolean to Obj C Boolean
    //uint32_t boolean;
    //FREGetObjectAsBool(argv[0], &boolean);
    //if (boolean)...
    //FREObject returnValue = nil;
    //FRENewObjectFromBool(boolean, &returnValue);
    
    // Event to AIR
    //NSString *eventCodeStr = @"event code";
    //NSString *eventLevelStr = @"event level";
    //const uint8_t* eventCode = (const uint8_t*) [eventCodeStr UTF8String];
    //const uint8_t* eventLevel = (const uint8_t*) [eventLevelStr UTF8String];
    //FREDispatchStatusEventAsync(context, eventCode, eventLevel);
    
    //NSString *testString = @"Hello, world!";
    //NSString *upperString = [testString uppercaseString];
    
    // Argument passed from AIR will be available under argv
    // convert to data Obj C can use
    uint32_t messageLength;
    const uint8_t* messageString;
    FREGetObjectAsUTF8(argv[0], &messageLength, &messageString);
    NSString *message = [NSString stringWithUTF8String:(char*)messageString];
    
    NSLog(@"%@", @"===Message received by ANESampleiOS.showAlertMessage: ");
    NSLog(@"%@", message);
    
    alertDelegate.context = context;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert via ANE" message: message delegate:alertDelegate cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
    
    [alert show];
    
    // Return value to AIR
    // Convert Obj C data to object AIR can use
    NSString* returnMessage = @"Hello back from ANESampleiOS.ANETestExtension.showAlertMessage!";
    const char* returnString = [returnMessage UTF8String];
    //const unsigned long returnStringLength = strlen(returnString) + 1;
    FREObject returnObj = NULL;
    //FRENewObjectFromUTF8(uint32_t length, const uint8_t *value, FREObject *object)
    FRENewObjectFromUTF8(strlen(returnString) + 1, (const uint8_t*)returnString, &returnObj);
    
    return returnObj;
    
}

FREObject showNativeView(FREContext context, void* funcData, uint32_t argc, FREObject argv[]) {
    
    //[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController].view;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [delegate window];
    
    // actual view
    ViewControllerProgrammatic *view = [[ViewControllerProgrammatic alloc] init];
    customView = view; // need to remember reference
    
    // navigation controller
    UINavigationController *nav = [[UINavigationController alloc] init];
    customViewNav = nav; // need to remember reference
    [customViewNav pushViewController:view animated:NO];
    
    // display it now
    
    // Add view to existing UIWindow. Displays on top of AIR layer
    NSLog(@"showNativeView delegate window");
    //[window addSubview:customView.view]; // just view, no navigation controller
    [window addSubview:customViewNav.view]; // with navigation controller
    //[window.rootViewController.navigationController pushViewController:customView animated:NO]; // doesn't work...?
    
    /*
    // Add new window and view in it
    NSLog(@"showNativeView custom window!!");
    UIWindow *extraWindow = [[UIWindow alloc] init];
    customWindow = extraWindow;
    [customWindow setWindowLevel:UIWindowLevelAlert];
    [customWindow addSubview:customViewNav.view];
    [customWindow makeKeyAndVisible];
    */
    
    NSLog(@"Done showNativeView!");
    return NULL;
    
}

void ANETestExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext context, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    // Number of native functions to make available to AIR
    *numFunctionsToTest = 2;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*) "showAlertMessage";
    func[0].functionData = NULL;
    func[0].function = &showAlertMessage;
    
    func[1].name = (const uint8_t*) "showNativeView";
    func[1].functionData = NULL;
    func[1].function = &showNativeView;
    
    *functionsToSet = func;
    
}

void ANETestExtensionContextFinalizer(FREContext context) {
    
    return;
    
}

// Extension initializer
void ANETestExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    
    *extDataToSet = NULL;
    
    // Set references to initializer and finalizer
    *ctxInitializerToSet = &ANETestExtensionContextInitializer;
    *ctxFinalizerToSet = &ANETestExtensionContextFinalizer;
    
    // other initializations
    if (alertDelegate == nil) {
        
        alertDelegate = [[ANEAlertDelegate alloc] init];
        //alertDelegate = [ANESampleiOSAlertDelegate new];
        
    }
    
}

// Extension finalizer
void ANETestExtensionFinalizer(void* extData) {
    
    return;
    
}
