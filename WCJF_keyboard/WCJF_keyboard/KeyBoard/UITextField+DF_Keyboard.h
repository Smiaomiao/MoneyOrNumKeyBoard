//
//  UITextField+DF_Keyboard.h
//  WCJF_keyboard
//
//  Created by 杜菲 on 2017/1/3.
//  Copyright © 2017年 杜菲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KeyBoardStyle) {
    TextFiledKeyBoardStyleMoney,
    TextFiledKeyBoardStyleNumber,
    TextFiledKeyBoardStyleCer,
};

@interface UITextField (DF_Keyboard)

@property(nonatomic,assign)NSInteger KeyBoardStyle;

@end
