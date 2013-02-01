//
//  AlertPrompt.m
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 28/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertPrompt.h"

static const float kTextFieldHeight     = 75.0;//25.0;
static const float kTextFieldWidth      = 260.0;//100.0;

@implementation AlertPrompt

@synthesize enteredText;
@synthesize textView;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        UITextView *textView1 = [[UITextView alloc] initWithFrame:CGRectMake(18.0, 45.0, 250.0, 80.0)]; 
        [textView1 setBackgroundColor:[UIColor whiteColor]]; 
        
        [self addSubview:textView1];
        self.textView = textView1;
        textView.delegate = self;
        [textView1 release];
                
    }
    return self;
}


- (BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (range.length > text.length) {
        return YES;
    }
    else if ([[textView1 text] length] + text.length > 140) {
        return NO;
    }
    
    return YES;
}

- (void)show
{
    [textView becomeFirstResponder];
    [super show];
}

- (NSString *)enteredText
{
    //return textField.text;
    return textView.text;
}

- (void)dealloc
{
    //[textField release];
    [textView release];
    [super dealloc];
}

@end
