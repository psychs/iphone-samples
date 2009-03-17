// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import "MapAppDelegate.h"
#import "MapViewController.h"

@implementation MapAppDelegate

@synthesize window;
@synthesize viewController;

- (void)dealloc
{
	[viewController release];
	[window release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
}

@end
