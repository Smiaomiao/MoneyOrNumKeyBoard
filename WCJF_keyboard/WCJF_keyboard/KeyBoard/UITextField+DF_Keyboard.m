//
//  UITextField+DF_Keyboard.m
//  WCJF_keyboard
//
//  Created by 杜菲 on 2017/1/3.
//  Copyright © 2017年 杜菲. All rights reserved.
//

#import "UITextField+DF_Keyboard.h"
#import "DF_Keyboard.h"

@implementation UITextField (DF_Keyboard)

- (void)setKeyBoardStyle:(NSInteger)KeyBoardStyle
{
    if(KeyBoardStyle == TextFiledKeyBoardStyleMoney)
    {
        DF_Keyboard *zpNumberKb = [[DF_Keyboard alloc] init];
        [zpNumberKb initCustomKeyboradType:YES];
        zpNumberKb.textFiled = self;
        self.inputView = zpNumberKb;
    }else if(KeyBoardStyle == TextFiledKeyBoardStyleNumber){
        self.keyboardType = UIKeyboardTypeNumberPad;
    }else if (KeyBoardStyle == TextFiledKeyBoardStyleCer) {
        DF_Keyboard *zpNumberKb = [[DF_Keyboard alloc] init];
        [zpNumberKb initCustomKeyboradType:NO];
        zpNumberKb.textFiled = self;
        self.inputView = zpNumberKb;
    }
}

- (NSInteger)KeyBoardStyle
{
    return 0;
}


@end
