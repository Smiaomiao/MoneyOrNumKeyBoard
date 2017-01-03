//
//  DF_Keyboard.m
//  WCJF_keyboard
//
//  Created by 杜菲 on 2017/1/3.
//  Copyright © 2017年 杜菲. All rights reserved.
//

#import "DF_Keyboard.h"

#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height
#define keyBoardHeight 50.0 //数字键的高度
#define maxLength  100000//限制最大长度

#define BackColor RGB(242, 242, 242)//蒙版颜色
#define LayerColor RGB(207, 207, 207)//边框颜色
#define KeyBoardBtnBackColor RGB(208, 208, 208)//键盘按钮背景色
#define SureBtnBackColor RGB(254, 194, 90)//确定按钮背景色
#define SureBtnBackImgColor RGB(228, 174, 81)//确定按钮背景图片颜色
#define BtnTitleColor RGB(51, 51, 51)//键盘按钮字体颜色
#define LayerBordWidth 0.5f//键盘边框宽度
#define KeyBoardNumFont 22//键盘字体大小

@implementation DF_Keyboard {

    NSTimer *timer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = BackColor;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, keyBoardHeight *4);
        [self initCustomKeyborad];
    }
    return self;
}


- (void)initCustomKeyborad
{
    for (int x = 0; x < 12; x++)
    {
        UIButton *keyBoard_numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyBoard_numBtn setFrame:CGRectMake( x%3*(KScreenWidth / 4),  x/3*keyBoardHeight , KScreenWidth / 4, keyBoardHeight)];
        
        NSInteger tag = 0;
        NSString *title = nil;
        UIImage *img = nil;
        
        if (x <= 9){
            //数字1~9
            tag = x+1;
            title = [NSString stringWithFormat:@"%ld",tag];
            if (x==9) {
                //小数点
                title = @".";
            }
        }else if (x == 11){
            //收起键盘
            tag = x;
            img = [UIImage imageNamed:@"resign"];
        }else if (x == 10){
            //数字0
            tag = 0;
            title = [NSString stringWithFormat:@"%ld",tag];
        }
        
        [UIButton buttonWithType:UIButtonTypeCustom];
        [self initButton:keyBoard_numBtn withFrame:CGRectMake( x%3*(KScreenWidth / 4),  x/3*keyBoardHeight , KScreenWidth / 4, keyBoardHeight) backgroundColor:[UIColor clearColor] image:img backgroundImageOfColor:KeyBoardBtnBackColor font:KeyBoardNumFont title:title tag:tag];

        keyBoard_numBtn.adjustsImageWhenHighlighted = YES;
        [keyBoard_numBtn addTarget:self action:@selector(keyboardViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyBoard_numBtn];
    }
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self initButton:deleteBtn withFrame:CGRectMake(3*KScreenWidth/4, 0, KScreenWidth/4, keyBoardHeight*2) backgroundColor:[UIColor clearColor] image:[UIImage imageNamed:@"delete"] backgroundImageOfColor:KeyBoardBtnBackColor font:0 title:@"" tag:12];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressDelete:)];
    [deleteBtn addGestureRecognizer:longPress];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self initButton:sureBtn withFrame:CGRectMake(3*KScreenWidth/4, keyBoardHeight*2, KScreenWidth/4, keyBoardHeight*2) backgroundColor:SureBtnBackColor image:[UIImage imageNamed:@""] backgroundImageOfColor:SureBtnBackImgColor font:KeyBoardNumFont title:@"确定" tag:13];
}

- (void)initButton:(UIButton *)btn withFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image backgroundImageOfColor:(UIColor *)backgroundImageColor font:(NSInteger)font title:(NSString *)title tag:(NSInteger)tag
{
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:backgroundColor];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:backgroundImageColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:BtnTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(keyboardViewAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    btn.layer.borderWidth = LayerBordWidth;
    btn.layer.borderColor = LayerColor.CGColor;
    [self addSubview:btn];
}

- (void)keyboardViewAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    switch (tag)
    {
        case 10:
        {
            // 小数点
            if(self.textFiled.text.length > 0 && [self.textFiled.text rangeOfString:@"." options:NSCaseInsensitiveSearch].location == NSNotFound && self.textFiled.text.length < maxLength) {
                
                if ([self.textFiled hasText]) {
                    [self.textFiled insertText:@"."];
                } else {
                    self.textFiled.text = [NSString stringWithFormat:@"%@.",self.textFiled.text];
                }
            }
            
        }
            break;
        case 11:
        {
            // 消失
            [self.textFiled resignFirstResponder];
            
        }
            break;
        case 12:
        {
            // 删除
            if(self.textFiled.text.length > 0)
                [self.textFiled deleteBackward];
        }
            break;
        case 13:
        {
            // 确认
            [self.textFiled resignFirstResponder];
        }
            break;
        default:
        {
            // 数字
            if ([self.textFiled hasText]) {
                [self.textFiled insertText:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            } else {
                self.textFiled.text = [NSString stringWithFormat:@"%@%ld",self.textFiled.text,sender.tag];
            }
            
            if (self.textFiled.text.length >= 2) {
                NSString *str = [self.textFiled.text substringToIndex:2];
                if ([[str substringToIndex:1] isEqualToString:@"0"] && ![[str substringFromIndex:1] isEqualToString:@"."]) {
                    self.textFiled.text = [self.textFiled.text substringFromIndex:1];
                }
            }
            
            if (self.textFiled.text.length > maxLength) {
                self.textFiled.text = [self.textFiled.text substringToIndex:maxLength];
            }
            
            
        }
            break;
    }
}

- (void)longPressDelete:(UILongPressGestureRecognizer *)longPress{
    UIButton *btn = (UIButton *)longPress.view;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        [btn setBackgroundImage:[self createImageWithColor:KeyBoardBtnBackColor] forState:UIControlStateNormal];
    } else if (longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed || longPress.state == UIGestureRecognizerStateEnded) {
        [timer invalidate];
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        timer = nil;
    }
    
    
}

- (void)runTimePage{
    
    [self.textFiled deleteBackward];
    
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
