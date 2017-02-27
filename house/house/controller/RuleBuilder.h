#import <UIKit/UIKit.h>
#import "Rule.h"
@interface RuleBuilder : UIViewController

@property (atomic, strong) Rule* rule;
@property (nonatomic, readonly) UITextField *title;
@property (nonatomic, readonly) UITextView *whenView;
@property (nonatomic, readonly) UITextView *thenView;

@end
