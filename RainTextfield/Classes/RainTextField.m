//
//  RainTextField.m
//  OC_WC_Demo
//
//  Created by 喻永权 on 2017/8/3.
//  Copyright © 2017年 喻永权. All rights reserved.
//

#import "RainTextField.h"
#import "RainNumberKeyBoardView.h"

static const CGFloat kHeightForPortrait = 216.0;
static const CGFloat kHeightForLandscape = 162.0;

@interface RainTextField()<RainNumberKeyBoardDelegate>

@property (nonatomic, strong) RainNumberKeyBoardView *inputKeyBoardView;

@end

@implementation RainTextField

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if(self){
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews{
    self.inputView = self.inputKeyBoardView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

-(void)handleDeviceOrientationDidChange{
    
    UIApplication *app = [UIApplication sharedApplication];
    UIDevice *device = [UIDevice currentDevice];
    if (app.statusBarOrientation == UIInterfaceOrientationPortrait||app.statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown||(device.orientation == UIDeviceOrientationLandscapeLeft&&app.statusBarOrientation == UIDeviceOrientationLandscapeRight)||(device.orientation == UIDeviceOrientationLandscapeRight&&app.statusBarOrientation == UIDeviceOrientationLandscapeLeft)) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            
            NSLayoutConstraint *height1 = [self.inputKeyBoardView.constraints firstObject];
            if (!height1) {
                CGRect frame = self.inputKeyBoardView.frame;
                frame.size.height = kHeightForLandscape;
                self.inputKeyBoardView.frame = frame;
            }else{
                height1.constant = kHeightForLandscape;
            }
            
        }else{
            
            CGRect frame = self.inputKeyBoardView.frame;
            frame.size.height = kHeightForLandscape;
            self.inputKeyBoardView.frame = frame;
        }
        
    }else if (app.statusBarOrientation == UIInterfaceOrientationLandscapeLeft||app.statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            
            NSLayoutConstraint *height1 = [self.inputKeyBoardView.constraints firstObject];
            if (!height1) {
                
                CGRect frame = self.inputKeyBoardView.frame;
                frame.size.height = kHeightForPortrait;
                self.inputKeyBoardView.frame = frame;
            }else{
                height1.constant = kHeightForPortrait;
            }            
        }else{
            
            CGRect frame = self.inputKeyBoardView.frame;
            frame.size.height = kHeightForPortrait;
            self.inputKeyBoardView.frame = frame;
        }
    }
    
}


- (void)textChanged{
    [self resetSureBtn];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self resetSureBtn];
}

- (void)resetSureBtn{

    self.inputKeyBoardView.sureBtnEnable = self.text.length;

}

- (void)setTextFieldKeyBoard:(RainTextFieldKeyBoard)textFieldKeyBoard{
    _textFieldKeyBoard = textFieldKeyBoard;
    if(RainTextFieldKeyBoardDefault == textFieldKeyBoard){
        _inputKeyBoardView.boardType = RainTextFieldKeyBoardDefault;
    }
    if (textFieldKeyBoard == RainTextFieldKeyBoardwithPoint){
        _inputKeyBoardView.boardType = RainNumberKeyBoardwithPoint;
    }
    if(textFieldKeyBoard == RainTextFieldKeyBoardwithX){
        _inputKeyBoardView.boardType = RainNumberKeyBoardwithX;
    }
    self.inputView = self.inputKeyBoardView;
    [self reloadInputViews];
}

- (RainNumberKeyBoardView *)inputKeyBoardView{
    if(_inputKeyBoardView == nil){
        _inputKeyBoardView = [[RainNumberKeyBoardView alloc]initWithFrame:CGRectZero keyBoardStyle:RainNumberKeyBoardDefault];
        _inputKeyBoardView.delegate = self;
    }
    return _inputKeyBoardView;;
}

#pragma mark ==RainNumberKeyBoardDelegate
- (void)rainNumberKeyBoardView:(RainNumberKeyBoardView *)boardView didSelectSureItem:(UIButton *)item{
    if([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]){
        [self.delegate textFieldShouldReturn:self];
    }
}

- (BOOL)rainNumberKeyBoardView:(RainNumberKeyBoardView *)boardView didSelectDeleteItem:(UIButton *)item{
    
    if(self.text.length <= 0){
        return NO;
    }
    if([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
        NSRange range = [self selectRange];
        if(range.length == 0){
            range = NSMakeRange([self selectRange].location - 1, 1);
        }
        BOOL ret = [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:@""];
        if(!ret){
            return NO;
        }
    }
    
    [self deleteBackward];
    return YES;
}

- (void)rainNumberKeyBoardView:(RainNumberKeyBoardView *)boardView didSelectItem:(UIButton *)item{
    if([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
        NSRange range = [self selectRange];
        BOOL ret = [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:item.currentTitle];
        if(!ret){
            return;
        }
    }
    //插入到当前的textfeild的text中
    [self insertText:item.currentTitle];
}

- (NSRange)selectRange{
    UITextPosition *begin = self.beginningOfDocument;
    UITextRange *seletRange = self.selectedTextRange;
    UITextPosition *selectStart = seletRange.start;
    UITextPosition *selectEnd = seletRange.end;
    NSInteger location = [self offsetFromPosition:begin toPosition:selectStart];
    NSInteger length = [self offsetFromPosition:selectStart toPosition:selectEnd];
    return NSMakeRange(location, length);
}

@end
