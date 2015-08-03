#import "TTSnapshotTestHelper.h"

@implementation TTSnapshotTestHelper

+ (NSString *)deviceIdentifier {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"iOS_%@_%.1fx%.1f", version, screenRect.size.width, screenRect.size.height];
}

@end
