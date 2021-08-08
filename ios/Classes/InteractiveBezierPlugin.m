#import "InteractiveBezierPlugin.h"
#if __has_include(<interactive_bezier/interactive_bezier-Swift.h>)
#import <interactive_bezier/interactive_bezier-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "interactive_bezier-Swift.h"
#endif

@implementation InteractiveBezierPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInteractiveBezierPlugin registerWithRegistrar:registrar];
}
@end
