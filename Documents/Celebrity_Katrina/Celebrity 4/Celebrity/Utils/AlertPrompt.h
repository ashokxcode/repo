//
//  AlertPrompt.h
//  Celebrity
//
//  Created by JayaPrathap Audikesavalu on 28/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertPrompt : UIAlertView <UITextViewDelegate>
{
    UITextView *textView;
}
@property (readonly) NSString *enteredText;
@property (nonatomic, retain) UITextView *textView;


- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end
