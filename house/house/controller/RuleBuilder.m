//
//  RuleBuilder.m
//  Tabby
//
//  Created by Michael Arbuckle on 11/22/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "RuleBuilder.h"
@interface RuleBuilder()
@property (nonatomic, strong) NSLayoutConstraint *keyboardHC;
@end
@implementation RuleBuilder


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
       [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)note
{
    [self updateViewConstraintsAnimated:note];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [self updateViewConstraintsAnimated:note];
}
- (void)updateViewConstraintsAnimated:(NSNotification *)note
{
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat curve = [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    CGRect endFrame = CGRectZero;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    
    CGFloat minY = CGRectGetMinY(endFrame);
    CGFloat keyboardHeight = endFrame.size.height;
    
    // Invert values when landscape, for iOS7 or prior
    // In iOS8, Apple finally fixed the keyboard endframe values by returning the correct height in landscape orientation
    if (![UIInputViewController class] && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        keyboardHeight = endFrame.size.width;
    }
    
    if (keyboardHeight == CGRectGetHeight([UIScreen mainScreen].bounds)) keyboardHeight = 0;
    
    self.keyboardHC.constant = (minY == [UIScreen mainScreen].bounds.size.height) ? 0.0 : keyboardHeight;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:NULL];
}
@end
/*



NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This is an example by @marcelofabri_"];
[attributedString addAttribute:NSLinkAttributeName
                         value:@"username://marcelofabri_"
                         range:[[attributedString string] rangeOfString:@"@marcelofabri_"]];


NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor greenColor],
                                 NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                 NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};

// assume that textView is a UITextView previously created (either by code or Interface Builder)
textView.linkTextAttributes = linkAttributes; // customizes the appearance of links
textView.attributedText = attributedString;
textView.delegate = self;


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"username"]) {
        NSString *username = [URL host];
        // do something with this username
        // ...
        return NO;
    }
    return YES; // let the system open this URL
}

*/
