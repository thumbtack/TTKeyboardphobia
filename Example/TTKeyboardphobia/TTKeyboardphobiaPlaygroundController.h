@interface TTKeyboardphobiaPlaygroundController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *unobscuredAreaView;
@property (weak, nonatomic) IBOutlet UIView *responderWithinContainer;
@property (weak, nonatomic) IBOutlet UITextField *responderWithoutContainer;
@property (weak, nonatomic) IBOutlet UITextView *oversizedResponder;
@property (weak, nonatomic) IBOutlet UIView *oversizedContainer;
@property (weak, nonatomic) IBOutlet UITextView *oversizedResponderWithAccessoryView;
@property (weak, nonatomic) IBOutlet UIView *oversizedContainerWithAccessoryView;
@property (strong, nonatomic) IBOutlet UIView *scrollViewContent;
@property (weak, nonatomic) IBOutlet UITextField *responderWithAccessoryView;
@property (weak, nonatomic) IBOutlet UIView *responderWithAccessoryViewContainer;
@property (weak, nonatomic) IBOutlet UITextField *responderWithAccessoryView2;
@property (weak, nonatomic) IBOutlet UIView *responderWithAccessoryViewContainer2;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UIView *accessoryViewArea;

@end
