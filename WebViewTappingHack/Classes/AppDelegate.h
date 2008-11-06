#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow* window;
	RootViewController* viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet RootViewController* viewController;

@end

