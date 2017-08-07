//
//  RainNumberKeyBoardView.m
//  OC_WC_Demo
//
//  Created by 喻永权 on 2017/8/3.
//  Copyright © 2017年 喻永权. All rights reserved.
//

#import "RainNumberKeyBoardView.h"

static NSInteger const RainDeleteItemTag = 13;
static NSInteger const RainSureItemTag = 14;
static NSInteger const RainXItemTag = 10;
static NSInteger const Rain0ItemTag = 11;
static NSInteger const Rain_ItemTag = 12;

@interface RainNumberKeyBoardView()<UIInputViewAudioFeedback>

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RainNumberKeyBoardView

- (id)initWithFrame:(CGRect)frame keyBoardStyle:(RainNumberKeyBoard)type{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpViews];
        self.boardType = type;
        self.sureBtnEnable = NO;
    }
    return self;
}

- (void)setUpViews{

    UIApplication *application = [UIApplication sharedApplication];
    if(application.statusBarOrientation == UIInterfaceOrientationPortrait || application.statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        self.frame = CGRectMake(0, 0, 375, 216);
    }else if (application.statusBarOrientation == UIInterfaceOrientationLandscapeLeft || application.statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        self.frame = CGRectMake(0, 0, 375, 162);
    }
    
    self.backgroundColor = [UIColor lightGrayColor];
    for(int i = 1; i < 15; i++ ){
    
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.layer.cornerRadius = 3;
        item.layer.shadowOpacity = 0.3;
        item.layer.masksToBounds = YES;
        item.tag = i;
        item.backgroundColor = [UIColor whiteColor];
        [item addTarget:self action:@selector(pressAction:) forControlEvents:UIControlEventTouchUpInside];
        [item setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [item setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        
        if(i == RainXItemTag){
            [item setTitle:@"" forState:UIControlStateNormal];
        }
        if(i == Rain0ItemTag){
            [item setTitle:@"0" forState:UIControlStateNormal];
        }
        if(i == Rain_ItemTag){
            [item setTitle:@"" forState:UIControlStateNormal];
        }
        if(i == RainDeleteItemTag){
            [item setTitle:@"<-" forState:UIControlStateNormal];
            [item removeTarget:self action:@selector(pressAction:) forControlEvents:UIControlEventTouchUpInside];
            [item addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchDown];
        }
        if(i == RainSureItemTag){
            [item setTitle:@"确定" forState:UIControlStateNormal];
            [item setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        }
        [self addSubview:item];
    }
}

- (void)deleteAction:(UIButton *)sender{
    [self pressAction:sender];
    [self performSelector:@selector(setATimer:) withObject:sender afterDelay:0.5];
}

- (void)setATimer:(UIButton *)sender{
    if(!self.timer){
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(continueDelete:) userInfo:sender repeats:YES];
        self.timer = timer;
    }
}

- (void)continueDelete:(NSTimer *)time{
    UIButton *btn = time.userInfo;
    if(!btn.highlighted){
        [self stopDelete];
    }
    [self pressAction:btn];
}

- (void)stopDelete{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)setBoardType:(RainNumberKeyBoard)boardType{
    _boardType = boardType;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    switch (boardType) {
        case RainNumberKeyBoardwithX:{
            button = [self viewWithTag:RainXItemTag];
            [button setTitle:@"X" forState:UIControlStateNormal];
        }
            break;
        case RainNumberKeyBoardwithPoint:{
            button = [self viewWithTag:Rain_ItemTag];
            [button setTitle:@"." forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)pressAction:(UIButton *)sender{
    if(sender.tag <= 12){
        if([self.delegate respondsToSelector:@selector(rainNumberKeyBoardView:didSelectItem:)]){
            [self.delegate rainNumberKeyBoardView:self didSelectItem:sender];
        }
    }else if (sender.tag == 13){
        if([self.delegate respondsToSelector:@selector(rainNumberKeyBoardView:didSelectDeleteItem:)]){
          BOOL flag = [self.delegate rainNumberKeyBoardView:self didSelectDeleteItem:sender];
            if(!flag){
                return;
            }
        }
    }else if (sender.tag == 14){
        if([self.delegate respondsToSelector:@selector(rainNumberKeyBoardView:didSelectSureItem:)]){
            [self.delegate rainNumberKeyBoardView:self didSelectSureItem:sender];
        }
    }
}

- (BOOL)enableInputClicksWhenVisible{
    return YES;
}

- (void)setSureBtnEnable:(BOOL)sureBtnEnable{
    _sureBtnEnable = sureBtnEnable; 
    UIButton *btn = [self viewWithTag:RainSureItemTag];
    btn.enabled = sureBtnEnable;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat screenWidth = self.frame.size.width;
    CGFloat space = 10.0;
    
    CGFloat height = (CGRectGetHeight(self.frame) - space * 5)/4.0;
    CGFloat width = (screenWidth - space * 5) / 4.0;
    CGFloat spaceHeight = 2 * height + space;
    
    for (NSInteger i = 0; i<self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        float x = i % 3 * (width + space) + space;
        float y = i / 3 * (height + space) + space;
        view.frame = CGRectMake(x, y, width, height);
        if (i + 1 == RainDeleteItemTag) {//删除按钮
            view.frame = CGRectMake(3*width + 4 * space,  space, width, spaceHeight);
        }
        if (i + 1 == RainSureItemTag) {//确认按钮
            view.frame = CGRectMake(3*width + 4 * space, spaceHeight + 2 * space, width, spaceHeight);
        }
    }
}

@end
