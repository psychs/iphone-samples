#import <objc/runtime.h>
#import "PSWebView.h"

static const char* kUIWebDocumentView = "UIWebDocumentView";

@interface NSObject (UIWebViewTappingDelegate)
- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@interface PSWebView (Private)
- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@implementation UIView (__TapHook)

- (void)__touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	// dummy implementation
}

- (void)__myTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self __touchesEnded:touches withEvent:event];
	
	id webView = [[self superview] superview];
	if (touches.count > 1) {
		if ([webView respondsToSelector:@selector(fireZoomingEndedWithTouches:event:)]) {
			[webView fireZoomingEndedWithTouches:touches event:event];
		}
	}
	else {
		if ([webView respondsToSelector:@selector(fireTappedWithTouch:event:)]) {
			[webView fireTappedWithTouch:[touches anyObject] event:event];
		}
	}
}

@end

static BOOL hookInstalled = NO;

static void installHook(UIView* view)
{
	if (hookInstalled) return;
	
	hookInstalled = YES;
	
	Class klass = [view class];
	
	Method targetMethod = class_getInstanceMethod(klass, @selector(touchesEnded:withEvent:));
	Method aliasMethod = class_getInstanceMethod(klass, @selector(__touchesEnded:withEvent:));
	Method newMethod = class_getInstanceMethod(klass, @selector(__myTouchesEnded:withEvent:));
	
	method_setImplementation(aliasMethod, method_getImplementation(targetMethod));
	method_setImplementation(targetMethod, method_getImplementation(newMethod));
}

@implementation PSWebView

- (void)setUp
{
	NSArray* views = [[[self subviews] objectAtIndex:0] subviews];
	for (id view in views) {
		const char* name = object_getClassName(view);
		if (!strcmp(name, kUIWebDocumentView)) {
			installHook(view);
			break;
		}
	}
}

- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
		[self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		[self setUp];
    }
    return self;
}

- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:zoomingEndedWithTouches:event:)]) {
		[(NSObject*)self.delegate webView:self zoomingEndedWithTouches:touches event:event];
	}
}

- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:tappedWithTouch:event:)]) {
		[(NSObject*)self.delegate webView:self tappedWithTouch:touch event:event];
	}
}

@end
