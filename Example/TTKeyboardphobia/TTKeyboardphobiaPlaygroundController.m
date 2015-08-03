#import "TTKeyboardphobiaPlaygroundController.h"
#import "TTKeyboardphobia.h"

@interface TTKeyboardphobiaPlaygroundController ()
@property (nonatomic, strong) TTKeyboardphobia *keyboardphobia;

@end

@implementation TTKeyboardphobiaPlaygroundController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.accessibilityLabel = @"TTKeyboardphobiaPlaygroundView";
    self.scrollView.accessibilityIdentifier = @"TTKeyboardphobiaPlaygroundScrollView";

    self.responderWithAccessoryView.inputAccessoryView = self.accessoryView;
    self.responderWithAccessoryView2.inputAccessoryView = self.accessoryView;
    self.oversizedResponderWithAccessoryView.inputAccessoryView = self.accessoryView;

    self.keyboardphobia = [[TTKeyboardphobia alloc] init];

    [self.scrollView addSubview:self.scrollViewContent];

    for (UIView *view in @[self.oversizedResponder, self.oversizedResponderWithAccessoryView]) {
        [view.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.4] CGColor]];
        [view.layer setBorderWidth:.5f];
        [view.layer setCornerRadius:8.0f];
        [view.layer setMasksToBounds:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.keyboardphobia registerView:self.responderWithinContainer inScrollView:self.scrollView];
    [self.keyboardphobia registerView:self.responderWithoutContainer inScrollView:self.scrollView];
    [self.keyboardphobia registerView:self.oversizedContainer inScrollView:self.scrollView];
    [self.keyboardphobia registerView:self.oversizedContainerWithAccessoryView inScrollView:self.scrollView];
    [self.keyboardphobia registerView:self.responderWithAccessoryViewContainer inScrollView:self.scrollView];
    [self.keyboardphobia registerView:self.responderWithAccessoryViewContainer2 inScrollView:self.scrollView];

    UITapGestureRecognizer *hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:hideGesture];
    self.keyboardphobia.hideKeyboardTap = hideGesture;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.keyboardphobia unregisterViews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.scrollViewContent.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollViewContent.frame));
    self.scrollView.contentSize = self.scrollViewContent.frame.size;
}


#pragma mark - IBActions

- (IBAction)dismissKeyboard:(id)sender {
    [self hideKeyboard];
}


#pragma mark - Private

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

@end
