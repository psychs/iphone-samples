// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the new BSD license.

#import <UIKit/UIKit.h>

@class MapViewController;

@interface MapAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow* window;
	MapViewController* viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet MapViewController* viewController;

@end

