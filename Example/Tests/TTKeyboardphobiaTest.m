#import <KIF/KIF.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

#import "TTKeyboardphobia.h"
#import "TTKeyboardphobiaPlaygroundController.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "TTSnapshotTestHelper.h"
#import "TTAppDelegate.h"

@interface TTKeyboardphobiaTest : FBSnapshotTestCase
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *accessoryViewArea;

@end

@implementation TTKeyboardphobiaTest

- (void)setUp {
    [super setUp];

    // Hide cursor so that it doesn't appear in the snapshot.
    [[UITextField appearance] setTintColor:[UIColor clearColor]];
    [[UITextView appearance] setTintColor:[UIColor clearColor]];

    self.view = [tester waitForViewWithAccessibilityLabel:@"TTKeyboardphobiaPlaygroundView"];

    if (!self.accessoryViewArea) {
        self.accessoryViewArea = [tester waitForViewWithAccessibilityLabel:@"accessoryViewArea"];
    }

    self.accessoryViewArea.hidden = YES;
    self.recordMode = NO;
}

- (void)tearDown {
    // Make the tests easier to watch.
    [tester waitForTimeInterval:1];

    TTAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIViewController *rootController = appDelegate.window.rootViewController;
    [[rootController presentedViewController] dismissViewControllerAnimated:NO completion:nil];

    [super tearDown];
}

- (void)testResponderWithoutContainer {
    [tester tapViewWithAccessibilityLabel:@"responderWithoutContainer"];
    [tester waitForKeyInputReady];
    FBSnapshotVerifyView(self.view, [TTSnapshotTestHelper deviceIdentifier]);
}

- (void)testResponderWithinContainer {
    [tester tapViewWithAccessibilityLabel:@"responderWithinContainer"];
    [tester waitForKeyInputReady];
    FBSnapshotVerifyView(self.view, [TTSnapshotTestHelper deviceIdentifier]);
}

- (void)testResponderWithAccessoryView {
    self.accessoryViewArea.hidden = NO;
    [tester tapViewWithAccessibilityLabel:@"responderWithAccessoryView"];
    [tester waitForKeyInputReady];
    FBSnapshotVerifyView(self.view, [TTSnapshotTestHelper deviceIdentifier]);
}

- (void)testOversizedResponder {
    [tester tapViewWithAccessibilityLabel:@"oversizedResponder"];
    [tester waitForKeyInputReady];
    FBSnapshotVerifyView(self.view, [TTSnapshotTestHelper deviceIdentifier]);
}

- (void)testOversizedResponderWithAccessoryView {
    self.accessoryViewArea.hidden = NO;
    [self scrollToViewWithAccessibilityLabel:@"oversizedResponderWithAccessoryView" inScrollViewWithAccessibilityIdentifier:@"TTKeyboardphobiaPlaygroundScrollView"];
    [tester tapViewWithAccessibilityLabel:@"oversizedResponderWithAccessoryView"];
    [tester waitForKeyInputReady];
    FBSnapshotVerifyView(self.view, [TTSnapshotTestHelper deviceIdentifier]);
}

- (void)testResponderWithAccessoryViewKeyboardAndAccessoryViewAlreadyVisible {
    self.accessoryViewArea.hidden = NO;
    [tester tapViewWithAccessibilityLabel:@"responderWithAccessoryView"];
    [tester waitForKeyInputReady];

    [self scrollToViewWithAccessibilityLabel:@"responderWithAccessoryView2" inScrollViewWithAccessibilityIdentifier:@"TTKeyboardphobiaPlaygroundScrollView"];
    [tester tapViewWithAccessibilityLabel:@"responderWithAccessoryView2"];
    [tester waitForKeyInputReady];

    FBSnapshotVerifyView(self.view, [TTSnapshotTestHelper deviceIdentifier]);
}


#pragma mark - Private

- (void)scrollToViewWithAccessibilityLabel:(NSString *)label inScrollViewWithAccessibilityIdentifier:(NSString *)srollViewLabel {
    [tester runBlock:^KIFTestStepResult(NSError **error) {
        UIView *view = nil;
        [UIAccessibilityElement accessibilityElement:nil view:&view withLabel:label value:nil traits:UIAccessibilityTraitNone tappable:NO error:error];

        if (view) {
            return KIFTestStepResultSuccess;
        }

        [tester scrollViewWithAccessibilityIdentifier:srollViewLabel byFractionOfSizeHorizontal:0 vertical:-0.1];
        return KIFTestStepResultWait;
    } timeout:10.0];
}

@end
