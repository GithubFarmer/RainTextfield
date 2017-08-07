//
//  RainTextField.h
//  OC_WC_Demo
//
//  Created by 喻永权 on 2017/8/3.
//  Copyright © 2017年 喻永权. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RainTextFieldKeyBoard) {
    RainTextFieldKeyBoardDefault,
    RainTextFieldKeyBoardwithX,
    RainTextFieldKeyBoardwithPoint
};

@interface RainTextField : UITextField

/**
 数字键盘默认为纯数字键盘，textFieldKeyBoard 为 RainTextFieldKeyBoardDefault
 */
@property (nonatomic, assign) RainTextFieldKeyBoard textFieldKeyBoard;

@end
