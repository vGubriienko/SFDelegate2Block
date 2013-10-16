//
//  SFViewController.m
//
// Copyright (c) 2013 Viktor Gubriienko. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SFViewController.h"
#import "SFDelegate2Block.h"

@interface SFViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SFViewController {
    SFDelegate2Block *_alertD2B;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Step 1: Create Delegate2Block object with appropriate protocol
    _alertD2B = [SFDelegate2Block delegate2BlockWithProtocol:@protocol(UIAlertViewDelegate)];
    
    
    // Step 2: Add block which will handle appropriate selector from the protocol.
    // The block MUST have additional first argument of SEL type
    // Selector MUST be on of mentioned in the protocol
    __weak typeof(self) weakSelf = self;
    [_alertD2B setBlock:^(SEL selector, UIAlertView *sender, NSInteger clickedButtonIndex) {
        [weakSelf.button setTitle:@"It works!" forState:UIControlStateNormal];
    } forSelector:@selector(alertView:clickedButtonAtIndex:)];
    
}

- (IBAction)tapMe:(id)sender {
    
    // Step 3: set Delegate2Block object as delegate
    UIAlertView *alertView = [[UIAlertView new] initWithTitle:@"It works!"
                                                      message:nil
                                                     delegate:_alertD2B
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [alertView show];
    
}

@end
