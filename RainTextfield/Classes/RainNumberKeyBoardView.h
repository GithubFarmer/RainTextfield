//
//  RainNumberKeyBoardView.h
//  OC_WC_Demo
//
//  Created by 喻永权 on 2017/8/3.
//  Copyright © 2017年 喻永权. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RainNumberKeyBoardView;

typedef NS_ENUM(NSInteger, RainNumberKeyBoard) {
    RainNumberKeyBoardDefault,
    RainNumberKeyBoardwithX,
    RainNumberKeyBoardwithPoint
};

@protocol RainNumberKeyBoardDelegate <NSObject>

- (void)rainNumberKeyBoardView:(RainNumberKeyBoardView *)boardView didSelectItem:(UIButton *)item;

- (void)rainNumberKeyBoardView:(RainNumberKeyBoardView *)boardView didSelectSureItem:(UIButton *)item;

- (BOOL)rainNumberKeyBoardView:(RainNumberKeyBoardView *)boardView didSelectDeleteItem:(UIButton *)item;

@end

@interface RainNumberKeyBoardView : UIView

@property (nonatomic, assign) RainNumberKeyBoard boardType;

@property (nonatomic, weak) id <RainNumberKeyBoardDelegate> delegate;

@property (nonatomic, assign) BOOL sureBtnEnable;

- (id)initWithFrame:(CGRect)frame keyBoardStyle:(RainNumberKeyBoard) type;
//- (void)stopDelete:(UIButton *)button;

@end
