//
//  RainViewController.m
//  RainTextfield
//
//  Created by yu_ios_mark@163.com on 08/07/2017.
//  Copyright (c) 2017 yu_ios_mark@163.com. All rights reserved.
//

#import "RainViewController.h"
#import <RainTextfield/RainTextField.h>

@interface RainViewController ()

@end

@implementation RainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    RainTextField *text = [[RainTextField alloc]initWithFrame:CGRectMake(20, 100, 200, 40)];
    text.textFieldKeyBoard = RainTextFieldKeyBoardwithX;
    [self.view addSubview:text];
    text.layer.borderWidth = 1;
    text.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
