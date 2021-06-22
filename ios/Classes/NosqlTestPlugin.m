#import "NosqlTestPlugin.h"
#if __has_include(<nosql_test/nosql_test-Swift.h>)
#import <nosql_test/nosql_test-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "nosql_test-Swift.h"
#endif

@implementation NosqlTestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNosqlTestPlugin registerWithRegistrar:registrar];
}
@end
